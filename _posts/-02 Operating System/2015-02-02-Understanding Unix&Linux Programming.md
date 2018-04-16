---
layout: post
title: Understanding Unix&Linux Programming
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

### Ch2 Users and Files

1. **Unbuffered I/O**. Using `open`,`creat`,`read`, `write`,`close`,`lseek` on `int fd`(file descriptor) to implement own verison of `who`(`read` file), `cp`(`open`, `creat`, `read`, `write`). A new version of `cp`, which keeps a internal buffer when `read` from kernel buffer, is simliar to `fread` in `stdio.h`.

2. Each time program call `read` and `write`, it operates on kernel `buffer`, which talks to `disk`. Adding another buffer layer in program increase its performance.

3. **System-call Errors**. `errno` is a global int that store the error, one can use `perror(string)` to print the error's message.



## 2 Summary ##

{: .img_middle_hg}
![Understanding UnixLinux Programming Summary](/assets/images/posts/-02_Operating System/2015-02-02-Understanding Unix&Linux Programming/Understanding UnixLinux Programming Summary.png)


## 3 参考资料 ##

- [《Understanding UNIX/LINUX Programming: A Guide to Theory and Practice》](https://www.amazon.com/Understanding-UNIX-LINUX-Programming-Practice/dp/0130083968);





