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
![Nginx_architecture](/assets/images/posts/-14_Backend/2015-11-01-Backend_Nginx/Nginx_architecture.png)


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
![Ngin_requst_handle_procedure](/assets/images/posts/-14_Backend/2015-11-01-Backend_Nginx/Nginx_requst_handle_procedure.png)


## 3 详解HTTP模块

## 4 反向代理和负载均衡

## 5 Nginx的系统层性能优化

## 6 从源码视角深入使用Nginx与OpenResty

{: .img_middle_hg}
![NodeJS](/assets/images/posts/-14_Backend/2015-10-09-Backend：Server Architecture/NodeJS.png)

## 2 参考资料 ##

- [The Architecture of Open Source Applications: Nginx](http://www.aosabook.org/en/nginx.html);


