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

### 2.2 Part B: Page Faults, Breakpoints Exceptions, and System Calls

#### 2.2.1 Exercise 5: Handling Page Faults

## 3 Homework

### 3.1 HW5: Multithreading Programming

### 3.2 HW6: uthreads

{: .img_middle_lg}
![cprintf](/assets/images/posts/-02_Operating System/6828/2015-02-04-OS MIT 6828 Part I：Operating system interfaces/cprintf.png)

{% highlight c linenos %}`

{% endhighlight %}

## 5 参考资料 ##

- [《xv6 book - chapter 0: Operating System Interfaces》](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-828-operating-system-engineering-fall-2012/lecture-notes-and-readings/);





