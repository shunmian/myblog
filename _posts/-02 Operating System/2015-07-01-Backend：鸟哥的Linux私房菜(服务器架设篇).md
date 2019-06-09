---
layout: post
title: 鸟哥的Linux私房菜(服务器架设篇)
categories: [-14 Backend]
tags: [Web Server]
number: [-2.1]
fullview: false
shortinfo: 本书是对《鸟哥的Linux私房菜(服务器架设篇)》的笔记。
---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## Part 1: 服务器搭建前的进修专区

### CH1: 搭建服务器前的准备工作

### CH2: 网络的基本概念

### CH3: 局域网架构简介

### CH4: 连接Internet

virtualbox安装centos, 虚拟机与宿主机网络通过`bridge`(桥接，虚拟机与宿主机处于平等地位，位于同一个局域网)链接。

{: .img_middle_hg}
![连接到网络]({{site.url}}/assets/images/posts/-02_Operating System/2015-07-01-Backend：鸟哥私房菜服务器/连接到网络.png)

### CH5: Linux中常用的网络命令

### CH6: Linux网络排错

## Part 2: 主机的简易安全防护措施

### CH7: 网络安全与主机的基本防护: 限制端口，网络升级与SELinux

> SELinux: 权限的主体是process,目标是file, 这样就防止即使黑客或得root，使用不同的程序所取得权限也不一定是root。例如www服务器软件的实现程序是httpd这个程序，而默认情况下httpd只能访问/var/www/这个目录下面访问的文件，如果httpd这个程序想要到其他目录去访问数据时，除了规则设置要开放外，目标目录也需要设置成httpd可读取的模式(Type)才行，限制非常多，所以即使不小心httpd被Cracker取得了控制权，Cracker也无权浏览/etcd/shadow等重要的配置文件。

### CH8: 路由的概念与路由器设置

> NAT：convert between public ip and private ip

### CH9: 防火墙与NAT服务器

TBC

### CH10: 申请合法的主机名

## Part 3: 局域网内常见服务的搭建

### CH11: 远程连接服务器: SSH/XDMCP/VNC/XRDP

TBC

### CH12: 网络参数管理者: DHCP服务器

### CH13: 文件服务器之一: NFS服务器

### CH14: 账号管理: NIS服务器

### CH15: 时间服务器: NTP服务器

### CH16: 文件服务器之二: SAMBA服务器

### CH17: 局域网控制者: Proxy服务器

### CH18: 网络驱动器设备: iSCSI服务器

## Part 4: 常见因特网服务器的搭建

### CH19: 主机名控制者: DNS服务器

### CH20: WWW服务器

TBC

### CH21: FTP服务器

### CH22: 邮件服务器: Postfix

## 2 参考资料 ##

- [The Architecture of Open Source Applications: Nginx](http://www.aosabook.org/en/nginx.html);


