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
    -u, 相同行只显示一次
    -f, 忽略字符大小写
  uniq,
    -d, 只显示重复的行
    -c, 重复几次
  wc, word count
    -l, 只显示行数
    -w, 只显示单词数
    -c, 只显示字符数
  tr, translate
    `tr 'ab' 'AB'` 将所有ab替换AB
    `tr 'ab' 'AB' < /etc/passwd` 将/etc/passwd中所有ab替换AB(不改变/etc/passwd本身)
    `tr 'a-z' 'A-Z' < /etc/passwd` 将/etc/passwd中所有小写替换成大写(不改变/etc/passwd本身)
     `tr -d 'a-z' < /etc/passwd` 将/etc/passwd中所有小写删除(不改变/etc/passwd本身)
  grep,
  sed(流编辑器), `sed "1,2d" file`将file1打印（删除前2行）
  awk,
管道和重定向



用户，组，权限



bash

### 1.4 Shell

Shell里可以运行shell,可以`bash`,`bash`,`pstree | grep bash`来查看

bash:
1. 命令历史

`history` 查看命令历史
  -c, 清空命令历史
  -d, 清空第几个命令: `history -d 500`清空第500个命令, `hisotry -d 500 10`, 清空第500个之后的10个命令
`!`
  `!n`, 执行命令历史中的第n条命令.
  `!!`, 执行上一条命令。
  `!string`, 执行命令历史中最近一次
  `!$`，替换为上个命令的最后一个参数；或`ESC`松开再`.`;或`ALT+.`
1.1 命令补全, 第一个tab尝试补全，若失败，第二个tab会列出所有候选命令。
1.2 路径补全
2. 管道，重定向
3. 命令别名
  `alias`
  `alias cls=clear`, 在shell中定义的别名，仅在shell的当前生命周期起作用。若要全局存储，在`.bash_profile`中修改
  `unalias cls`, 撤销别名
  `\CMD`执行命名本身，如果CMD别名为CMD OPTION
4. 命令替换
  `echo "current directory is ${PWD}"`
  `echo "current directory is `PWD`"`
5. bash支持的引号
  ``:命令替换
  "":弱引用，可以实现变量替换
  '':强引用，不实现变量替换
6. 文件名通配: globbing
  man 7 `glob`
  *: 任意长度的任意字符
  ?: 任意单个字符
  []:任意范围内的单个字符
    [:space:], 空白字符
    [:punct:], 标点字符
    [:lower:], 小写
    [:upper:], 大写
    [:alpha:], 字母
    [:digit:], 数字
    [:alnum:], 数字和小写字母
  [^]:匹配指定范围外的任意单个字符

4. 命令行编辑
  ^a,跳到行首
  ^e,跳到行尾
  ^u,删除光标到命令行首
  ^k,删除光标到命令行尾
  ^<-,回跳一个单词
  ^l,清屏
5. 命令行展开
6. 文件名统配
7. 变量
8. 编程
9，环境变量
  PATH: 搜索路径
  HISTSIZE: 命令历史缓冲区大小。

### 1.5 用户，组，权限

文件权限:
r 可类似cat等命令读文件
w 可编辑或删除此文件
x 可执行，

目录权限:
r 可ls等命令读文件
w 可在此目录下创建文件
x 可使用cd切换进此目录，也可以使用ls -l 查看内部文件的详细信息。

000 0 ---
001 1 --x
010 2 -w-
011 3 -wx
100 4 r--
101 5 r-x
110 6 rw-
111 7 rwx

755表示`rwxr-xr-x`

用户: UID, /etc/passwd(用户的信息库，包括登录密码，默认shell)
组:   GID, /etc/group

影子口令
用户: /etc/shadow
组: /etc/gshadow

用户类别
  管理员: 0
  普通用户: 1-65535
    系统用户: 1-499
    一般用户: 500-60000
  用户`useradd tom`,增加tom用户, -u,-g可以改组。其他用户相关命令
    `userdel`
    `usermod`
    `passwd tom`，增加tom用户的密码
    `chsh`
    `chfn`
    `finger`
    `id`: 显示USERNAME所对应的用户id,组id等
    `chage`


用户组类别
  管理员组
  普通组
    系统组
    一般组
  用户组类别
    私有组: 创建用户时，如果没有为其指定所属的组，系统会自动为其创建一个与用户名同名的组。
    基本组: 用户的默认组
    附加组: 额外组，默认组意外的其他组
  组`cat /etc/group`
    `groupadd mygroup`，增加mygroup组
      `groupdel`
      `groupmod`
      `gppasswd`

当`ls /etc`时，系统会先检查该用户对`/bin/ls`的权限，若通过，ls会记录发起这个命令的用户，然后用用户的权限去匹配文件的权限。

进程 tom tom  //tom不是属主jerry, 但是属组tom, 所以以rw-运行 a.txt, 但是以r-x运行ls(见下面)
对象 rwxrw-r-- jerry tom a.txt

tom: ls //tom不是属主root,也不是属组root,所以以r-x运行ls
rwxr-xr-x root root /bin/ls

`man 5 passwd`, `cat /etc/passwd`
account:登录名
password:密码
UID
GID:基本组ID
comment: 注释
HOME DIR: 家目录
Default Shell

`man 5 shadow`, `cat /etc/shadow`
account:
encrypted password:

加密方法:
  对称加密，加密和解密使用同一个密码
  公钥加密(解密)，私钥解密(加密)。因此每一个密码都成对出现
  单向加密，散列加密，即明文->密文，非可逆，常用于数据完整性校验
    雪崩效应：输入的微小改变将会引起结果的巨大改变。
    定长输出
      MD5: Message Digest, 128位定长输出
      SHA1: Secure Hash Algorithm, 160位定长输出
    加盐是为了防止用户密码一样时，哈希值一样，使得知道一个用户的密码就能知道其他。为每个用户配备不同的盐可以防止。





权限
  `chown`
  `chgrp`
  `chmod`
    `+x`,增加x执行权限

### 1.6 管道和重定向

#### 1.6.1 重定向

>: 输出重定向覆盖
>>: 输出重定向追加

<: 输入重定向
<<: 此处文档 `cat << EOF`输入完后，输入内容，以`EOF`结束

2>: 错误重定向
2>>: 错误重定向追加

&>: 重定向所有输出(标准和错误)
<

`set -C` 不允许>到已存在文件(这种情况下要强制>到已存在文件，可用`ls |> a.out`)，`set +C` 允许>到已存在文件，

#### 1.6.2 管道(命令之间的输入输出链接)

`echo "hello, world" | tee a.out`, `tee`将输出到标准输出，同时拷贝到文件

### 1.7 text

#### 1.7.1 `grep`

`grep`
  -i
  --color
  -v 反向匹配
  -o
`egrep`, extension grep



`fgrep`, fast grep

### 1.8 Shell脚本编程

bash变量类型
1. 环境变量: export VARNAME=VALUE, 作用域为当前shell进程及其子进程
2. 本地变量(局部变量)： VARNAME=VALUE,作用域为整个bash进程； local VARNAME=VALUE,作用域为当前代码段
3. 位置变量:
  $1, $2

4. 特殊变量: $?,上一个命令执行状态返回值，
  程序状态返回代码(0-255)，幸福家庭大都相似，不幸的家庭各有各的不幸。
    0: 正确
    1-255: 各种错误。1，2，127，系统预留。
5. 引用变量: ${VANAME},大括号有时可省略。
6. 撤销(环境和本地，局部)变量: unset VARNAME
7. 查看当前shell变量: 
  7.1 所有变量 `set`
  7.2 环境变量 `printenv`, `env`, `export`
8. 变量追加`NAME=Jack`,`NAME=$NAME:Johnson`
9. shell对待所有输入都为文本，而不是数字，`a=1`,`b=2`, `c=$a+$b`, `echo $c`输出`1+2`.
10. 变量名称: 只能包含字母，数字和下划线，并且不能数字开头
11. 
  `$?`,上一个命令的状态码
  `$#`,参数个数
  `$*`,参数列表
  `$@`,参数列表
  `shift`，轮换参数
脚本是命令的堆砌。

shebang
`#!/bin/bash`
`#this is a comment`

{% highlight c linenos %}
# first.sh
#!/bin/bash
ls
{% endhighlight %}
运行`first.sh`, 会输出`-bash: first.sh: command not found`. `echo $PATH`发现first.sh所在的目录没有在`PATH`里；因此解决方案有2个，要么将当前目录加入到`$PATH`, 要么运行`./first.sh`，which指定了其运行的文件的位置。

条件测试
  整数测试
    `-eq`,等值比较`$A -eq $B`
    `-ne`,不等值比较`$A -nq $B`
    `-gt`
    `-lt`
    `-ge`
    `-le`
  字符测试
    `==`, `[ $A == $B ]`
    `!=`, `[ $A != $B ]`
    `>`
    `<`
    `-n STRING`: 空为真
    `-s STRING`: 不空为真
  文件测试
    -e FILE, 测试文件是否存在
    -f FILE, 测试文件是否为普通文件
    -d FILE, 测试指定路径是否为目录
    -r FILE, 测试当前用户文件是否有读权限
    -w
    -x
条件测试的表达式 
  `[ expr ]`命令测试法
  `[[ expr ]]`关键字测试法
  `test expr`

测试脚本是否有语法错误
`bash -n file`
如果脚本没有明确定义退出状态码，那么，最后执行的一条命令的退出码即为脚本的执行码。
bash -x 脚本， 单步执行？？？？

用户user6不存在则添加，否则输出“用户已存在”
`! id user6 && useradd user6 || echo "user existed"`
`id user && echo "user existed" || useradd user6`

条件判断，控制结构
{% highlight c linenos %}
if 条件判断1; then
  statement1
elif 条件判断1; then
  statement2
else
  statement3
fi
{% endhighlight %}

A=`ls a.out`
echo $A 是输出A的值，即`ls a.out`的值
echo $? 是输出`ls a.out`的返回状态，这里是0

算数运算
let C=$A+$B
C=$[$A+$B]
C=$(($A+$B))
C=`expr $A + $B`

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





