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

{: .img_middle_hg}
![regular expression]({{site.url}}/assets/images/posts/-11_Concurrency/2019-09-03-Java Concurrency (三) Java并发编程实战/Java Memory Model(cache-invalidation & atomicity & mutual-exclusiveness & unreorder).png)

{: .img_middle_hg}
![regular expression]({{site.url}}/assets/images/posts/-11_Concurrency/2019-09-03-Java Concurrency (三) Java并发编程实战/Multiple CPU & Multiple Threads.png)


### 1.2 Java内存模型: Java如何解决可见性和有序性问题

> Java内存模型: 通过3个关键字`volatile`, `final` 和 `synchronized`, 6条`Happens Before`来确保一定粒度的cache invalidation, aotmicity, mutual exclusiveness and unredorder.

#### 1.2.1 3个关键字 `volatile`, `final`, `synchronized`

##### 1.2.1.1 对变量`volatile`, `final`

> `volatile`, 对于volatile变量的读写，禁用cpu memory cache。



> `final`, 对于final的变量，在构造器里确保初始化完全。

##### 1.2.1.2 对函数 `synchronized`

> `synchronized`, 对于synchronized的函数或者代码块(block)，同一个syncrhonized的锁的前提下，不同线程之间的该syncrhonized代码的执行是atomic, mutual exclusive, 涉及到的变量是cache invalidation的，且保证后执行的synchornized代码的线程能看到前面执完synchornized代码的线程的变量的改变。

#### 1.2.2 6个Happens Before (reorder的规则)

> RULE 1: 语义顺序性

{% highlight java linenos %}
int func1() {
 int i = 0;
 int j = 1;
 return i + j;
}

// 允许代码重排，但是得保证语义的顺序性
int func2() {
 int j = 1;
 int i = 0;
 return i + j;
}
{% endhighlight %}

> RULE 2: Volatile变量的写操作，不会被reorder后放在它的读操作后面

> RULE 3: 传递性

{% highlight java linenos %}
class VolatileExample {
 int x = 0;
 volatile boolean v = false;
 public void writer() {
  x = 42;
  v = true;
 }
 public void reader() {
   if (v == true) { // 这里x会是多少呢？    }  }} // java 1.5 之前的内存模型，x可能是0或42; 1.5之后的内存模型， 由于RULE 1,2,3，x一定是42
// RULE1 x = 42 先于 v = true
// RULE2 v = true 先于 v == true
// RULE3 x = 42 先于 v == true
{% endhighlight %}

> RULE 4: lock release happens before next lock require (must be same lock)


{% highlight java linenos %}
synchronized (this) { //此处自动加锁 Thread A 先执行， Thread B 后执行
  // x是共享变量,初始值=10
  if (this.x < 12) {
    this.x = 12; 
  }  
} //此处自动解锁

// 若x初始值是0， 则Thread A执行完后，Thread B进入syncrhonized块，看到的x一定是12(被Thread A 改过), 但前提是synchronized的锁都是同一个(这里都是this).
{% endhighlight %}

> RULE 5: 线程start()规则，线程 A 启动子线程 B 后，子线程 B 能够看到主线程在启动子线程 B 前的操作。


{% highlight java linenos %}
Thread B = new Thread(()->{
  // 主线程调用B.start()之前
  // 所有对共享变量的修改，此处皆可见
  // 此例中，var==77
});
// 此处对共享变量var修改
var = 77;
// 主线程启动子线程
B.start();
{% endhighlight %}


> RULE 6: 线程start()规则, 线程 A 启动子线程 B 后，线程 A join 等待 子线程 B，那么线程 A 在 join 后 能够看到子线程 B 的操作 


{% highlight java linenos %}

Thread B = new Thread(()->{
  // 此处对共享变量var修改
  var = 66;
});
// 例如此处对共享变量修改，
// 则这个修改结果对线程B可见
// 主线程启动子线程
B.start();
B.join()
// 子线程所有对共享变量的修改
// 在主线程调用B.join()之后皆可见
// 此例中，var==66
{% endhighlight %}

### 1.3 互斥锁(上): 解决原子性问题

{% highlight java linenos %}
{% endhighlight %}

### 1.4 互斥锁(下): 如何用一把锁保护多个资源

{% highlight java linenos %}
{% endhighlight %}

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







