---
layout: post
title: OSTEP 1：Process
categories: [-02 Operating System]
tags: [Operating System, Unix]
number: [-02.1]
fullview: false
shortinfo: OSTEP Process。

---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1 Process Summary ##



{: .img_middle_hg}
![Process_Summary]({{site.url}}/assets/images/posts/-02_Operating System/OSTEP/2015-01-01-OSTEP 1_Process/Process_Summary.png)

## 2.1 SIGNAL

`SIGHUB`: When a terminal disconnect (hangup) occurs, this signal is sent to the controlling process of the terminal. We describe the concept of a controlling process and the various circumstances in which SIGHUP is sent in Section 34.6. A second use of SIGHUP is with daemons (e.g., init, httpd, and inetd). Many daemons are designed to respond to the receipt of SIGHUP by reinitializing themselves and rereading their configuration files. The system administrator triggers these actions by manually sending SIGHUP to the daemon, either by using an explicit kill command or by executing a program or script that does the same. [Nginx]({site.url}}/14%20backend/2015/11/01/Backend-Nginx.html) is listening SIGHUB to reload the config file!.
/Users/shunmian/Desktop/myblog/_posts/-14 Backend/2015-11-01-Backend：Nginx.md

`SIGCHLD`: This signal is sent (by the kernel) to a parent process when one of its children terminates (either by calling exit() or as a result of being killed by a signal).

`SIGTERM`: This is the standard signal used for terminating a process and is the default signal sent by the kill and killall commands. It is the same as cmd `kill -9`.


## 3 参考资料 ##

- [《Operating Systems: Three Easy Pieces》](http://pages.cs.wisc.edu/~remzi/OSTEP/)





