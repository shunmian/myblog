---
layout: post
title: Libevent源码分析
categories: [-11 Concurrency]
tags: [Libevent]
number: [-14.01]
fullview: false
shortinfo: Libevent源码分析

---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1. Introduction

### 1.1 编译源码

{% highlight c linenos %}
git clone https://github.com/libevent/libevent.git
mkdir build && cd build
cmake .. 
// 出现system variable OPENSSL_ROOT_DIR (missing: OPENSSL_INCLUDE_DIR)
cmake -DOPENSSL_ROOT_DIR=/usr/local/opt/openssl -DOPENSSL_LIBRARIES=/usr/local/opt/openssl/lib ..
make

{% endhighlight %}


## 3. 查漏补缺 ##

### 3.1 Thread 状态机 和 基本操作

`synchronize`

### 3.2 `java.util.concurrency.locks` ReentrantLock

### 3.3 Executors

## 4. 总结

{: .img_middle_hg}
![regular expression]({{site.url}}/assets/images/posts//-11_Concurrency/2019-09-01-Java Concurrency Foundamentals/Java thread state machine.png)


{% highlight java linenos %}

{% endhighlight %}


## 4 参考资料 ##







