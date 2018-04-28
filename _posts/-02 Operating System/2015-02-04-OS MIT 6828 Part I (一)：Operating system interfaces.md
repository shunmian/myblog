---
layout: post
title: MIT 6828 Part I (一)：Operating system interfaces
categories: [-02 Operating System]
tags: [Operating System, Unix]
number: [-10.1]
fullview: false
shortinfo: 本文对mac unix-like系统的常用命令做一个总结。

---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1 总结 ##

## 2 Lab 1:  C, Assembly, Tools, and Bootstrapping##

### 2.0 安裝环境 ###

1. [安装ubuntu 16.04LTS](https://www.jianshu.com/p/e838cd947eff);

2. 安装JOS: `git clone https://pdos.csail.mit.edu/6.828/2017/jos.git`;

2. [安装qemu](https://pdos.csail.mit.edu/6.828/2017/tools.html):

{% highlight shell linenos %}
git clone http://web.mit.edu/ccutler/www/qemu.git -b 6.828-2.2.0 // 之前需要安装依赖libsdl1.2-dev, libtool-bin, libglib2.0-dev, libz-dev, libpixman-1-dev，gcc-multilib
cd qemu
sudo make && sudo make install  // 安装结束
cd ../JOS && make qemu // 若安装成功，将会看见如下输出

=========================================================
shumian@shumian-VirtualBox:~/Desktop/6828/jos$ make qemu
qemu-system-i386 -drive file=obj/kern/kernel.img,index=0,media=disk,format=raw -serial mon:stdio -gdb tcp::26000 -D qemu.log 
6828 decimal is XXX octal!
entering test_backtrace 5
entering test_backtrace 4
entering test_backtrace 3
entering test_backtrace 2
entering test_backtrace 1
entering test_backtrace 0
leaving test_backtrace 0
leaving test_backtrace 1
leaving test_backtrace 2
leaving test_backtrace 3
leaving test_backtrace 4
leaving test_backtrace 5
Welcome to the JOS kernel monitor!
Type 'help' for a list of commands.
K> 
============================================================
{% endhighlight %}

接下来我们要讨论的主题是:

> 计算机启动后，**BIOS(mini OS)**如何通过**Boot Loader(进入保护模式，载入xv6)**最终跳转到**JOS(xv6 OS)**。

### 2.1 Part 1: PC Bootstrap

#### 2.1.1 Exercise 1: Getting Started with x86 assembly

> Exercise 1. Familiarize yourself with the assembly language materials available on the [6.828 reference page](https://pdos.csail.mit.edu/6.828/2017/reference.html). You don't have to read them now, but you'll almost certainly want to refer to some of this material when reading and writing x86 assembly.We do recommend reading the section "The Syntax" in [Brennan's Guide to Inline Assembly](http://www.delorie.com/djgpp/doc/brennan/brennan_att_inline_djgpp.html). It gives a good (and quite brief) description of the AT&T assembly syntax we'll be using with the GNU assembler in JOS.


#### 2.1.2 Exercise 2: Using qemu and gdb to debug

> Exercise 2. Use GDB's si (Step Instruction) command to trace into the ROM BIOS for a few more instructions, and try to guess what it might be doing. You might want to look at [Phil Storrs I/O Ports Description](http://web.archive.org/web/20040404164813/members.iweb.net.au/~pstorr/pcbook/book2/book2.htm), as well as other materials on the [6.828 reference materials page](https://pdos.csail.mit.edu/6.828/2017/reference.html). No need to figure out all the details - just the general idea of what the BIOS is doing first.

打开两个terminal, `cd JOS`。第一个运行`make qemu-gdb`；第二个运行`make gdb`，会看到如下输出:

{% highlight shell linenos %}
GNU gdb (GDB) 6.8-debian
Copyright (C) 2008 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "i486-linux-gnu".
+ target remote localhost:26000
The target architecture is assumed to be i8086
[f000:fff0] 0xffff0:	ljmp   $0xf000,$0xe05b
0x0000fff0 in ?? ()
+ symbol-file obj/kern/kernel
(gdb) 
{% endhighlight %}

`[f000:fff0] 0xffff0:	ljmp   $0xf000,$0xe05b` 这行告诉我们: 当PC启动时，会载入BIOS, 执行BIOS。BIOS的入口地址是[f000:fff0]，即0xf000*16+0xfff0=0xffff0。由于该地址属于BIOS程序的末尾，因此没有太多空间存放代码，因此要长跳转到[f000: e05b]处。

{% highlight shell linenos %}
+------------------+  <- 0xFFFFFFFF (4GB)
|      32-bit      |
|  memory mapped   |
|     devices      |
|                  |
/\/\/\/\/\/\/\/\/\/\

/\/\/\/\/\/\/\/\/\/\
|                  |
|      Unused      |
|                  |
+------------------+  <- depends on amount of RAM
|                  |
|                  |
| Extended Memory  |
|                  |
|                  |
+------------------+  <- 0x00100000 (1MB)
|     BIOS ROM     |
+------------------+  <- 0x000F0000 (960KB)
|  16-bit devices, |
|  expansion ROMs  |
+------------------+  <- 0x000C0000 (768KB)
|   VGA Display    |
+------------------+  <- 0x000A0000 (640KB)
|                  |
|    Low Memory    |
|                  |
+------------------+  <- 0x00000000

{% endhighlight %}

当BIOS启动，它设置了一个中断描述符表并初始化多个设备比如VGA显示器。在初始化PCI总线和所有重要的设备之后，它寻找可引导的设备，之后读取 boot loader 并转移控制。

### 2.2 Part 2: The Boot Loader

#### 2.2.1 Exercise 3: BIOS->Boot Loader->Kernel

> Exercise 2. Take a look at the [lab tools guide](https://pdos.csail.mit.edu/6.828/2017/labguide.html), especially the section on GDB commands. Even if you're familiar with GDB, this includes some esoteric GDB commands that are useful for OS work. Set a breakpoint at address 0x7c00, which is where the boot sector will be loaded. Continue execution until that breakpoint. Trace through the code in boot/boot.S, using the source code and the disassembly file obj/boot/boot.asm to keep track of where you are. Also use the x/i command in GDB to disassemble sequences of instructions in the boot loader, and compare the original boot loader source code with both the disassembly in obj/boot/boot.asm and GDB. Trace into bootmain() in boot/main.c, and then into readsect(). Identify the exact assembly instructions that correspond to each of the statements in readsect(). Trace through the rest of readsect() and back out into bootmain(), and identify the begin and end of the for loop that reads the remaining sectors of the kernel from the disk. Find out what code will run when the loop is finished, set a breakpoint there, and continue to that breakpoint. Then step through the remainder of the boot loader.

boot loader的入口地址是[0000: 7c00]，因此在此处设置断点后，输入`c`，运行到此处。boot loader的主要工作是

1. 做好16位(实模式)到32位(保护模式)转变的准备，主要设置GDT(Global Descriptor Table, 用于32位模式下的逻辑地址到物理地址的转变，见[Writing a Simple Operating System from Scratch](http://www.cs.bham.ac.uk/~exr/lectures/opsys/10_11/lectures/os-dev.pdf))

2. 进入32位实模式。

2. 载入内核。

我们来过一遍boot.S文件
首先关中断，清零方向标志位DF(`cld`)。
{% highlight asm linenos %}
start:
  .code16                     # 16位汇编模式
  cli                         # 关中断
  cld                         # String operations increment
{% endhighlight %}

接着清零DS，ES，SS寄存器
{% highlight asm linenos %}
 # Set up the important data segment registers (DS, ES, SS).
  xorw    %ax,%ax             # Segment number zero
  movw    %ax,%ds             # -> Data Segment
  movw    %ax,%es             # -> Extra Segment
  movw    %ax,%ss             # -> Stack Segment
{% endhighlight %}

开启A20
{% highlight asm linenos %}
  # Enable A20:
  #   For backwards compatibility with the earliest PCs, physical
  #   address line 20 is tied low, so that addresses higher than
  #   1MB wrap around to zero by default.  This code undoes this.
seta20.1:
  inb     $0x64,%al               # Wait for not busy
  testb   $0x2,%al
  jnz     seta20.1

  movb    $0xd1,%al               # 0xd1 -> port 0x64
  outb    %al,$0x64

seta20.2:
  inb     $0x64,%al               # Wait for not busy
  testb   $0x2,%al
  jnz     seta20.2

  movb    $0xdf,%al               # 0xdf -> port 0x60
  outb    %al,$0x60
{% endhighlight %}


切换到32位保护模式：设置全局描述符表，修改cr0的值($CR0_PE_ON值为0x1，代表启动保护模式的flag标志)
{% highlight asm linenos %}
  # Switch from real to protected mode, using a bootstrap GDT
  # and segment translation that makes virtual addresses 
  # identical to their physical addresses, so that the 
  # effective memory map does not change during the switch.
  lgdt    gdtdesc
  movl    %cr0, %eax
  orl     $CR0_PE_ON, %eax
  movl    %eax, %cr0
{% endhighlight %}

`0x7c2d: ljmp $0x8,$0x7c32`跳转到32位代码。
{% highlight asm linenos %}
  # Jump to next instruction, but in 32-bit code segment.
  # Switches processor into 32-bit mode.
  ljmp    $PROT_MODE_CSEG, $protcseg
{% endhighlight %}

修改了寄存器的值
{% highlight asm linenos %}
protcseg:
  # Set up the protected-mode data segment registers
  movw    $PROT_MODE_DSEG, %ax    # Our data segment selector
  movw    %ax, %ds                # -> DS: Data Segment
  movw    %ax, %es                # -> ES: Extra Segment
  movw    %ax, %fs                # -> FS
  movw    %ax, %gs                # -> GS
  movw    %ax, %ss                # -> SS: Stack Segment
{% endhighlight %}

设置栈寄存器，调用bootmain函数。
{% highlight asm linenos %}
  # Set up the stack pointer and call into C.
  movl    $start, %esp
  call bootmain
{% endhighlight %}

bootmain逻辑:
1. readseg读取第一遍，判断是否是valid ELF
2. 若是，则从ELF header(ELFHDR)重新读取ELF program header里的各个entry(ELFHDR->e_phnum)
2. 最后执行kernel的入口(ELFHDR->e_entry).

For purposes of 6.828, you can consider an ELF executable to be a header with loading information, followed by several program sections, each of which is a contiguous chunk of code or data intended to be loaded into memory at a specified address. The boot loader does not modify the code or data; it loads it into memory and starts executing it. You can inspect the program headers by typing: `objdump -x obj/kern/kernel`

Questions:

1. At what point does the processor start executing 32-bit code? What exactly causes the switch from 16- to 32-bit mode? `(line 55) ljmp    $PROT_MODE_CSEG, $protcseg`这行代码执行后，正式进入32位模式。

2. What is the last instruction of the boot loader executed? `7d6b: call   *0x10018 ( ((void (*)(void)) (ELFHDR->e_entry))())`这条代码将会执行kernel的入口，自此，boot loader将控制权转交给kernal. What is the first instruction of the kernel it just loaded? `b 0x7d6b` and `c`, you will go to the first instruction of kernel, and you will see the first instruction is `0x10000c:	movw   $0x1234,0x472`.

2. Where is the first instruction of the kernel? It is in 0x10000c.

4. How does the boot loader decide how many sectors it must read in order to fetch the entire kernel from disk? Where does it find this information? It reads twice from the hard drive. The first time, it reads ELFHDR, which contains the meta data of how many sectors to fetch the entire kernel. The second time, according to the information in ELFHDR, it reads all the program segment.

#### 2.2.2 Exercise 4: C Pointer

> Exercise 4. Read about programming with pointers in C. The best reference for the C language is The C Programming Language by Brian Kernighan and Dennis Ritchie (known as 'K&R'). We recommend that students purchase this book (here is an [Amazon Link](http://www.amazon.com/C-Programming-Language-2nd/dp/0131103628/sr=8-1/qid=1157812738/ref=pd_bbs_1/104-1502762-1803102?ie=UTF8&s=books)) or find one of [MIT's 7 copies](http://library.mit.edu/F/AI9Y4SJ2L5ELEE2TAQUAAR44XV5RTTQHE47P9MKP5GQDLR9A8X-10422?func=item-global&doc_library=MIT01&doc_number=000355242&year=&volume=&sub_library=). Read 5.1 (Pointers and Addresses) through 5.5 (Character Pointers and Functions) in K&R. Then download the code for [pointers.c](https://pdos.csail.mit.edu/6.828/2017/labs/lab1/pointers.c), run it, and make sure you understand where all of the printed values come from. In particular, make sure you understand where the pointer addresses in printed lines 1 and 6 come from, how all the values in printed lines 2 through 4 get there, and why the values printed in line 5 are seemingly corrupted. There are other references on pointers in C (e.g., [A tutorial by Ted Jensen](https://pdos.csail.mit.edu/6.828/2017/readings/pointers.pdf) that cites K&R heavily), though not as strongly recommended. Warning: Unless you are already thoroughly versed in C, do not skip or even skim this reading exercise. If you do not really understand pointers in C, you will suffer untold pain and misery in subsequent labs, and then eventually come to understand them the hard way. Trust us; you don't want to find out what "the hard way"

{% highlight asm linenos %}
void f(void)
{
    int a[4];
    int *b = malloc(16);
    int *c;
    int i;

    /*
     * %p will print the pointer address
     * a : address of a[0], from stack
     * b : address of what b points, from heap
     * c : undefined behavior! pointer to a random place in the memory
     */
    printf("1: a = %p, b = %p, c = %p\n", a, b, c);

    /*
     * c points to a[0]
     */
    c = a;
    for (i = 0; i < 4; i++)
      a[i] = 100 + i;//a[4] = {100, 101, 102, 103}
    c[0] = 200;//a[4] = {200, 101, 102, 103}
    printf("2: a[0] = %d, a[1] = %d, a[2] = %d, a[3] = %d\n",
       a[0], a[1], a[2], a[3]);

     /*
      * c[1] is equivalent to a[1]
      * *(c + 2) is equivalent to c[2] and a[2]
      * 3[c] is equivalent to *(3 + c), also c[3] and a[3]
      */
    c[1] = 300;//a[4] = {200, 300, 102, 103}
    *(c + 2) = 301;//a[4] = {200, 300, 301, 103}
    3[c] = 302;//a[4] = {200, 300, 301, 302}
    printf("3: a[0] = %d, a[1] = %d, a[2] = %d, a[3] = %d\n",
       a[0], a[1], a[2], a[3]);


    c = c + 1;//now c points to a[1]
    *c = 400;//a[4] = {200, 400, 301, 302}
    printf("4: a[0] = %d, a[1] = %d, a[2] = %d, a[3] = %d\n",
       a[0], a[1], a[2], a[3]);

     /*
      * (char *)c converts c to char*, then plus 1
      * it will make c to move one byte further from a[0]
      * Since an int is 4 bytes size, and it is stored as little-endian.
      * a[1] = 0x190, and is stored as {0x90, 0x01, 0x00, 0x00}
      * a[2] = 0x12D, and is stored as {0x2D, 0x01, 0x00, 0x00}
      * c = (int *) ((char *) c + 1)
      * and c points to {0x01, 0x00, 0x00, 0x2D}
      * after executing *c = 500, which is 0x1F4 in hex
      * *c is stored as {0xF4, 0x01, 0x00, 0x00}
      * a[1] = 128144 and is stored as {0x90, 0xF4, 0x01, 0x00}
      * a[2] = 128 and is stored as {0x00, 0x01, 0x00, 0x00}
      */
    c = (int *) ((char *) c + 1);
    *c = 500;
    printf("5: a[0] = %d, a[1] = %d, a[2] = %d, a[3] = %d\n",
       a[0], a[1], a[2], a[3]);

    b = (int *) a + 1;//b = a[1] = (int)&a + 0x4
    c = (int *) ((char *) a + 1);//c = (int)a + 0x1
    printf("6: a = %p, b = %p, c = %p\n", a, b, c);
}
{% endhighlight %}

#### 2.2.3 Exercise 5: VML vs LMA for Boot Loader

> VML(Virtual/Link Memeory Address) vs LMA (Load Memory Address)

For Boot Loader, the VMA and LMA are the same: 0x7C00.
`objdump -h obj/boot/boot.out`
{% highlight c linenos %}
Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .text         00000186  00007c00  00007c00  00000074  2**2
                  CONTENTS, ALLOC, LOAD, CODE
  1 .eh_frame     000000a8  00007d88  00007d88  000001fc  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  2 .stab         00000720  00000000  00000000  000002a4  2**2
                  CONTENTS, READONLY, DEBUGGING
  3 .stabstr      0000088f  00000000  00000000  000009c4  2**0
                  CONTENTS, READONLY, DEBUGGING
  4 .comment      00000034  00000000  00000000  00001253  2**0
                  CONTENTS, READONLY

{% endhighlight %}

> Exercise 5. Trace through the first few instructions of the boot loader again and identify the first instruction that would "break" or otherwise do the wrong thing if you were to get the boot loader's link address wrong. Then change the link address in boot/Makefrag to something wrong, run make clean, recompile the lab with make, and trace into the boot loader again to see what happens. Don't forget to change the link address back and make clean again afterward!

In boot/Makefrag, you can see

{% highlight asm linenos %}
$(OBJDIR)/boot/boot: $(BOOT_OBJS)
    @echo + ld boot/boot
    $(V)$(LD) $(LDFLAGS) -N -e start -Ttext 0x7C00 -o $@.out $^
    $(V)$(OBJDUMP) -S $@.out >$@.asm
    $(V)$(OBJCOPY) -S -O binary -j .text $@.out $@
    $(V)perl boot/sign.pl $(OBJDIR)/boot/boot
{% endhighlight %}

Change 0x7C00 to 0x7A00, `make clean` and `make`


{% highlight asm linenos %}
[   0:7c00] => 0x7c00:  cli    
[   0:7c01] => 0x7c01:  cld    
[   0:7c02] => 0x7c02:  xor    ax,ax
[   0:7c04] => 0x7c04:  mov    ds,ax
[   0:7c06] => 0x7c06:  mov    es,ax
[   0:7c08] => 0x7c08:  mov    ss,ax
[   0:7c0a] => 0x7c0a:  in     al,0x64
[   0:7c0c] => 0x7c0c:  test   al,0x2
[   0:7c0e] => 0x7c0e:  jne    0x7c0a
[   0:7c10] => 0x7c10:  mov    al,0xd1
[   0:7c12] => 0x7c12:  out    0x64,al
[   0:7c14] => 0x7c14:  in     al,0x64
[   0:7c16] => 0x7c16:  test   al,0x2
[   0:7c18] => 0x7c18:  jne    0x7c14
[   0:7c1a] => 0x7c1a:  mov    al,0xdf
[   0:7c1c] => 0x7c1c:  out    0x60,al
[   0:7c1e] => 0x7c1e:  lgdtw  ds:0x7e64
[   0:7c23] => 0x7c23:  mov    eax,cr0
[   0:7c26] => 0x7c26:  or     eax,0x1
[   0:7c2a] => 0x7c2a:  mov    cr0,eax
[   0:7c2d] => 0x7c2d:  jmp    0x8:0x7e32 ; this should lead the program to the protected mode
[f000:e05b]    0xfe05b: cmp    DWORD PTR cs:0x6574,0x0
[f000:e062]    0xfe062: jne    0xfd2b6
{% endhighlight %}

The first instruction that goes wrong is `lgdtw  ds:0x7e64`.

When VMA = 0x7C00
{% highlight asm linenos %}
[   0:7c1e] => 0x7c1e:  lgdtw  ds:0x7c64
0x00007c1e in ?? ()
(gdb) x/8b 0x07c64
0x7c64: 0x17    0x00    0x4c    0x7c    0x00    0x00    0x55    0xba
{% endhighlight %}

when VMA = 0x7E00
{% highlight asm linenos %}
[   0:7c1e] => 0x7c1e:  lgdtw  ds:0x7e64
0x00007c1e in ?? ()
(gdb) x/8b 0x7e64
0x7e64: 0x00    0x00    0x00    0x00    0x00    0x00    0x00    0x00
{% endhighlight %}

#### 2.2.4 Exercise 6: VML vs LMA for Kernel

For Kernel, VMA is 0xf0100000 and LMA is 0x00100000.

`objdump -x obj/kern/kernel`

{% highlight c linenos %}
Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .text         00001871  f0100000  00100000  00001000  2**4
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  1 .rodata       00000714  f0101880  00101880  00002880  2**5
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  2 .stab         000038d1  f0101f94  00101f94  00002f94  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  3 .stabstr      000018bb  f0105865  00105865  00006865  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  4 .data         0000a300  f0108000  00108000  00009000  2**12
                  CONTENTS, ALLOC, LOAD, DATA
  5 .bss          00000644  f0112300  00112300  00013300  2**5
                  ALLOC
  6 .comment      00000034  00000000  00000000  00013300  2**0
                  CONTENTS, READONLY

{% endhighlight %}

> Exercise 6. We can examine memory using GDB's x command. The [GDB manual](https://sourceware.org/gdb/current/onlinedocs/gdb/Memory.html) has full details, but for now, it is enough to know that the command x/Nx ADDR prints N words of memory at ADDR. (Note that both 'x's in the command are lowercase.) Warning: The size of a word is not a universal standard. In GNU assembly, a word is two bytes (the 'w' in xorw, which stands for word, means 2 bytes). Reset the machine (exit QEMU/GDB and start them again). Examine the 8 words of memory at 0x00100000 at the point the BIOS enters the boot loader, and then again at the point the boot loader enters the kernel. Why are they different? What is there at the second breakpoint? (You do not really need to use QEMU to answer this question. Just think.)

When BIOS enters the boot loader, `b 0x7c00`, `c`
{% highlight asm linenos %}
(gdb) x/8x 0x100000
0x100000:	0x00000000	0x00000000	0x00000000	0x00000000
0x100010:	0x00000000	0x00000000	0x00000000	0x00000000
{% endhighlight %}

When boot loader loads kernel, `b 0x100000`, `c`
{% highlight asm linenos %}
(gdb) x/8x 0x100000
0x100000:	0x1badb002	0x00000000	0xe4524ffe	0x7205c766
0x100010:	0x34000004	0x0000b812	0x220f0011	0xc0200fd8
{% endhighlight %}
At the point the boot loader enters the kernel, the content at the address 0x00100000 is the .text section in the kernel. The bootloader reads it using readseg after having read the header of the kernel.

{% highlight c linenos %}
// load each program segment (ignores ph flags)
ph = (struct Proghdr *) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
eph = ph + ELFHDR->e_phnum;
for (; ph < eph; ph++)
  // p_pa is the load address of this segment (as well
  // as the physical address)
  /*
   * p_pa = 0x100000 p_memsz = 0x72ca p_offset = 0x1000
   * which means to read 0x72ca bytes(Size in bytes of the segment in memory) to 0x100000 from No.((offset / SECTSIZE) + 1) sector.
   */
  readseg(ph->p_pa, ph->p_memsz, ph->p_offset);
{% endhighlight %}

### 2.3 Part 3: The Kernel

{% highlight c linenos %}

{% endhighlight %}

#### 2.2.1 Exercise 7: virtual memory

>Exercise 7. Use QEMU and GDB to trace into the JOS kernel and stop at the movl %eax, %cr0. Examine memory at 0x00100000 and at 0xf0100000. Now, single step over that instruction using the stepi GDB command. Again, examine memory at 0x00100000 and at 0xf0100000. Make sure you understand what just happened. What is the first instruction after the new mapping is established that would fail to work properly if the mapping weren't in place? Comment out the movl %eax, %cr0 in kern/entry.S, trace into it, and see if you were right.

Before `0x100025 movl %eax, %cr0`

{% highlight shell linenos %}
(gdb) x/128b 0x100000
0x100000:	0x02	0xb0	0xad	0x1b	0x00	0x00	0x00	0x00
0x100008:	0xfe	0x4f	0x52	0xe4	0x66	0xc7	0x05	0x72
0x100010:	0x04	0x00	0x00	0x34	0x12	0xb8	0x00	0x00
0x100018:	0x11	0x00	0x0f	0x22	0xd8	0x0f	0x20	0xc0
0x100020:	0x0d	0x01	0x00	0x01	0x80	0x0f	0x22	0xc0
0x100028:	0xb8	0x2f	0x00	0x10	0xf0	0xff	0xe0	0xbd
0x100030:	0x00	0x00	0x00	0x00	0xbc	0x00	0x00	0x11
0x100038:	0xf0	0xe8	0x56	0x00	0x00	0x00	0xeb	0xfe
0x100040:	0x55	0x89	0xe5	0x53	0x83	0xec	0x0c	0x8b
0x100048:	0x5d	0x08	0x53	0x68	0x80	0x18	0x10	0xf0
0x100050:	0xe8	0xa3	0x08	0x00	0x00	0x83	0xc4	0x10
0x100058:	0x85	0xdb	0x7e	0x11	0x83	0xec	0x0c	0x8d
0x100060:	0x43	0xff	0x50	0xe8	0xd8	0xff	0xff	0xff
0x100068:	0x83	0xc4	0x10	0xeb	0x11	0x83	0xec	0x04
0x100070:	0x6a	0x00	0x6a	0x00	0x6a	0x00	0xe8	0xf3
0x100078:	0x06	0x00	0x00	0x83	0xc4	0x10	0x83	0xec
(gdb) x/128b 0xf0100000
0xf0100000 <_start+4026531828>:	0x00	0x00	0x00	0x00	0x00	0x00	0x00	0x00
0xf0100008 <_start+4026531836>:	0x00	0x00	0x00	0x00	0x00	0x00	0x00	0x00
0xf0100010 <entry+4>:	0x00	0x00	0x00	0x00	0x00	0x00	0x00	0x00
0xf0100018 <entry+12>:	0x00	0x00	0x00	0x00	0x00	0x00	0x00	0x00
0xf0100020 <entry+20>:	0x00	0x00	0x00	0x00	0x00	0x00	0x00	0x00
0xf0100028 <entry+28>:	0x00	0x00	0x00	0x00	0x00	0x00	0x00	0x00
0xf0100030 <relocated+1>:	0x00	0x00	0x00	0x00	0x00	0x00	0x00	0x00
0xf0100038 <relocated+9>:	0x00	0x00	0x00	0x00	0x00	0x00	0x00	0x00
0xf0100040 <test_backtrace>:	0x00	0x00	0x00	0x00	0x00	0x00	0x00	0x00
0xf0100048 <test_backtrace+8>:	0x00	0x00	0x00	0x00	0x00	0x00	0x00	0x00
0xf0100050 <test_backtrace+16>:	0x00	0x00	0x00	0x00	0x00	0x00	0x00	0x00
0xf0100058 <test_backtrace+24>:	0x00	0x00	0x00	0x00	0x00	0x00	0x00	0x00
0xf0100060 <test_backtrace+32>:	0x00	0x00	0x00	0x00	0x00	0x00	0x00	0x00
0xf0100068 <test_backtrace+40>:	0x00	0x00	0x00	0x00	0x00	0x00	0x00	0x00
0xf0100070 <test_backtrace+48>:	0x00	0x00	0x00	0x00	0x00	0x00	0x00	0x00
0xf0100078 <test_backtrace+56>:	0x00	0x00	0x00	0x00	0x00	0x00	0x00	0x00
{% endhighlight %}

After `0x100025 movl %eax, %cr0`
{% highlight c linenos %}
(gdb) x/128b 0xf0100000
0xf0100000 <_start+4026531828>:	0x02	0xb0	0xad	0x1b	0x00	0x00	0x00	0x00
0xf0100008 <_start+4026531836>:	0xfe	0x4f	0x52	0xe4	0x66	0xc7	0x05	0x72
0xf0100010 <entry+4>:	0x04	0x00	0x00	0x34	0x12	0xb8	0x00	0x00
0xf0100018 <entry+12>:	0x11	0x00	0x0f	0x22	0xd8	0x0f	0x20	0xc0
0xf0100020 <entry+20>:	0x0d	0x01	0x00	0x01	0x80	0x0f	0x22	0xc0
0xf0100028 <entry+28>:	0xb8	0x2f	0x00	0x10	0xf0	0xff	0xe0	0xbd
0xf0100030 <relocated+1>:	0x00	0x00	0x00	0x00	0xbc	0x00	0x00	0x11
0xf0100038 <relocated+9>:	0xf0	0xe8	0x56	0x00	0x00	0x00	0xeb	0xfe
0xf0100040 <test_backtrace>:	0x55	0x89	0xe5	0x53	0x83	0xec	0x0c	0x8b
0xf0100048 <test_backtrace+8>:	0x5d	0x08	0x53	0x68	0x80	0x18	0x10	0xf0
0xf0100050 <test_backtrace+16>:	0xe8	0xa3	0x08	0x00	0x00	0x83	0xc4	0x10
0xf0100058 <test_backtrace+24>:	0x85	0xdb	0x7e	0x11	0x83	0xec	0x0c	0x8d
0xf0100060 <test_backtrace+32>:	0x43	0xff	0x50	0xe8	0xd8	0xff	0xff	0xff
0xf0100068 <test_backtrace+40>:	0x83	0xc4	0x10	0xeb	0x11	0x83	0xec	0x04
0xf0100070 <test_backtrace+48>:	0x6a	0x00	0x6a	0x00	0x6a	0x00	0xe8	0xf3
0xf0100078 <test_backtrace+56>:	0x06	0x00	0x00	0x83	0xc4	0x10	0x83	0xec
(gdb) x/128b 0xf0100000
0xf0100000 <_start+4026531828>:	0x02	0xb0	0xad	0x1b	0x00	0x00	0x00	0x00
0xf0100008 <_start+4026531836>:	0xfe	0x4f	0x52	0xe4	0x66	0xc7	0x05	0x72
0xf0100010 <entry+4>:	0x04	0x00	0x00	0x34	0x12	0xb8	0x00	0x00
0xf0100018 <entry+12>:	0x11	0x00	0x0f	0x22	0xd8	0x0f	0x20	0xc0
0xf0100020 <entry+20>:	0x0d	0x01	0x00	0x01	0x80	0x0f	0x22	0xc0
0xf0100028 <entry+28>:	0xb8	0x2f	0x00	0x10	0xf0	0xff	0xe0	0xbd
0xf0100030 <relocated+1>:	0x00	0x00	0x00	0x00	0xbc	0x00	0x00	0x11
0xf0100038 <relocated+9>:	0xf0	0xe8	0x56	0x00	0x00	0x00	0xeb	0xfe
0xf0100040 <test_backtrace>:	0x55	0x89	0xe5	0x53	0x83	0xec	0x0c	0x8b
0xf0100048 <test_backtrace+8>:	0x5d	0x08	0x53	0x68	0x80	0x18	0x10	0xf0
0xf0100050 <test_backtrace+16>:	0xe8	0xa3	0x08	0x00	0x00	0x83	0xc4	0x10
0xf0100058 <test_backtrace+24>:	0x85	0xdb	0x7e	0x11	0x83	0xec	0x0c	0x8d
0xf0100060 <test_backtrace+32>:	0x43	0xff	0x50	0xe8	0xd8	0xff	0xff	0xff
0xf0100068 <test_backtrace+40>:	0x83	0xc4	0x10	0xeb	0x11	0x83	0xec	0x04
0xf0100070 <test_backtrace+48>:	0x6a	0x00	0x6a	0x00	0x6a	0x00	0xe8	0xf3
0xf0100078 <test_backtrace+56>:	0x06	0x00	0x00	0x83	0xc4	0x10	0x83	0xec
{% endhighlight %}

So what `0x100025 movl %eax, %cr0` did is just copy memory start from 0x100000 to 0xf0100000.

If the mapping weren't in place, then `jmp *%eax` will crash the kernel, because when this instruction is executed, the eip has changed to 0xf010002C. And that address's instruction is empty, so it crash the kernel.

#### 2.2.2 Exercise 8: understand printf

> We have omitted a small fragment of code - the code necessary to print octal numbers using patterns of the form "%o". Find and fill in this code fragment.

1. Explain the interface between printf.c and console.c. Specifically, what function does console.c export? How is this function used by printf.c?

console.c exports three **'High'-levvel console I/O** function: `void cputchar(int c)`, `int getchar(void)`, `intiscons(int fdnum)`.

In print.c, `static void putch(int ch, int *cnt)` uses `cputchar` to output characters to the console.


2. Explain the following from console.c:

First, let's find the definition of CRT stuff in console.h
{% highlight c linenos %}
#define CRT_ROWS    25
#define CRT_COLS    80
#define CRT_SIZE    (CRT_ROWS * CRT_COLS)
{% endhighlight %}

We should be aware that the CRT refers to the console, so the macro above means that the console has 25 rows and 80 columns, and can display 2000 characters in total.

So now we can see what `if(crt_pos>=CRT_SIZE)` means, it means if the current position of console is greater than the size of console. In old console, it doesn't have scrollbar like nowadays, so the content of console must move upward so that a new line can be created. 

{% highlight c linenos %}
if (crt_pos >= CRT_SIZE) {
    int i;
    memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * siz  (uint16_t)); // move the whole content one line above, so that a new line is created on the console
    for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)  // fill the new line with whitespace
        crt_buf[i] = 0x0700 | ' ';
    crt_pos -= CRT_COLS;  // relocate the position
}
{% endhighlight %}

2. For the following questions you might wish to consult the notes for Lecture 2. These notes cover GCC's calling convention on the x86. Trace the execution of the following code step-by-step:
{% highlight c linenos %}
int x = 1, y = 3, z = 4;
cprintf("x %d, y %x, z %d\n", x, y, z);
{% endhighlight %}

In the call to cprintf(), to what does fmt point? To what does ap point? See [How are variable arguments implemented in gcc](http://stackoverflow.com/questions/12371450/how-are-variable-arguments-implemented-in-gcc); `fmt` points to address of `"x %d, y %d, z %d\n"`; `ap`(arguments pointer) points to address of x.

List (in order of execution) each call to cons_putc, va_arg, and vcprintf. For cons_putc, list its argument as well. For va_arg, list what ap points to before and after the call. For vcprintf list the values of its two arguments.

{% highlight c linenos %}
I will list most function which will be called during the execution of the code above in sequence, and replace the parameter with the actual value
--> means the sequence of execution
=> means equivalent
int cprintf("x %d, y %x, z %d", x, y, z)
int vcprintf("x %d, y %x, z %d", {x, y, z})
void vprintfmt(putch(), 0, "x %d, y %x, z %d", {x, y, z}) --> while ((ch = *(unsigned char *) fmt++) != '%') --> ch == 'x'
static void putch('x', 0)
void cputchar('x')
static void cons_putc('x')
serial_putc('x')
lpt_putc('x')
cga_putc('x')
void vprintfmt(putch(), 1, "x %d, y %x, z %d", {y, z}) --> while ((ch = *(unsigned char *) fmt++) != '%') --> ch == ' '
static void putch(' ', 1)
...
void vprintfmt(putch(), 2, "x %d, y %x, z %d", {y, z}) --> while ((ch = *(unsigned char *) fmt++) != '%') --> ch == '%'
case 'd'
static long long getint({x, y, z}, 0) --> return va_arg(*ap, int) => return x => return 1
goto number --> printnum(putch(), 2, 1, 10, -1, ' ') --> putch('1', 2)
void vprintfmt(putch(), 3, "x %d, y %x, z %d", {y, z}) --> while ((ch = *(unsigned char *) fmt++) != '%') --> ch == ','
static void putch(',', 3)
...
void vprintfmt(putch(), 4, "x %d, y %x, z %d", {y, z}) --> while ((ch = *(unsigned char *) fmt++) != '%') --> ch == ' '
static void putch(' ', 4)
...
void vprintfmt(putch(), 5, "x %d, y %x, z %d", {y, z}) --> while ((ch = *(unsigned char *) fmt++) != '%') --> ch == 'y'
static void putch('y', 5)
...
void vprintfmt(putch(), 6, "x %d, y %x, z %d", {y, z}) --> while ((ch = *(unsigned char *) fmt++) != '%') --> ch == ' '
static void putch(' ', 6)
...
void vprintfmt(putch(), 7, "x %d, y %x, z %d", {y, z}) --> while ((ch = *(unsigned char *) fmt++) != '%') --> ch == '%'
case 'x'
static unsigned long long getuint({y, z}, 0) --> return va_arg(*ap, int) => return y => return 3
goto number --> printnum(putch(), 7, 3, 16, -1, ' '); --> putch('3', 7)
void vprintfmt(putch(), 8, "x %d, y %x, z %d", {z}) --> while ((ch = *(unsigned char *) fmt++) != '%') --> ch == ','
static void putch(',', 8)
...
void vprintfmt(putch(), 9, "x %d, y %x, z %d", {z}) --> while ((ch = *(unsigned char *) fmt++) != '%') --> ch == ' '
static void putch(' ', 9)
...
void vprintfmt(putch(), 10, "x %d, y %x, z %d", {z}) --> while ((ch = *(unsigned char *) fmt++) != '%') --> ch == 'z'
static void putch('z', 10)
...
void vprintfmt(putch(), 11, "x %d, y %x, z %d", {z}) --> while ((ch = *(unsigned char *) fmt++) != '%') --> ch == ' '
static void putch(' ', 11)
...
void vprintfmt(putch(), 12, "x %d, y %x, z %d", {z}) --> while ((ch = *(unsigned char *) fmt++) != '%') --> ch == '%'
case 'd'
static long long getint({z}, 0) --> return va_arg(*ap, int) => return z => return 4
goto number --> printnum(putch(), 12, 4, 10, -1, ' ') --> putch('4', 12)
void vprintfmt(putch(), 13, "x %d, y %x, z %d", {}) --> while ((ch = *(unsigned char *) fmt++) != '%') --> ch == '\n'
static void putch('\n', 13)
void cputchar('\n')
void cons_putc('\n')
static void cga_putc('\n') -- > case '\\n': crt_pos += CRT_COLS;
Finally, "x %d, y %x, z %d\\n", x, y, z is printed as x 1, y 3, z 4, cprintf return 14 because there are 14 byte printed to the console(including '\n').
{% endhighlight %}

4. Run the following code.
    unsigned int i = 0x00646c72;
    cprintf("H%x Wo%s", 57616, &i);

What is the output? Explain how this output is arrived at in the step-by-step manner of the previous exercise. Here's an [ASCII table](https://commons.wikimedia.org/wiki/File:ASCII-Table-wide.svg) that maps bytes to characters.
The output depends on that fact that the x86 is little-endian. If the x86 were instead big-endian what would you set i to in order to yield the same output? Would you need to change 57616 to a different value?

Here's a [description of little- and big-endian](http://www.webopedia.com/TERM/b/big_endian.html) and [a more whimsical description](http://www.networksorcery.com/enp/ien/ien137.txt).

First, we can add these code above to kern/monitor.c

{% highlight c linenos %}
void
monitor(struct Trapframe *tf)
{
   char *buf;

   cprintf("Welcome to the JOS kernel monitor!\n");
   cprintf("Type 'help' for a list of commands.\n");

   unsigned int i = 0x00646c72;
   cprintf("H%x Wo%s", 57616, &i);
   cprintf("\n");  

   while (1) {
      buf = readline("K> ");
      if (buf != NULL)
          if (runcmd(buf, tf) < 0)
              break;
   }
}

{% endhighlight %}

and we can see the result of execution:

{: .img_middle_lg}
![cprintf](/assets/images/posts/-02_Operating System/6828/2015-02-04-OS MIT 6828 Part I：Operating system interfaces/cprintf.png)

`He110 World` is easy to expalin: `57616` decimal is `e110` hex and for little-endian machine `0x00646c72` is `r`,`l`,`d`,'\0' in ASCII. 

5. In the following code, what is going to be printed after 'y='? (note: the answer is not a specific value.) Why does this happen? `cprintf("x=%d y=%d", 3);`

It will output a "random" value next to the address of value 3, which is `ap + 4`, `ap` is the address of value 2.

6. Let's say that GCC changed its calling convention so that it pushed arguments on the stack in declaration order, so that the last argument is pushed last. How would you have to change cprintf or its interface so that it would still be possible to pass it a variable number of arguments?

we need to make `ap` move upside down, so change `cprintf("%d%x%d",a,b,c)` to `cprintf('c,b,a,"%d%x%d"')`

### Part 4: The Stack

最后这部分，要研究C语言是如何在x86框架上使用堆栈的。需要查看指令寄存器(IP)的值的变化。

#### 2.4.1 Exercise 9: Understand Kernel Stack

> Exercise 9. Determine where the kernel initializes its stack, and exactly where in memory its stack is located. How does the kernel reserve space for its stack? And at which "end" of this reserved area is the stack pointer initialized to point to?

在`kern/entry.S`中，初始化`esp`
{% highlight c linenos %}
# Clear the frame pointer register (EBP)
# so that once we get into debugging C code,
# stack backtraces will be terminated properly.
movl    $0x0,%ebp            # nuke frame pointer

# Set the stack pointer
movl    $(bootstacktop),%esp
...
bootstack:
  .space  KSTKSIZE
  .global bootstacktop
bootstacktop:

{% endhighlight %}

`b *0x10000C`, `c`. si 一步一步下面地址：

{% highlight c linenos %}
0x10002d: jmp *%eax // eip 变为0xF010002F
0xF010002F <relocated>:   move   $0x0, %ebp
0xf0100034 <relocated+5>:	mov    $0xf0110000,%esp // esp变为0xf0110000
{% endhighlight %}

`KSTKSIZE`定义在`inc/memlayout.h`
{% highlight c linenos %}
// Kernel stack.
#define KSTACKTOP    KERNBASE
#define KSTKSIZE    (8*PGSIZE)           // size of a kernel stack
#define KSTKGAP        (8*PGSIZE)           // size of a kernel stack guard
{% endhighlight %}
`PGSIZE`定义在`inc/mmu.h`，大小为4096，所以KSTKSIZE为32KB.

#### 2.4.2 Exercise 10: Undertand Backtrace

> To become familiar with the C calling conventions on the x86, find the address of the test_backtrace function in obj/kern/kernel.asm, set a breakpoint there, and examine what happens each time it gets called after the kernel starts. How many 32-bit words does each recursive nesting level of test_backtrace push on the stack, and what are those words? Note that, for this exercise to work properly, you should be using the patched version of QEMU available on the [tools page](https://pdos.csail.mit.edu/6.828/2017/tools.html) or on Athena. Otherwise, you'll have to manually translate all breakpoint and memory addresses to linear addresses.


test_backtrace是个递归调用，关键要了解**栈段其实是栈帧的链表,栈帧可以看做1个结构体，ebp是当前栈帧结构体的指针，通过栈帧结构体的第一个地址可以获得父栈帧结构体的引用。
{% highlight c linenos %}

{% endhighlight %}



#### 2.4.3 Exercise 11: Implement Backtrace

> Exercise 11. Implement the backtrace function as specified above. Use the same format as in the example, since otherwise the grading script will be confused. When you think you have it working right, run make grade to see if its output conforms to what our grading script expects, and fix it if it doesn't. After you have handed in your Lab 1 code, you are welcome to change the output format of the backtrace function any way you like. If you use read_ebp(), note that GCC may generate "optimized" code that calls read_ebp() before mon_backtrace()'s function prologue, which results in an incomplete stack trace (the stack frame of the most recent function call is missing). While we have tried to disable optimizations that cause this reordering, you may want to examine the assembly of mon_backtrace() and make sure the call to read_ebp() is happening after the function prologue.
在`kern/monitor.c`里
{% highlight c linenos %}
int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
    // Your code here.
    int j;
    uint32_t ebp = read_ebp();
    uint32_t eip = *((uint32_t *)ebp+1);
    cprintf("Stack backtrace:\n");
    while ((int)ebp != 0)
    {
        cprintf("  ebp:0x%08x eip:0x%08x args:", ebp, eip);
        uint32_t *args = (uint32_t *)ebp + 2;
        for (j = 0; j < 5; j ++) {
            cprintf("%08x ", args[j]);
        }
        cprintf("\n");
        eip = ((uint32_t *)ebp)[1];
        ebp = ((uint32_t *)ebp)[0];
    }
    return 0;
}
{% endhighlight %}

#### 2.4.3 Exercise 12: Add More Info to Backtrace


{% highlight c linenos %}
Exercise 12. Modify your stack backtrace function to display, for each eip, the function name, source file name, and line number corresponding to that eip.

In debuginfo_eip, where do __STAB_* come from? This question has a long answer; to help you to discover the answer, here are some things you might want to do:

look in the file kern/kernel.ld for __STAB_*
run objdump -h obj/kern/kernel
run objdump -G obj/kern/kernel
run gcc -pipe -nostdinc -O2 -fno-builtin -I. -MD -Wall -Wno-format -DJOS_KERNEL -gstabs -c -S kern/init.c, and look at init.s.
see if the bootloader loads the symbol table in memory as part of loading the kernel binary
Complete the implementation of debuginfo_eip by inserting the call to stab_binsearch to find the line number for an address.

Add a backtrace command to the kernel monitor, and extend your implementation of mon_backtrace to call debuginfo_eip and print a line for each stack frame of the form:

K> backtrace
Stack backtrace:
  ebp f010ff78  eip f01008ae  args 00000001 f010ff8c 00000000 f0110580 00000000
         kern/monitor.c:143: monitor+106
  ebp f010ffd8  eip f0100193  args 00000000 00001aac 00000660 00000000 00000000
         kern/init.c:49: i386_init+59
  ebp f010fff8  eip f010003d  args 00000000 00000000 0000ffff 10cf9a00 0000ffff
         kern/entry.S:70: <unknown>+0
K> 
Each line gives the file name and line within that file of the stack frame's eip, followed by the name of the function and the offset of the eip from the first instruction of the function (e.g., monitor+106 means the return eip is 106 bytes past the beginning of monitor).

Be sure to print the file and function names on a separate line, to avoid confusing the grading script.

Tip: printf format strings provide an easy, albeit obscure, way to print non-null-terminated strings like those in STABS tables.	printf("%.*s", length, string) prints at most length characters of string. Take a look at the printf man page to find out why this works.

You may find that some functions are missing from the backtrace. For example, you will probably see a call to monitor() but not to runcmd(). This is because the compiler in-lines some function calls. Other optimizations may cause you to see unexpected line numbers. If you get rid of the -O2 from GNUMakefile, the backtraces may make more sense (but your kernel will run more slowly).
{% endhighlight %}

在`kern/kdebug.c`里
{% highlight c linenos %}
// Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    //
    // Hint:
    //    There's a particular stabs type used for line numbers.
    //    Look at the STABS documentation and <inc/stab.h> to find
    //    which one.
    // Your code here.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if(lline <= rline){
        info->eip_line = stabs[rline].n_desc;
    }
    else
        info->eip_line = -1;
{% endhighlight %}

修改`kern/monitor.c`
{% highlight c linenos %}
int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
        // Your code here.
        int j;
        uint32_t ebp = read_ebp();
        uint32_t eip = *(uint32_t *)ebp+1;
        cprintf("Stack backtrace:\n");
        while((int)ebp != 0)
        {
                cprintf("  ebp 0x%08x  eip 0x%08x  args ", ebp, eip);
                uint32_t *args = (uint32_t *)ebp+2;
                for(j=0;j<5;j++){
                        cprintf("%08x ",args[j]);
                }
                struct Eipdebuginfo info; 
                //= malloc(sizeof(struct Eipdebuginfo));
                debuginfo_eip(eip, &info);
                cprintf("\n    ");
                cprintf("%s:%d: %s",info.eip_file,info.eip_line,info.eip_fn_name);
                cprintf("\n");
                eip = ((uint32_t *)ebp)[1];
                ebp = ((uint32_t *)ebp)[0];
        }
        return 0;
}
{% endhighlight %}



## 3 Homework: Shell ##

### 3.1 Boot xv6

题目要求见[Boot xv6](https://pdos.csail.mit.edu/6.828/2017/homework/xv6-boot.html):

1. xv6第一条指令的执行地址？`nm kernel | grep _start`可得第一条指令的执行地址是0x0010000c。
2. 哪一条汇编指令后eip变成上述地址？`7dae: call *0x10018`。
3. 在xv6第一条指令处打断点，执行到此处，查看`x/24x %esp`，解释stack的有效范围，以及有效范围内的非零值。

{% highlight c linenos %}
(gdb) b *0x7dae
7dae: call *0x10018 // execute this line would change eip to 0x10000C (value stored in address 0x10018)
(gdb) c
(gdb) x/24x $esp
0x7bdc:	0x00007db4	0x00000000	0x00000000	0x00000000
0x7bec:	0x00000000	0x00000000	0x00000000	0x00000000
0x7bfc:	0x00007c4d	0x8ec031fa	0x8ec08ed8	0xa864e4d0
0x7c0c:	0xb0fa7502	0xe464e6d1	0x7502a864	0xe6dfb0fa
0x7c1c:	0x16010f60	0x200f7c78	0xc88366c0	0xc0220f01
0x7c2c:	0x087c31ea	0x10b86600	0x8ed88e00	0x66d08ec0

// the valid stack ranges from 0x7c00 to 0x7bdc after you exectue "7dae: call *0x10018", 0x00007db4 is eip value when entry() return in bootmain.c, 0x00007c4d is the eip value when bootmain.c return in bootasm.s
{% endhighlight %}




### 3.2 Shell 


{% highlight c linenos %}
{% endhighlight %}


题目要求见[Shell](https://pdos.csail.mit.edu/6.828/2014/homework/xv6-shell.html)



## 4 参考资料 ##

- [《xv6 book - chapter 0: Operating System Interfaces》](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-828-operating-system-engineering-fall-2012/lecture-notes-and-readings/);





