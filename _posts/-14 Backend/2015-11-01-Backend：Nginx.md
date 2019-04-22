---
layout: post
title: Nginx
categories: [-14 Backend]
tags: [NodeJS, nginx]
number: [-2.1]
fullview: false
shortinfo: nginx
---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1 初识Nginx


### 1.0 config file

The run-loop is the most complicated part of the nginx worker code. It includes comprehensive inner calls and relies heavily on the idea of asynchronous task handling. Asynchronous operations are implemented through modularity, event notifications, extensive use of callback functions and fine-tuned timers. Overall, the key principle is to be as non-blocking as possible. The only situation where nginx can still block is when there's not enough disk storage performance for a worker process.

Because nginx spawns several workers to handle connections, it scales well across multiple cores. Generally, a separate worker per core allows full utilization of multicore architectures

{: .img_middle_hg}
![Nginx_architecture]({{site.url}}/assets/images/posts/-14_Backend/2015-11-01-Backend_Nginx/Nginx_architecture.png)


config file structure

main
  events
    server
      location
  http

### 1.1 Nginx搭建静态资源Web服务器

### 1.2 Nginx搭建具备缓存功能的反向代理服务

### 1.3 goaccess可视化log

### 1.4 SSL协议握手时，Nginx的性能瓶颈主要在哪

### 1.5 将http升级为https via certbot

### 1.6 使用openresty：通过lua扩展nginx


## 2 Nginx架构基础

### 2.1 Nginx请求处理流程

{: .img_middle_hg}
![Ngin_requst_handle_procedure]({{site.url}}/assets/images/posts/-14_Backend/2015-11-01-Backend_Nginx/Nginx_requst_handle_procedure.png)

### 2.2 Nginx进程模型

为什么nginx使用多进程模型而不是多线程模型？这个问题的本质是多线程和多进程的区别。数据沟通方面，虽然多线程共享数据比多进程的IPC更方便快捷；但是多线程如果一个线程有内存越界访问，整个进程都会挂掉，而多进程模型中，某个进程内存访问错误，并不会影响其他进程。

Nginx的work数通常和cpu数一致，并且会一个work绑定一个cpu，这样可以更好的利用CPU缓存，减少缓存失效的命中率。

{: .img_middle_hg}
![Nginx_process_model]({{site.url}}/assets/images/posts/-14_Backend/2015-11-01-Backend_Nginx/Nginx_process_model.png)


1. 一个父进程(10232)两个子进程(11880, 11902);
2. `nginx -s reload`,父进程会新重载conf，kill旧的两个子进程，新建2个子进程(11936, 11938); `nginx -s reload`等同于发送`SIGHUP`个父进程，可以看到同样新建2个子进程(11957, 11959);
3. 当其中一个子进程挂掉后,父进程会收到`SIGCHLD`信号，进而再新建1个子进程(11975)。

{: .img_middle_hg}
![Nginx_process_demon]({{site.url}}/assets/images/posts/-14_Backend/2015-11-01-Backend_Nginx/Nginx_process_demon.png)



### 2.3 阻塞 vs 非阻塞 + 同步 vs 异步

> **阻塞 vs 非阻塞**: 关键是某进程在时间片用完之前会不会被操作系统置为`sleep`状态,进而CPU切换执行其他进程。某个进程在调用系统方法时(如IO)，若该方法没完成时，操作系统将该进程状态切换为`sleep`状态，然后去执行其他进程，则为阻塞；若在时间片用完之前，即使该方法没完成，依旧返回，不会将该进程置为`sleep`状态，则为非阻塞。

> **同步 vs 异步**：


### 2.4 总结


{: .img_middle_hg}
![Nginx_process_demon]({{site.url}}/assets/images/posts/-14_Backend/2015-11-01-Backend_Nginx/Part2_nginx_架构基础.png)


## 3 详解HTTP模块

## 4 反向代理和负载均衡

## 5 Nginx的系统层性能优化

## 6 从源码视角深入使用Nginx与OpenResty

{: .img_middle_hg}
![NodeJS]({{site.url}}/assets/images/posts/-14_Backend/2015-10-09-Backend：Server Architecture/NodeJS.png)

## 2 参考资料 ##

- [The Architecture of Open Source Applications: Nginx](http://www.aosabook.org/en/nginx.html);


