---
layout: post
title: Java Concurrency (一)：java.util.concurrent
categories: [-11 Concurrency]
tags: [Concurrency]
number: [-11.02]
fullview: false
shortinfo: Java java.util.conurrent库的总结。

---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1. 分工

### 1.1 Excutor与线程池

### 1.2 Fork/Join

### 1.3 Future

### 1.4 Guarded Suspension模式

### 1.5 Balking模式

### 1.6 Thread-Per-Message模式

### 1.7 生产者-消费者模式

### 1.8 Worker Thread模式

### 1.9 两阶段终止模式

## 2 协作(sleep-awake)

### 2.1 信号量(Semaphore)

### 2.2 管程(Monitor)：Lock & Condition + Synchronized

### 2.3 倒数计数锁(CountDownLatch)

### 2.4 回环栏栅(CyclicBarrier)

### 2.5 Phaser

### 2.5 Exchanger

## 3 互斥(Mutex)

### 3.1 with lock

#### 3.1.1 synchrnozed

#### 3.1.2 Lock

#### 3.1.3 Write/Read Lock

### 3.2 without lock

#### 3.2.1 不变模式(Immutable)

#### 3.2.2 线程本地存储(ThreadLocal)

#### 3.2.3 CAS

#### 3.2.4 Copy-on-Write

#### 3.2.5 原子类

#### 3.2.1 不变模式(Immutable)


## 3 总结 ##

{: .img_middle_hg}
![regular expression]({{site.url}}/assets/images/posts//-11_Concurrency/2019-09-01-Java Concurrency Foundamentals/Java thread state machine.png)



{% highlight mysql linenos %}

{% endhighlight %}

## 4 参考资料 ##







