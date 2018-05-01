---
layout: post
title: MIT 6828 Lab 2：Memory Management
categories: [-02 Operating System]
tags: [Operating System, Unix]
number: [-02.1]
fullview: false
shortinfo: 本文是MIT 6828操作系统课程lab1的笔记。

---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1  介绍 ##

## 2 Lab 2:  Memory Management ##

### Part 1: Physical Page Management ###


The operating system must keep track of which parts of physical RAM are free and which are currently in use. JOS manages the PC's physical memory with page granularity so that it can use the MMU to map and protect each piece of allocated memory.

You'll now write the physical page allocator. It keeps track of which pages are free with a linked list of struct PageInfo objects (which, unlike xv6, are not embedded in the free pages themselves), each corresponding to a physical page. You need to write the physical page allocator before you can write the rest of the virtual memory implementation, because your page table management code will need to allocate physical memory in which to store page tables.

#### 2.1.1 Exercise 1: Implement Physical Memory Allocator

<blockquote>
Exercise 1. In the file kern/pmap.c, you must implement code for the following functions (probably in the order given).
boot_alloc()
mem_init() (only up to the call to check_page_free_list(1))
page_init()
page_alloc()
page_free()

check_page_free_list() and check_page_alloc() test your physical page allocator. You should boot JOS and see whether check_page_alloc() reports success. Fix your code so that it passes. You may find it helpful to add your own assert()s to verify that your assumptions are correct.
</blockquote>

`#define PGSIZE 4096`定义在`inc/mmu.h`。`mem_init`函数告诉我们，`boot_alloc`是用来初始化页目录(page directory)。在`boot_alloc`中，`nextfree`为下一个空闲内存的虚拟内存地址，当`nextfree`为空时会先初始化。用到了`ROUNDUP`，这个`ROUNDUP`在`/inc/types.h`中，因为内存区域时对齐的，所以每块都是固定的大小。`npages`是页数量，可使用内存的大小是`npages * PGSIZE`，根据lab1提到的，`KERNBASE`是分配内存的起始地址，若`nextfree`大于`KERNBASE + npages * PGSIZE`的值，就是指针地址溢出了。

在`boot_alloc`：
{% highlight c linenos %}
result = nextfree;
nextfree = ROUNDUP(nextfree+n, PGSIZE);
if((uint32_t)nextfree > KERNBASE + (npages * PGSIZE)) {
    panic("Out of memory!\n");
}
{% endhighlight %}

`mem_init`在执行完`boot_alloc`后，会给`kern_pgdir`加上权限位。之后要初始化所有的`struct PageInfo`为0。首先确定`PageInfo`的大小，然后用`boot_alloc`分配内存，接着用`memset`初始化。
{% highlight c linenos %}
size_t PageInfo_size = sizeof(struct PageInfo);
pages = (struct PageInfo *)boot_alloc(npages * PageInfo_size);
memset(pages, 0, npages * PageInfo_size);
{% endhighlight %}

然后调用`page_init()`来初始化`struct PageInfo`和`page_free_list`。
{% highlight c linenos %}
void
page_init(void)
{
    // The example code here marks all physical pages as free.
    // However this is not truly the case.  What memory is free?
    //  1) Mark physical page 0 as in use.
    //     This way we preserve the real-mode IDT and BIOS structures
    //     in case we ever need them.  (Currently we don't, but...)
    //  2) The rest of base memory, [PGSIZE, npages_basemem * PGSIZE)
    //     is free.
    //  3) Then comes the IO hole [IOPHYSMEM, EXTPHYSMEM), which must
    //     never be allocated.
    //  4) Then extended memory [EXTPHYSMEM, ...).
    //     Some of it is in use, some is free. Where is the kernel
    //     in physical memory?  Which pages are already in use for
    //     page tables and other data structures?
    //
    // Change the code to reflect this.
    // NB: DO NOT actually touch the physical memory corresponding to
    // free pages!
    size_t i;
    page_free_list = NULL;

    for (i = 0; i < npages; i++) {
        if (i == 0) {
            pages[i].pp_ref = 1;
            pages[i].pp_link = NULL;
        }
        else if (i < npages_basemem){
            pages[i].pp_ref = 0;
            pages[i].pp_link = page_free_list;
            page_free_list = &pages[i];
        }
        else if (i >= IOPHYSMEM/PGSIZE && i < EXTPHYSMEM/PGSIZE) {
            pages[i].pp_ref = 1;
        }
        else if (i >= EXTPHYSMEM/PGSIZE || i < PADDR(boot_alloc(0))/PGSIZE){
            pages[i].pp_ref++;
            pages[i].pp_link = NULL;
        }
        else {
            pages[i].pp_ref = 0;
            pages[i].pp_link = page_free_list;
            page_free_list = &pages[i];
        }
    }
}
{% endhighlight %}

`page_alloc`的函数分配1个屋里也，返回对应的结构体，需要更新`page_free_list`。
{% highlight c linenos %}
struct PageInfo *
page_alloc(int alloc_flags)
{
    struct PageInfo result;
    if (!page_free_list)
        return NULL;

    result = page_free_list;
    page_free_list = page_free_list->pp_link;

    result->pp_link = NULL;

    if (alloc_flags & ALLOC_ZERO) {
        memset(page2kva(result), 0, PGSIZE);
    }

    return result;
}
{% endhighlight %}

`page_free`释放1个`struct PageInfo`，并更新`page_free_list`。
{% highlight c linenos %}
void
page_free(struct PageInfo *pp)
{
    // Fill this function in
    // Hint: You may want to panic if pp->pp_ref is nonzero or
    // pp->pp_link is not NULL.
    assert(pp->pp_ref == 0);
    assert(pp->pp_link == NULL);

    pp->pp_link = page_free_list;
    page_free_list = pp;
}
{% endhighlight %}

### Part 2: Virtual Memory ###

#### 2.2.1 Exercise 2: Understand Memory Management and Protection

<blockquote>
Exercise 2. Look at chapters 5 and 6 of the [Intel 80386 Reference Manual](https://pdos.csail.mit.edu/6.828/2017/readings/i386/toc.htm), if you haven't done so already. Read the sections about page translation and page-based protection closely (5.2 and 6.4). We recommend that you also skim the sections about segmentation; while JOS uses the paging hardware for virtual memory and protection, segment translation and segment-based protection cannot be disabled on the x86, so you will need a basic understanding of it.
</blockquote>

熟悉关于分页地址转换(page translation)和基于页的保护(page-based protection)。
首先介绍一下80386将逻辑地址转为物理地址的方法。

1. 分段地址转换，由段选择子和段偏移量构成的逻辑地址转为线性地址。
2. 分页地址转换，线性地址转为物理地址。

{: .img_middle_lg}
![Memory Management](/assets/images/posts/-02_Operating System/6828/2015-02-05-OS MIT 6828 Lab 2：Memory Managemen/Memory Management.gif)

虚拟地址(逻辑地址，程序员编程的接口地址)通过段机制，将选择子和偏移量转为线性地址；线性地址通过页机制转为物理地址。

{% highlight c linenos %}

           Selector  +--------------+         +-----------+
          ---------->|              |         |           |
                     | Segmentation |         |  Paging   |
Software             |              |-------->|           |---------->  RAM
            Offset   |  Mechanism   |         | Mechanism |
          ---------->|              |         |           |
                     +--------------+         +-----------+
            Virtual                   Linear                Physical
           (Logical)
{% endhighlight %}
C指针是虚拟地址的偏移量部分。在`boot/boot.S`中，引入全局描述符表`GDT`将所有段基址设为0到0xFFFFFFFF，因此线性地址等于虚拟地址的偏移量。

#### 2.2.2 Exercise 3: Compare Virual Address(GDB) and Physical Address(QEMU)

<blockquote>
Exercise 3. While GDB can only access QEMU's memory by virtual address, it's often useful to be able to inspect physical memory while setting up virtual memory. Review the QEMU monitor commands from the lab tools guide, especially the xp command, which lets you inspect physical memory. To access the QEMU monitor, press Ctrl-a c in the terminal (the same binding returns to the serial console).

Use the xp command in the QEMU monitor and the x command in GDB to inspect memory at corresponding physical and virtual addresses and make sure you see the same data.

Our patched version of QEMU provides an info pg command that may also prove useful: it shows a compact but detailed representation of the current page tables, including all mapped memory ranges, permissions, and flags. Stock QEMU also provides an info mem command that shows an overview of which ranges of virtual addresses are mapped and with what permissions.
</blockquote>

在QEMU中使用`xp`可以查看物理内存，VM虚拟机对于lab手册上调出QEMU monitor的方法没用，可以用下面这个命令替换`qemu-system-i386 -hda obj/kern/kernel.img -monitor stdio -gdb tcp::26000 -D qemu.log`。 
在QMUE monitor中使用`info pg`查看当前页表，`info mem`查看虚拟内存的范围。
进入保护模式后，所有地址引用都是虚拟地址，由MMU转换，也就是说C指针都是虚拟地址。
JOS内核经常需要操作地址通过整数而不解引用。JOS为了区分两种情况： 类型`uintptr_t`代表了虚拟地址，`physaddr_t`代表了物理地址。虽然都是32位整数，但是不能直接解引用，需要先转型。

JOS需要读取或修改内存，尽管只知道物理地址。给页表添加映射需要分配物理内存去存储一个页目录，然后才能初始化内存。然而内核不能绕过虚拟地址转换，因此不能直接加载和储存物理地址。为了将物理地址转为虚拟地址，内核需要在物理地址加上`0xF0000000`从而找到相关的虚拟地址，可以使用`KADDR(pa)`完成这个操作。

同样，如果内核需要通过虚拟地址去找物理地址，就需要减去`0xF0000000`，可以使用PADDR(va)完成这个操作。


之后实验经常需要将多个虚拟地址同时映射到同一块物理页上，因此更新每一个物理页的引用计数，这个值位于物理页`struct PageInfo`中的`pp_ref`字段中。


#### 2.2.3 Exercise 4: Implement PageInfo Operations

<blockquote>
Exercise 4. In the file kern/pmap.c, you must implement code for the following functions.

        pgdir_walk()
        boot_map_region()
        page_lookup()
        page_remove()
        page_insert()
	
check_page(), called from mem_init(), tests your page table management routines. You should make sure it reports success before proceeding.
</blockquote>

首先是`pgdir_walk`函数，参考注释可知，这个函数获得指向线性地址页表项的指针，传入的参数是页目录指针，线性地址(JOS将虚拟地址直接映射成了线性地址)和另外一个参数。另外许注意为新建的物理页设置页目录时，需要添加上权限位。

{% highlight c linenos %}
pte_t *
pgdir_walk(pde_t *pgdir, const void *va, int create)
{
    // Fill this function in
    pde_t *pt = pgdir + PDX(va);
    pde_t *pt_addr_v;

    if (*pt & PTE_P) {
        pt_addr_v = (pte_t *)KADDR(PTE_ADDR(*pt));
        return pt_addr_v + PTX(va);
    } else {
        struct PageInfo *newpt;
        if (create == 1 && (newpt = page_alloc(ALLOC_ZERO)) != 0) {
            memset(page2kva(newpt), 0, PGSIZE);
            newpt->pp_ref ++;
            *pt = PADDR(page2kva(newpt))|PTE_U|PTE_W|PTE_P;
            pt_addr_v = (pte_t *)KADDR(PTE_ADDR(*pt));
            return pt_addr_v + PTX(va);
        }
    }
    return NULL;
}
{% endhighlight %}

接着是`boot_map_region`函数，这个函数将虚拟地址`[va, va+size]`映射到物理地址`[pa, pa+size]`，注释中提到可以使用上面写的`pgdir_walk`，获取页表地址，接着将物理地址的值与上权限位付给页表地址。

{% highlight c linenos %}

{% endhighlight %}

之后是`page_lookup`函数，查找线性地址va对应的物理页面，找到就返回这个物理页，否则返回NULL。首先如果`pte_store`非0，则储存这个页的页表地址，这一步是为了之后的`page_remove`用的。

{% highlight c linenos %}
struct PageInfo *
page_lookup(pde_t *pgdir, void *va, pte_t **pte_store)
{
    // Fill this function in
    pte_t *pte = pgdir_walk(pgdir, va, 0);
    if (pte_store != 0) {
        *pte_store = pte;
    }
    if (pte != NULL && (*pte & PTE_P)) {
        return pa2page(PTE_ADDR(*pte));
    }
    return NULL;
}
{% endhighlight %}

`page_remove`函数算是比较容易的，参考注释里的提示，先通过`page_lookup`获得物理页，如果存在则执行删除工作`page_decref`，同时也要将`va`地址的页表项设为0，最后就是验证有效性。

{% highlight c linenos %}
void
page_remove(pde_t *pgdir, void *va)
{
    // Fill this function in
    pte_t *pte;
    struct PageInfo *page = page_lookup(pgdir, va, &pte);
    if (page) {
        page_decref(page);
        *pte = 0;
        tlb_invalidate(pgdir, va);
    }
}
{% endhighlight %}

最后一步就是`page_insert`函数，将页面管理结构`pp`所对应的物理页面分配给线性地址`va`。同时，将对应的页表项的`permission`设置成`PTE_P&perm`。注意：一定要考虑到线性地址va已经指向了另外一个物理页面或者干脆就是这个函数要指向的物理页面的情况。如果线性地址`va`已经指向了另外一个物理页面，则先要调用`page_remove`将该物理页从线性地址`va`处删除，再将`va`对应的页表项的地址赋值为`pp`对应的物理页面。如果`va`指向的本来就是参数`pp`所对应的物理页面，则将`va`对应的页表项中的物理地址赋值重新赋值为`pp`所对应的物理页面的首地址即可。

{% highlight c linenos %}
int
page_insert(pde_t *pgdir, struct PageInfo *pp, void *va, int perm)
{
    // Fill this function in
    pte_t *pte = pgdir_walk(pgdir, va, 1);
    if (!pte) {
        return -E_NO_MEM;
    }  
    if (*pte & PTE_P) {
        if (PTE_ADDR(*pte) == page2pa(pp)) {
            tlb_invalidate(pgdir, va);
            pp->pp_ref--;
        }
        else {
            page_remove(pgdir, va);
        }
    }
    *pte = page2pa(pp) | perm | PTE_P;
    pp->pp_ref++;
    pgdir[PDX(va)] |= perm;
    return 0;
}
{% endhighlight %}


### Part 3: Kernel Address Space ###

#### 2.3.1 Exercise 5: Compare Virual Address(GDB) and Physical Address(QEMU)


<blockquote>
Exercise 5. Fill in the missing code in mem_init() after the call to check_page().

Your code should now pass the check_kern_pgdir() and check_page_installed_pgdir() checks.
</blockquote>

因为`mem_init`开头创建了初始化页目录`kern_pgdir`，首先是将pages数组映射到线性地址`UPAGES`，权限是内核只读。
接着是映射物理地址到内核栈，也就是从地址范围`[KSTACKTOP-KSTKSIZE, KSTACKTOP)`映射到bootstack开始的物理地址页上，注释中提到了，只要映射`[KSTACKTOP-KSTKSIZE, KSTACKTOP)`，`[KSTACKTOP-PTSIZE, KSTACKTOP-KSTKSIZE)`不映射，权限位是内核读写。最后是映射虚拟地址[KERNBASE， 2^32)到物理地址[0, 2^32-KERNBASE]，权限位是内核读写。



{% highlight c linenos %}
boot_map_region(kern_pgdir, UPAGES, PTSIZE, PADDR(pages),PTE_U);
boot_map_region(kern_pgdir, KSTACKTOP-KSTKSIZE, KSTKSIZE, PADDR(bootstack), PTE_W);
boot_map_region(kern_pgdir, KERNBASE, (0xffffffff-KERNBASE), 0, PTE_W);
{% endhighlight %}

## 3 Homework

### 3.1 System Calls


题目要求见[xv6 system calls](https://pdos.csail.mit.edu/6.828/2017/homework/xv6-syscall.html)。

#### 3.1.1 System Call Tracing

<blockquote>
> 要求system call输出
fork -> 2
exec -> 0
open -> 3
close -> 0
$write -> 1
 write -> 1
</blockquote>

在`syscall.c`中修改`syscall`函数。
{% highlight c linenos %}
void
syscall(void)
{
  int num;

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
    switch (num) {
      case SYS_fork:
        cprintf("fork -> ");
        break;
      case SYS_exit:
        cprintf("exit -> ");
        break;
      case SYS_wait:
        cprintf("wait -> ");
        break;
      case SYS_pipe:
        cprintf("pipe -> ");
        break;
      case SYS_read:
        cprintf("read -> ");
        break;
      case SYS_kill:
        cprintf("kill -> ");
        break;
      case SYS_exec:
        cprintf("exec -> ");
        break;
      case SYS_fstat:
        cprintf("fstat -> ");
        break;
      case SYS_chdir:
        cprintf("chdir -> ");
        break;
      case SYS_dup:
        cprintf("dup -> ");
        break;
      case SYS_getpid:
        cprintf("getpid -> ");
        break;
      case SYS_sbrk:
        cprintf("sbrk -> ");
        break;
      case SYS_sleep:
        cprintf("sleep -> ");
        break;
      case SYS_uptime:
        cprintf("uptime -> ");
        break;
      case SYS_open:
        cprintf("open -> ");
        break;
      case SYS_write:
        cprintf("write -> ");
        break;
      case SYS_mknod:
        cprintf("mknod -> ");
        break;
      case SYS_unlink:
        cprintf("unlink -> ");
        break;
      case SYS_link:
        cprintf("link -> ");
        break;
      case SYS_mkdir:
        cprintf("mkdir -> ");
        break;
      case SYS_close:
        cprintf("close -> ");
        break;
      default:
        panic("should never get here\n");
    }
    cprintf("%d\n", proc->tf->eax);
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
  }
}
{% endhighlight %}

#### 3.1.2 Date System call

实现date系统调用，关键要理解调用的逻辑，可以输入`grep -n uptime *.[chS]`查看系统调用`uptime`在哪些文件实现。

{% highlight c linenos %}
syscall.c:105:extern int sys_uptime(void);
syscall.c:122:[SYS_uptime]  sys_uptime,
syscall.c:183:      case SYS_uptime:
syscall.c:184:        cprintf("uptime -> ");
syscall.h:15:#define SYS_uptime 14
sysproc.c:83:sys_uptime(void)
user.h:25:int uptime(void);
usys.S:31:SYSCALL(uptime)
{% endhighlight %}

我们来理一遍调用顺序，

当在shell输入`date`后，会fork1个子进程，然后子进程exec执行`date()`(the main code in date.c)。date.c的`main`函数会执行`int date(struct rtcdate *r)`，这是系统调用的接口，会调用usys.S里的`SYSCALL(date)`，这是1个宏，将date定义在syscall.h里的index输入%eax，然后调用`T_SYSCALL`，它会获取`syscalls`(syscall.c)里的函数指针，然后调用`sys_date`。因此需要修改的代码如下。

{% highlight c linenos %}
//in date.c
printf(1,"%d/%d/%d %d:%d:%d\n", r.year,r.month,r.day,r.hour,r.minute,r.second); //line 14

// in user.h
int date(struct rtcdate *); // line 26

// in usys.S
SYSCALL(date) // line 32

// in syscall.h
#define SYS_date 22 // line 23

// in syscall.c
extern int sys_date(void) // line 106

// in sysproc.c
int                 // line 93
sys_date(void)
{
  struct rtcdate *r;
  if (argptr(0, (char **) &r, sizeof(struct rtcdate)) < 0)
    return -1;
  cmostime(r);
  return 0;
}

// in Makefile
_date\ line 177
{% endhighlight %}






### 3.2 Lazy Page Allocation

题目要求见[xv6 lazy page allocation](https://pdos.csail.mit.edu/6.828/2017/homework/xv6-zero-fill.html)。
{% highlight c linenos %}

{% endhighlight %}

## 5 参考资料 ##

- [《xv6 book - chapter 0: Operating System Interfaces》](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-828-operating-system-engineering-fall-2012/lecture-notes-and-readings/);





