---
layout: post
title: Java Concurrency (三)：Java并发编程实战
categories: [-11 Concurrency]
tags: [Concurrency]
number: [-11.02]
fullview: false
shortinfo: Java并发编程实战的总结。

---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1. 并发理论基础(13讲)

### 1.1 可见性，原子性，互斥性，有序性

#### 1.1.1 为什么需要可见性(cpu cache invalidation)，原子性(atomicity)，互斥性(mutual exclusiveness)

{: .img_middle_hg}
![regular expression]({{site.url}}/assets/images/posts/-11_Concurrency/2019-09-03-Java Concurrency (三) Java并发编程实战/Java Memory Model(cache-invalidation & atomicity & mutual-exclusiveness).png)




### 1.2 Java内存模型: Java如何解决可见性和有序性问题

#### 1.2.1 什么是`volatile`

#### 1.2.2 什么是`synchronized`

#### 1.2.3 什么是`final`

#### 1.2.4 6个Happens Before



### 1.3 互斥锁(上): 解决原子性问题

### 1.4 互斥锁(下): 如何用一把锁保护多个资源

### 1.5 死锁怎么办

### 1.6 “等待-通知”优化循环等待

### 1.7 安全性，活跃性以及性能问题

### 1.8 管程: 并发编程的万能钥匙

### 1.9 Java线程(上): 生命周期

### 1.10 Java线程(中): 创建多少线程才是合适的

### 1.11 Java线程(下): 为什么局部变量是线程安全的

### 1.12 如何用面向对象思想写好并发程序

### 1.13 理论基础模块热点问题答疑

## 2. 并发工具类(14讲)

### 2.1 Lock和Condition(上): 隐藏在并发包中的管程

### 2.2 Lock和Condition(下): Dubbo如何用管程实现异步转同步

### 2.3 Semaphore: 如何快速实现一个限流器

### 2.4 ReadWriteLock: 如何快速实现一个完备的缓存

### 2.5 StampedLock: 有没有比读写锁更快的锁

### 2.6 CountDownLatch和CyclicBarrier: 如何让多线程步调一致

### 2.7 并发容器: 都有哪些坑需要我们填

### 2.8 原子类: 无锁工具类的典范

### 2.9 Executor与线程池: 如何窗口正确的线程池

### 2.10 Future: 如何用多线程实现最优的烧水泡茶程序

### 2.11 CompleteFuture: 异步编程没那么难

### 2.12 CompletionService: 如何批量执行异步任务

### 2.13 Fork/Join: 单机版的MapReduce

### 2.14 并发工具类模块热点问题答疑

## 3. 并发设计模式(10讲)

### 3.1 Immutability模式: 如何利用不变性解决并发问题

### 3.2 Copy-on-Write模式: 不是延时策略的COW

### 3.3 线程本地存储模式: 没有共享，就没有伤害

### 3.4 Guarded Suspension模式: 等待唤醒机制的规范实现

### 3.5 Balking模式: 再谈线程安全的单例模式

### 3.6 Thread-Per-Message模式: 最简单试用的分工方法

### 3.7 Worker Thread模式：如何避免重复创建线程

### 3.8 两阶段终止模式: 如何优雅地终止线程

### 3.9 生产者-消费者模式: 用流水线思想提高效率

### 3.10 设计模式模块热点问题答疑

## 4. 案例分析(4讲)

### 4.1 高性能限流器: Guava RateLimiter

### 4.2 高性能网络应用框架: Netty

### 4.3 高性能队列: Disruptor

### 4.4 高性能数据库连接池: HiKariCP

## 5. 其他并发模型(4讲)

### 5.1 Acotr模型: 面向对象原生的并发

### 5.2 软件事务内存: 借鉴数据库的并发经验

### 5.3 协程: 更轻量级的线程

### 5.4 CSP模型: Golang的主力队员








## 3 总结 ##

{: .img_middle_hg}
![regular expression]({{site.url}}/assets/images/posts//-11_Concurrency/2019-09-01-Java Concurrency Foundamentals/Java thread state machine.png)



{% highlight java linenos %}

{% endhighlight %}

## 4 参考资料 ##







