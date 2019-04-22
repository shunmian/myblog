---
layout: post
title: MIT 6828 Lab 3：User Environments
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

## 1 介紹 ##

## 2 Lab 3:  User Environments ##

这个lab需要我们实现内核的基本功能来运行1个保护模式下的用户模式的程序。具体步骤包括了:

1. 设置用于追踪user environemnts的data structure;
2. 创建1个single user environment;
3. 加载1个program image;
4. 开始运行该program。

### 2.1 Part A: User Environments and Exception Handling

`inc/env.h`包含了用户环境的定义，内核使用`ENV`数据结构记录每个用户环境，这里用户环境有点像上下文，这个lab只要创建一个环境，弹药设计JOS内核让其支持多环境。

在`kern/env.c`中定义了三个全局变量：

{% highlight c linenos %}`
struct Env *envs = NULL; // All environments
struct Env *curenv = NULL; // The current env
static struct Env *env_free_list: // Free environment list
{% endhighlight %}

JOS运行以后，envs指针指向1个存放系统中各种环境的`Env`结构体数组。JOS内核支持最大`NENV`（2^10, 宏定义在`inc/env.h`中）个同事活动的环境。

JOS内核使用`env_free_list`维护所有不活动的`ENV`结构体，类似空闲链表。内核使用`curenv`来表示当前运行的环境，内核启动之前这个变量是NULL。

`Env`结构体在`inc/env.h`中定义了：

{% highlight c linenos %}`
struct Env {
    struct Trapframe env_tf;    // Saved registers
    struct Env *env_link;        // Next free Env
    envid_t env_id;            // Unique environment identifier
    envid_t env_parent_id;        // env_id of this env's parent
    enum EnvType env_type;        // Indicates special system environments
    unsigned env_status;        // Status of the environment
    uint32_t env_runs;        // Number of times environment has run

    // Address space
    pde_t *env_pgdir;        // Kernel virtual address of page dir
};
{% endhighlight %}

1. `env_tf`: 定义在`inc/trap.h`中，用来存放环境停止运行时寄存器的值。内核从用户模式切换为内核模式时也会保存寄存器的值，这样之后环境恢复的时候可以读取出来。
2. `env_link`: 指向`env_free_list`中的下一个`Env`，`Env_free_list`指向空闲`env`链表的第一个env环境。
3. `env_id`: 当前`Env`环境的唯一id，即使用户环境终止，这个结构体被重新分配在同一块空间，这个id值还是不同的。
4. `env_parent_id`: 内核存储`env_id`环境的父用户环境id。
5. `env_type`: 用来区别特定环境。大部分情况是`ENV_TYPE_USER`。
6. `env_status`: 这个变量保存了以下几种值。
    * `ENV_FREE`: Indicates that the Env struture is inactive, and therefore on the `env_free_list`.
    * `ENV_RUNNABLE`: Indicates that the Env structure represents an environment that is waiting to trun on the processor.
    * `ENV_RUNNING`: Indicates that the Env structure represents the currently running environment.
    * `ENV_NOT_RUNNABLE`: Indicates that the Env struture represents a currently active environment, but it is not currently ready to run: for example, because it is waiting for an interprocess comminication(IPC) from another environment..
    * `ENV_DYING`: Indicates that the Env structure represents a zombie environment. A zombie environment will be freed the next time it traps to the kernerl. We will not use this flag until Lab 4.
7. `env_pgdir`: This variable holds the kernel virtual address of this environment's page directory。

如同Unix进程， JOS环境结合了线程和地址空间。线程通常由被保存的寄存器定义，地址空间由`env_pgdir`指向的页目录和页表定义。想要运行环境必须给CPU设置何时的寄存器和地址空间。



#### 2.1.1 Exercise 1: Allocating the Environments Array

<blockquote>
**Exercise 1.** Modify mem_init() in kern/pmap.c to allocate and map the envs array. This array consists of exactly NENV instances of the Env structure allocated much like how you allocated the pages array. Also like the pages array, the memory backing envs should also be mapped user read-only at UENVS (defined in inc/memlayout.h) so user processes can read from this array.

You should run your code and make sure check_kern_pgdir() succeeds.
</blockquote>

{% highlight c linenos %}`
// Make 'envs' point to an array of size 'NENV' of 'struct Env'.
// LAB 3: Your code here.
envs = (struct Env*)boot_alloc(NENV*sizeof(struct Env));
memset(envs, 0, NENV*sizeof(struct Env));
{% endhighlight %}

接着是映射。

{% highlight c linenos %}`
// Map the 'envs' array read-only by the user at linear address UENVS
// (ie. perm = PTE_U | PTE_P).
// Permissions:
//    - the new image at UENVS  -- kernel R, user R
//    - envs itself -- kernel RW, user NONE
// LAB 3: Your code here.
boot_map_region(kern_pgdir, UENVS, PTSIZE, PADDR(envs), PTE_U);
{% endhighlight %}

通过make qemu-nox可看到`check_kern_pgdir() succeeded!`。

#### 2.1.1 Exercise 2: Creating and Running Environments

<blockquote>
**Exercise 2.** In the file env.c, finish coding the following functions:

env_init()
Initialize all of the Env structures in the envs array and add them to the env_free_list. Also calls env_init_percpu, which configures the segmentation hardware with separate segments for privilege level 0 (kernel) and privilege level 3 (user).
env_setup_vm()
Allocate a page directory for a new environment and initialize the kernel portion of the new environment's address space.
region_alloc()
Allocates and maps physical memory for an environment
load_icode()
You will need to parse an ELF binary image, much like the boot loader already does, and load its contents into the user address space of a new environment.
env_create()
Allocate an environment with env_alloc and call load_icode to load an ELF binary into it.
env_run()
Start a given environment running in user mode.
As you write these functions, you might find the new cprintf verb %e useful -- it prints a description corresponding to an error code. For example,

	r = -E_NO_MEM;
	panic("env_alloc: %e", r);
will panic with the message "env_alloc: out of memory".
</blockquote>

env_init里, 初始化env数组，因为envs中的env_link指向的是下一个env,所以这里有个技巧是从envs的最后一个元素向前遍历。

{% highlight c linenos %}
void
env_init(void)
{
    // Set up envs array
    // LAB 3: Your code here.
    int i;
    env_free_list = NULL;
    for (i = NENV - 1; i >= 0; i--) {
        envs[i].env_id = 0;
        envs[i].env_status = ENV_FREE;
        envs[i].env_link = env_free_list;
        env_free_list = &envs[i];
    }
    // Per-CPU part of the initialization
    env_init_percpu();
}
{% endhighlight %}

env_setup_vm: 设置`e->env_pgdir`并初始化页目录，可以使用kern_pgdir作为模板。填上这个，计数器加一，将p转化为内核虚拟地址，然后以`kern_pgdir`为模板复制。

{% highlight c linenos %}
p->pp_ref++;
e->env_pgdir = page2kva(p);
memcpy(e->env_pgdir, kern_pgdir, PGSIZE);
{% endhighlight %}

region_alloc
分配len字节的物理内存给env环境，之后映射到环境中的虚拟地址va。要注意的是，va和len都要进行对齐。
{% highlight c linenos %}
static void
region_alloc(struct Env *e, void *va, size_t len)
{
    // LAB 3: Your code here.
    // (But only if you need it for load_icode.)
    //
    // Hint: It is easier to use region_alloc if the caller can pass
    //   'va' and 'len' values that are not page-aligned.
    //   You should round va down, and round (va + len) up.
    //   (Watch out for corner-cases!)
    struct PageInfo *p = NULL;
    va = ROUNDDOWN(va, PGSIZE);
    void * end = (void *)ROUNDUP(va + len, PGSIZE);
    for (; va <= end; va+=PGSIZE) {
        if (!(p = page_alloc(ALLOC_ZERO)))
            panic("allocation failed.");

        // pte_t *pte = pgdir_walk(e->env_pgdir, va, true);
        // if (!pte)
        //     panic("Unable to alloc page.");

        int r = page_insert(e->env_pgdir, p, va, PTE_U | PTE_W);
        if (r != 0)
            panic("Page mapping failed.");
    }}
{% endhighlight %}

load_icode: 加载可读的ELF二进制镜像到用户环境内存，起始虚拟地址在ELF程序头部应该有，同时将这些段清零，和boot loader类似，之后映射给程序初始栈的一个页。只加载ph->p_type == ELF_PGROP_LOAD的段，每个段的虚拟地址应该在`ph->p_va`，它的大小应该是`ph->p_memsz`。`binary + ph->p_offset`之后的`ph->p_files`字节要拷贝到虚拟地址`ph->p_va`，其他剩余内存应该清零。

{% highlight c linenos %}
static void
load_icode(struct Env *e, uint8_t *binary)
{
    // LAB 3: Your code here.
    struct Proghdr *ph, *eph;
    struct Elf *elf_head = (struct Elf *)binary;
    if (elf_head->e_magic != ELF_MAGIC) 
        panic("ELF binary image error.");

    lcr3(PADDR(e->env_pgdir));
    ph = (struct Proghdr*)((uint8_t*)(elf_head) + elf_head->e_phoff);
    eph = ph + elf_head->e_phnum;
    for(; ph < eph; ph++)
    {
        if (ph->p_type == ELF_PROG_LOAD) {
            region_alloc(e, (void *)ph->p_va, ph->p_memsz);
            memmove((void*)ph->p_va,binary+ph->p_offset,ph->p_filesz);
            memset((void*)(ph->p_va + ph->p_filesz),0,ph->p_memsz-ph->p_filesz);
        }
    }
    e->env_tf.tf_eip = elf_head->e_entry;
    lcr3(PADDR(kern_pgdir));
    // Now map one page for the program's initial stack
    // at virtual address USTACKTOP - PGSIZE.

    // LAB 3: Your code here.
    region_alloc(e, (void *)(USTACKTOP - PGSIZE), PGSIZE);
}
{% endhighlight %}

env_create使用env_alloc创建一个env，调用load_icode来加载elf二进制镜像，设置env_type。这个env的父id应该设为0

{% highlight c linenos %}
void
env_create(uint8_t *binary, enum EnvType type)
{
    // LAB 3: Your code here.
    struct Env *e;
    int r = env_alloc(&e, 0);
    if (r)
        panic("env_alloc failed");
    load_icode(e, binary);
    e->env_type = type;
}
{% endhighlight %}

env_run: 切换上下文，首先判断当前环境是否为空，环境状态是不是ENV_RUNNING,之后将curenv指向新的环境，状态设为`ENV_RUNNING`，更新env_runs计数器，用lcr3切换到它的地址空间，使用env_poptf()存储环境计算器。

{% highlight c linenos %}
void
env_run(struct Env *e)
{
    // LAB 3: Your code here.
    if (curenv != NULL && curenv->env_status == ENV_RUNNING)
        curenv->env_status = ENV_RUNNABLE;
    curenv = e;
    curenv->env_status = ENV_RUNNING;
    curenv->env_runs++;
    lcr3(PADDR(curenv->env_pgdir));
    env_pop_tf(&(curenv->env_tf));

    panic("env_run not yet implemented");
}
{% endhighlight %}

这时候`make qemu-nox`运行时会出现内存相关错误，暂时不需要担心。
来看一下程序启动的调用顺序图

{% highlight c linenos %}
start (kern/entry.S)
    i386_init (kern/init.c)
    cons_init
    mem_init
    env_init
    trap_init (still incomplete at this point)
    env_create
    env_run
        env_pop_tf
{% endhighlight %}

编译完内核并且运行在QEMU中，正常情况应该是系统进入用户空间，执行hello二进制程序知道系统int指令。然而因为JOS还没有设置硬件使用户过度到内核，所以会出现问题。当CPU发现系统不能处理系统调用中断，会生成一个通用保护异常，进而又产生一个双重错误异常，同样因为解决不了，最终会导致三重错误(triple fault)。通常需要重启使CPU复位，这很麻烦，还好是在QEMU中，就会出现寄存器dump。

使用debugger去检查是否进入用户模式。使用`make qemu-gdb`然后在env_pop_tf处打断点。使用si单步调试，处理器执行iret指令之后的命令。

### 2.2 Part B: Page Faults, Breakpoints Exceptions, and System Calls

#### 2.2.1 Exercise 5: Handling Page Faults

## 3 Homework

### 3.1 HW5: Multithreading Programming

### 3.2 HW6: uthreads

{: .img_middle_lg}
![cprintf]({{site.url}}/assets/images/posts/-02_Operating System/6828/2015-02-04-OS MIT 6828 Part I：Operating system interfaces/cprintf.png)

{% highlight c linenos %}`

{% endhighlight %}

## 5 参考资料 ##

- [《xv6 book - chapter 0: Operating System Interfaces》](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-828-operating-system-engineering-fall-2012/lecture-notes-and-readings/);





