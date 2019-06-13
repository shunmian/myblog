---
layout: post
title: 鸟哥的Linux私房菜(基础篇)
categories: [-02 Operating System]
tags: [Operating System, Devops, Linux]
number: [-2.1]
fullview: false
shortinfo: 本书是对《鸟哥的Linux私房菜(基础篇)》的笔记。
---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}





## Part 1: Linux的规则与安装

### CH0: 计算机概论

### CH1: Linux是什么与如何学习

### CH2: 主机规划与磁盘分区

- 硬盘命名: `/dev/sd[a-p]`,若是虚拟机，则`/dev/vd[a-p]`, vd is short for virtual disk.

- 主要分区，扩展分区，逻辑分区定义：
    - 为什么分区: 高安全性(各个分区生命周期独立，删除1个不会影响其他)和高性能(同一个分区内在硬盘某一区域，读写快)
    - 主要分区加扩展分区最多4个
    - 扩展分区最多1个
    - 逻辑分区是由扩展分区持续划分出来的分区
    - 能够被格式化后作为数据存取的分区是主要分区与逻辑分区，扩展分区无法格式化
    - 逻辑分区的数量依据操作系统而不同，在linux系统中SATA硬盘已经可以突破63个以上的分区限制。
    - an Example, 5分区，采用 P + P + P + E
        - /dev/sda1
        - /dev/sda2
        - /dev/sda3 // sda1-4只供给P
        - /dev/sda5
        - /dev/sda6

- MBR (Master Boot Recrod) vs GPT (GUID partion table)
    - MBR最多只支持2.2TB磁盘。
    - GPT支持大于2.2TB磁盘，没有主分区和扩展分区区别，你可以视为所有分区都是主分区

- 开机流程: 
    - BIOS: 认出第一个启动设备
    - MBR: 获取启动引导代码地址
    - Boot Loader(引导启动程序): 
        - 读取内核文件
        - 转交控制权给其他1引导程序
        - 安装地点： MBR与引导扇区
    - 内核文件: 启动操作系统
    - 操作系统
- 分区建议: 新手只需`/`和`/swap`


### CH3: 安装Centos 7.x

### CH4: 首次登陆与在线求助

- update man: `yum install man-pages man-db man`
- terminal google-like cmd:
    - `makewhatis`, create index
    - search keyword: 
        - `man -k sort`; `man -k sort | grep 3`, sort content belong to section 3.
        - `apropos` = `man -k`, `man -k sort` = `apropos sort`
- [tldr](https://github.com/tldr-pages/tldr)

- `man man` will show you the 9 section of man page 

## Part 2: Linux文件，目录与磁盘格式

`Block Device` --(Partition & Format)--> `Filesystem` --(Mount)--> `Directory tree(Direcotry & File)`---->`Ready for usage`

### CH7: Block Device & Filesystem

- 磁盘格式化: 为了形成操作系统要识别的文件格式，例如ext2
    - 格式化现在最小粒度不是分区。LVM的存在可以让同一个分区分成不同的文件格式。我们通常称可被挂载的数据为一个文件系统。

- block device
    - 查
        - `lsblk`: list block device info
        - `blkid`
        - `parted`: `parted /dev/sda1 print`


- 文件系统要素
    - superblock
        - inodes and blocks usage statistics
            - total size
            - used
            - unused
        - cmd
            - 查
                -  `df -h`: disk usage for filesystem; `df -h /etc`; df读取的是superblock的信息，所以读取速度非常快
                - `du -h`: disk usage for file/directory
    - inode: file meta data
        - permission
        - onwer, group
        - size
        - time
            - ctime
            - mtime
            - atime
        - reference to blocks
        - note
            - inode本身不记录文件名，文件名的纪录是在目录的区块当中
        - cmd
            - 查
                - `ls -i afile`
    - block
        - data

- 挂载点
    - 挂载点一定是文件目录。该目录为进入该文件系统的入口。



{: .img_middle_lg}
![mount]({{site.url}}/assets/images/posts/-02_Operating System/2015-07-01-Basics：鸟哥的Linux私房菜(基础篇)/mount.png)


由于同一个文件系统的inode必对应不同的目录，因此下图显示`/`,`/boot`,`home`为三个文件系统

{: .img_middle_lg}
![mount]({{site.url}}/assets/images/posts/-02_Operating System/2015-07-01-Basics：鸟哥的Linux私房菜(基础篇)/inode-for-different-file-system.png)

 
### CH6: Directory & File

- Directory
    - 增:
        - `mkdir`: `mkdir testDir`
    - 删:
        - `rmdir`: `rmdir emptyDir`
        - `rm`: `rm -r nonEmptyDir`

    - 改:
        - `cp`: `cp -r fromDir toDir`
        - `ln`
            - Hard Link: `ln sourceFile destinationFile`, 在目录的inode里增加一条文件名到inode的记录，通常不会增加目录大小，也不会消耗额外的inode
            - Symbolic Link: `ln -s sourceFile destinationFile`, 创建一个新的inode，在目录的inode里增加一条文件名到该新的inode
    - 查: 
        - `ls -d aDir`
        - `which`: `which ls`.
        - `whereis`: `whereis ls`.
        - `locate`: `locate ls`
        - `find`

- File
    - 增:
        - `touch`: `touch aFile`
    - 删:
        - `rm`: `rm aFile`
    - 改:
        - `cp`: `cp fromFile toFile`
    - 查: 
        - `ls aFile`
        - `cat`: `cat a.txt`
        - `tac`: `tac a.txt`
        - `head`: `head -n 3 a.txt`
        - `tail`: `tail -n 3 a.txt`
        - `less`: `less a.txt`
        - `more`: `more a.txt`
        - `od`: `od a.txt`

- Path
    - 改:
        - `cd`: `cd aPath`; `cd -`, change to previous path
    - 查: 
        - `pwd`: `pwd`
        - `basename`: `basename /etc/sysconfig/network` => `network`
        - `dirname`: `dirname /etc/sysconfig/network` => `/etc/sysconfig`

### CH5: Permission 

{: .img_middle_hg}
![mount]({{site.url}}/assets/images/posts/-02_Operating System/Linux_Command_Line/2015-03-01-Linux Command Line/Files_Directory_杂项.png)


- Permission
    - 改:
        - `chown`: `chown root a.txt`
        - `chgrp`: `chown grp a.txt`; `chown root:root test.txt`, 同时该拥有者和属组
        - `chmod`: `chmod 666 a.txt`
    - 查: 
        - `ll a.txt`
        - `umask`: file default `rw-rw-rw`, directory default `rwxrwxrwx`, `umask` is the minus part. For example, if `umask` return `022`, `touch test1; ll test1` return `rw-r--r--`. `mkdir test2; ll test2` return `rwxr-x-r-x`.

- User
    - 增
        - `useradd`: `useradd aNewUser`, add aNewUser
        - `passwd`: `passwd aNewUser`, change password for aNewUser
    - 改
        - `su`: `su -` change to root; `su lal`, change to lal

### CH8: Compress

- `*.Z`:          compress
- `*.zip`:        zip
- `*.gz`:         gzip
    - `gzip -v aFile`, compress a file and replace original file
    - `gzip -d aFile.gz`, decompress a file
    - `gzip -9 -c services > services.gz`, 用最佳压缩比，将services压缩成services.gz且保留services原文件。
    - `zcat`: print the uncompressed content of compressed file (for example, *.gz), `zcat a.gz`
    - `zgrep`: `zgrep -n 'http' services.gz`, grep the http in *.gz file and print the keyword line number.

- `*.bz2`:        bzip2
    - `bzip2 -v aFile`
    - `bzip2 -d aFile.bz2`, decompress *.bz2
    - `bzcat`: cat .bz2, `bzcat2 a.bz2`
- `*.xz`:         xz
    - `xz -v aFile`
    - `xz -d services.xz`
    - `xzcat`: `xzcat services.xz`

- `*.tar`:        tar, 将多个文件打包成为一个文件，本身没有压缩功能。without compress。下面是将tar打包和不同压缩算法结合
- `*.tar.gz`:     tar, compressed with gzip
- `*.tar.bz2`:    tar, compressed with bzip2
- `*.tar.xz`:     tar, compressed with xz 



## Part 3: Shell与Shell Script

### CH9: vim程序编辑器

- normal node:
    - `ctrl`+`f`: next page; `ctrl`+`b`: prev page;
    - `ZZ`: save and quit. 

- insert mode:
    - `i`, `I`
    - `a`, `A`
    - `o`, `O`
    - `r`, `R`

- visual mode:
    - `ctrl`+`v`，矩形选择。

- multi-files
    - `vim f1 f2`, `:files` show all file, `:n` switch files

- multi-window
    - `:sp` split window with the same file; `:sp file2` split window witht file2
    - `ctrl`+`w`, `j`, control window below; `ctrl`+`w`, `k`, control window above;
    -  `ctrl`+`w`, `q`, control window quit.

### CH10: 认识与学习BASH

### CH11: 正则表达式与文件格式化处理

### CH12: 学习Shell脚本


## Part 4: Linux使用者管理

### CH13: Linux账号管理与ACL权限设置

### CH14: 磁盘配额与高级文件系统管理

### CH15: 计划任务

### CH16: 进程管理与SELinux初探


## Part 5: Linux系统管理员

### CH17: 认识系统服务(daemon)

### CH18: 认识与分析日志文件

### CH19: 启动流程，模块管理与Loader

### CH20: 基础系统设置与备份策略

### CH21: 软件安装: 源代码与Tarball

### CH22: 软件安装RPM, SRPM与YUM

### CH23: X Windows 设置介绍

### CH24: Linux内核编译与管理

### CH1: 搭建服务器前的准备工作


## 2 参考资料 ##

- [The Architecture of Open Source Applications: Nginx](http://www.aosabook.org/en/nginx.html);


