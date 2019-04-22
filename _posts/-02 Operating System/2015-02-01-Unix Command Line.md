---
layout: post
title: A1：Unix Command Line
categories: [-02 Operating System]
tags: [Operating System, Unix, Command Line]
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

{: .img_middle_hg}
![Network Data & Error Summary]({{site.url}}/assets/images/posts/2015-02-01-Unix Commad Line/mac terminal command summary.png)


## 2 补充 

1. 添加unix环境变量：`export XV6=/home/shumian/Desktop/6828/xv6-public`。`env`查看是否添加。`cd $XV6`来使用。

2. multiple unix command in one line, **Control Operator**: `cmd1 && cmd2`(cmd2 will only be executed after cmd1 success)  `cmd1 ; cmd2`(cmd2 will be executed no matter cmd1 success or fail).

3. `strace`(linux) or `dtruss`(Mac): a tool to trace the system calls made by a program. `echo hello > foo`, `cat foo`, `strace cat foo`. 

4. Command line换行: ```./configure --prefix=/usr/local/softname --enable-xxx -enable-yyy --enable-zzz --enable-aaa -enable-bbb --enable-ccc --enable-mmm -enable-nnn --enable-ppp --enable-qqq```太长可换成多行
```
./configure --prefix=/usr/local/softname \
--enable-xxx -enable-yyy --enable-zzz --enable-aaa \
-enable-bbb --enable-ccc --enable-mmm -enable-nnn \
--enable-ppp --enable-qqq
```

5. Find the last cmd return value: `echo $?`.

6. Run the command in background: `ls &`. If a command is terminated by the control operator &, the shell executes the command in the background in a subshell. The shell does not wait for the command to finish, and the return status is 0.

{% highlight c linenos %}
#include <stdio.h>

int main()
prompt > strace cat foo
open("foo\0", 0x0, 0xFFFFFFFFE83E1B05)		 = 3 0
fstat64(0x1, 0x7FFEE83E18C0, 0x0)		 = 0 0
read(0x3, "hello\n\0", 0x20000)		 = 6 0
write(0x1, "hello\n\0", 0x6)		 = 6 0
read(0x3, "\0", 0x20000)		 = 0 0
close(0x3)		 = 0 0
close_nocancel(0x1)		 = 0 0
...
promt>
{% endhighlight %} 



## 3 参考资料 ##

- [《The Mac OS X Command Line: Unix Under the Hood》](https://www.amazon.com/Mac-OS-Command-Line-Under/dp/0782143547/ref=sr_1_1?ie=UTF8&qid=1476266069&sr=8-1&keywords=The+Mac%C2%AE+OS+X+Command+Line+Unix+Under+the+Hood);





 