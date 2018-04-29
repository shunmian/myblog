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

### Part 3: Kernel Address Space ###



{: .img_middle_lg}
![cprintf](/assets/images/posts/-02_Operating System/6828/2015-02-04-OS MIT 6828 Part I：Operating system interfaces/cprintf.png)

{% highlight c linenos %}

{% endhighlight %}

## 5 参考资料 ##

- [《xv6 book - chapter 0: Operating System Interfaces》](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-828-operating-system-engineering-fall-2012/lecture-notes-and-readings/);





