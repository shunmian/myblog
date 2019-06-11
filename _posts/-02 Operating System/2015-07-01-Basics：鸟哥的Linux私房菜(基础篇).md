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

- 挂载：将磁盘连接到目录树的动作，目录树对应挂载的目录称为挂载点。


{: .img_middle_hg}
![mount]({{site.url}}/assets/images/posts/-02_Operating System/2015-07-01-Basics：鸟哥的Linux私房菜(基础篇)/mount.png)


### CH3: 安装Centos 7.x

### CH4: 首次登陆与在线求助

- `man man` will show you the 9 section of man page 

## Part 2: Linux文件，目录与磁盘格式

### CH5: Linux的文件权限与目录配置

### CH6: Linux文件与目录管理

`umask`, file default `rw-rw-rw`, directory default `rwxrwxrwx`, `umask` is the minus part. For example, if `umask` return `022`, `touch test1; ll test1` return `rw-r--r--`. `mkdir test2; ll test2` return `rwxr-x-r-x`.


- Directory
    - 增:
        - `mkdir`: `mkdir testDir`
    - 删:
        - `rmdir`: `rmdir emptyDir`
        - `rm`: `rm -r nonEmptyDir`

    - 改:
        - `cp`: `cp -r fromDir toDir`
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
        - `cd`: `cd aPath`
    - 查: 
        - `pwd`: `pwd`

- Permission
    - 改:
        - `chown`: `chown root a.txt`
        - `chgrp`: `chown grp a.txt`
        - `chmod`: `chmod 666 a.txt`
    - 查: 
        - `ll a.txt`
        - `umask`
 

### CH7: Linux磁盘与文件系统管理

### CH8: 文件与文件系统的压缩


## Part 3: Shell与Shell Script

### CH9: vim程序编辑器

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


