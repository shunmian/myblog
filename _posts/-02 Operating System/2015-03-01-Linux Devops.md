---
layout: post
title: Linux Devops
categories: [-02 Operating System]
tags: [Operating System, Devops, Linux]
number: [-02.1]
fullview: false
shortinfo: 本文Linux Devops的笔记。

---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1 介紹 ##

### 1.1 RHCE + RHCA

1. RH401
2. RH423 (LDAP)
3. RH442
4. RH436: 集群和存储
5. RH8333

### 1.2 GUI (Graphic User Interface)

Gnome: C
KDE: C++
XFace

### 1.3 CLI (Command Line Interface)



#### 1.3.1 基础

##### 1.3.1.1 CLI命令格式

命令行遵循`命令 选项 参数`顺序，

1. 选项：有长选项(不能组合)`node --version`，短选项(可组合)`ls -a`， `ls -l`, `ls -la`；有些选项可以带参数(**选项参数**，和**命令参数**不一样)
2. 参数：命令的作用对象。

##### 1.3.1.2 环境变量

##### 1.3.1.3 Shebang

**shebang** short for hashbang `#!`, normally refer to `#!/bin/bash`.


##### 1.3.1.4 Versions

sh
bash
csh
zsh
ksh
tcsh

#### 1.3.2 常用命令

##### 1.3.2.0 `man`, `help`, `CMD --help`, `info`

1. 内部命令 `help CMD`;
2. 外部命令 `CMD --help`;
3. 公共使用 `man CMD`.

man分8章节:
1. 用户命令(/bin, /usr/bin, /usr/local/bin)
2. 系统调用
3. 库调用
4. 特殊文件(设备文件(作为设备的访问入口))
5. 文件格式(配置文件的语法)
6. 游戏
7. 杂项(Miscellaneous)
8. 管理命令（/sbin, /usr/sbin, /usr/local/sbin）

`man 2 read`和`man read`都显示第二章节的`read`. `man read`会显示第一个找到章节的命令。


查看CMD在哪个章节
`whatis ls`：ls(1) - list directory content.告诉我们在第一章节。

man的内容格式，以man date为例

{% highlight c linenos %}
date [options] ... [-u|--uts|--universal]
/*
[]  可省略,
|   多选一,
<>  必选,
... 可出现多个,
{}  分组

MAN:
  NAME: 命令名称及功能简要说明
  SYNOPSIS: 用法说明，包括可用的选项
  DESCRIPTION: 命令功能的详尽说明，包括每一个选项的意义
  OPTION: 说明每一个选项的意义
  FILES: 此命令相关的配置文件
  BUGS:
  Examples: 
  SEE ALSO: 另外参照
翻屏:
  向后, SPACE
  向前, b
  向下, ENTER
  向上, k
查找:
  自前向后，/KEYWORD
  自后向前，?KEYWORD
  下一个, n
  前一个, N
退出:
  q
*/
{% endhighlight %}

`info`是在线文档，是`man`的一个补充。
`/usr/share/doc`是`man`的一个补充。
google



##### 1.3.2.1 `su` (switch user)

##### 1.3.2.2 `passwd`

密码复杂性
1. 使用4种类别字符中至少3种
2. 足够长，大于7位
3. 使用随机字符串
4. 定期更换
5. 循环周期足够大。

##### 1.3.2.3 `ls`
机器处理数字比字符要快，这就是为什么每个文件有数字identifier，而不是字符identifier.

文件类型 -l
-: 普通文件(file)
d: 目录文件
b: 块设备文件(block)
c: 字节设备文件(character)
l: 符号链接文件(symbolic link file，类似与windows上的快捷方式)
p: 命令管道文件(pipe)
s: 套接字文件(socket)

文件权限,9位，每三位一组，每一组rwx(读写执行)。
文件硬链接次数
文件的属主(owner)
文件的属组(group)
文件大小(size),单位是字节
时间戳(timestamp),最近一次被修改的时间
  访问: access
  修改: modify, content， 内容
  改变: change, metadata, 元数据（文件名

-h human readable size
-a all, 包括隐藏文件； -A 和-a一样，但不包括`.`,`..`
-d 显示directory本身。
-i 显示inode.
-r 逆序显示
-R 递归显示

##### 1.3.2.4 `cd`

`cd`=`cd ~` home directory
`cd ~USERNAME`, go to other user's home directory(only root can do).
`cd -`在前后directory相互切换

##### 1.3.2.5 `type`, `which`

命令类型:

1. 内置命令(shell内置), `type ls`, ls is /bin/ls;
2. 外部命令, `type cd`, cd is a shell builtin.

##### 1.3.2.6 `hash`

打印cmd的cache路径

##### 1.3.2.7 `env`

打印env

`PATH`是`:`隔开的路径集合。

##### 1.3.2.8 `date`， `hwclock`，`cal`

显示和修改时间:

1. 系统时间: `date`， `date +%s`(epoch time, the value is independent of user's location)

2. 硬件时间: `hwclock`, `hwclock -w`(将系统时间写到硬件时间)， `hwclock -s`(将硬件时间写到系统时间)

3. 日历: `cal`

##### 1.3.2.9 `echo`, `printf`

##### 1.3.2.10 `file`

文件系统:
/: 根文件系统
/boot: 系统启动相关的文件，如内核，initrd,以及grub(bootloader)
/dev: 设备文件
  块设备，随机访问，数据块
  字符设备，线性访问，按字符为单位
  设备号: 主设备号(major)和次设备号(minor)
/etc: 配置文件
/home: 用户的家目录，每一个用户的家目录通常为/home/USERNAME
/root: root用户的家目录
/lib,库文件
  静态库 .a
  动态库 .so (shared object), .dll
  /modules, 内核模块文件
/media: 挂载(将某个设备与文件目录某个点关联的过程)点目录，用于移动设备
/mnt: 挂载点目录，额外的临时文件系统
/opt: 可选目录
/proc: 伪文件系统，内核映射文件
/sys: 伪文件系统，与应急设备相关的属性映射
/var: 可变化的文件
/tmp: 临时文件, /var/tmp
/bin: 可执行文件，用户命令， 运行依赖于lib
/sbin: 管理命令, 运行依赖于lib
/usr: universal, shared, read-only
  /bin
  /sbin
  /lib
  /local, 第三方软件的安装目录
    /bin
    /sbin
    /lib

文件命名规则:
1. 长度不能超过255个字符
2. 不能使用`/`
3. 严格区分大小写

文件管理
touch 修改access,modify的时间戳，若不存在，则额外修改change时间戳
  -a
  -m
  -t
  -ca

cp SRC DEST; 一个文件到一个文件或多个文件到一个目录
  -r
  -L
  -f
  -p
  -a: 归档复制，常用备份。

stat
rm
file
mv
nano



目录管理
ls: `type ls`(ls is alliased to `ls --color=auto`); if you want to use the original `ls`, use `\ls`.
cd
pwd
`mkdir`:
  `mkdir -p x/y/z`会创建`x/y/z`, 如果不加`-p`则会失败，因为`x/y`不存在;
  展开, `mkdir -p x/{a,b}/z`会生成x/a/z和x/b/z, `mkdir -p x/{a,b}/z`会生成a_c,a_d,b_c,b_d四个文件;
mv
rmdir
tree

进程管理
设备管理
网络管理
软件管理
运行程序
日期管理
  date, clock, hwclock, cal
文本管理
  cat:
    -n
    -e
    tac:从最后一行打印到第一行
  分屏显示：
    more,
    less,
  查看开头
    head, 默认10行, `head -2 FILE`,前两行
  查看结尾
    tail, 默认10行, `tail -2 FILE`,后两行; `tail -f FILE`, 查看文件尾部不退出，等待显示后续追加至此文件的新内容。
  cut: 指定字段分隔符，默认是空格
    `cut -d: -f1 /etc/passwd`，delimeter 是`:`,字段是`1`(可以`-f 1,3`, `-f 1-3`)
  join
  sort:
    -n, 数值排序
    -r, 逆序排序
    `-t : -k 3 /etc/passwd`表示`:`为分隔符，第三个字段来排序
  uniq,
  grep,
  sed,
  awk,
管道和重定向
用户，组，权限
bash

### 1.4 Web集群

### 1.5 MYSQL

### 1.5 NoSQL

### 1.6 Hadoop

### 1.7 HBase

### 1.8 Openstack

### 1.9 其他

LFS(Linux From Scratch)

`cat /etc/issue^C`可以取消，不用后退键delete



## 2 其他

### 2.1 职位

运维工程师
系统工程师

### 2.2 方法论

总分总
以给别人讲明白为标准，每回答别人一次，对自己都是收获。

### 2.3 理论基础

计算机体系

1. BIOS自举

### 2.4 开源和自由

GPL
BSD
Apache

### 2.5 Release

RedHat
SLS
Debian
SUSE

### 2.6 基本原则

#### 2.6.1 由目的单一的小程序组成，组合小程序完成复杂任务

#### 2.6.2 一切皆文件

#### 2.6.3 尽量避免捕获用户接口(统一为用Shell)

#### 2.6.4 配置文件保存为纯文本格式

#### 2.6.5 cmd 能简写绝不全写

### 2.7 Audition





{: .img_middle_lg}
![cprintf](/assets/images/posts/-02_Operating System/6828/2015-02-04-OS MIT 6828 Part I：Operating system interfaces/cprintf.png)

{% highlight c linenos %}

{% endhighlight %}

## 5 参考资料 ##

- [《xv6 book - chapter 0: Operating System Interfaces》](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-828-operating-system-engineering-fall-2012/lecture-notes-and-readings/);





