---
layout: post
title: Java Concurrency in Practice 
categories: [-11 Concurrency]
tags: [Concurrency]
number: [-7.15]
fullview: false
shortinfo: 。

---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## Part I: Introduction

> The root problem of concurrency is that: shared object is mutate in multiple threads. The mutate usually involves read and write, which is not atomic. This leads to Thread A read v1 and about to write v1+1; while Thread B also read v1 and about to write v1+1. The epxected result is v1+2 not v1+1. The solution is to either make shared object accessed by multi threads read only or make read write atomic.

### C1 Introduction

## Part II:  Foundatmentals

### C2: Thread Safety

> Thread safety: if the variable meets the ` The solution is to either make shared object accessed by multi threads read only or make read write atomic` requirements, it is called thread safe, which require no extra sync code in its calling function in different threads. The `synchronizaton` keyword is the tool that make a block of codes atomic in jave.

To avoid thread unsafety, there are 3 methods:
- Don't share the state variable across threads;
- Make the state variable immutable;
- Use synchroniztion whenever accessing the state variable.

> A class is thread-safe if it behaves correctly when accessed from multiple threads, regardless of the scheduling or interleaving of the execution of those threads by the runtime environment, and with no additional synchronization or other coordinnate on the part of the calling code.

> Thread- safe classed encapsulate any needed synchronization so that clients need not provide their own.

> stateless objects are always thread-safe. Since the variable is internal to function stack and is not accessed from other threads, it is always thread-safe. The below code always return 1 no matter how it is accessed from multiple threads.

{% highlight java linenos %}
public class ThreadSafeClass {
  public Integer incrementFromZero() {
    Integer i = 0;
    i++；
    return i;
  }
}
{% endhighlight %}

#### C2.2 Atomicity: read-and-write(counter) & check-then-act(lazy instantiate)

{% highlight java linenos %}
// read-and-write(counter)
public class ThreadUnsafeClass {
  private Integer i = 0;
  public Integer increment() {
    i++；
    return i;
  }
}

// solution to make ThreadUnsafeClass thread safe 
public class ThreadUnsafeClass {
  private AtomicLong count = new AtomicLong(0)
  public Integer increment() {
    return count.incrementAndGet();
  }
}

{% endhighlight %}

{% highlight java linenos %}
// check-then-act(lazy instantiate)
public class ThreadUnsafeClass {
  private Integer i = 0;
  private ThreadUnsafeClass _instance = null; 
  public ThreadUnsafeClass getSingleton() {
    if(_instance = null){
      _instance = new ThreadUnsafeClass();
    }
    return _instance;
  }
}
{% endhighlight %}




### C3: Sharing Objects

### C4: Composing Objects

### C5: Building Blocks


## Part III: Instructuring Concurrent Applications

### C6: Task Execution

### C7: Cancellation and Shutdown

### C8: Applying Thread Pools

### C9: GUI Applications

## Part IV: Liveness, Performance, and Testing

### C10: Avoiding Liveness Hazards

### C11: Performance and Scalability

### C12: Testing Concurrent Programs


对于生产者消费者的缓存模型的并发测试令人印象深刻，主要讲解了：
1. 如何让多个线程的交叉时间增加？等待所有线程初始化后再开始让线程进入主要并发逻辑(`cyclicBarrier.wait()`);

2. 如何测试生产的对象和消费的对象等价？
  1. 用整数作为对象。
  2. 用满足交换律(多个生产线程之间的生产顺序不会影响最终结果；多个消费线程之间的消费顺序不会影响最终结果)的加法作为reduce的运算符，将生产者的所有生产对象的信息最终用1个sum来表示，消费者的所有生产对象的信息用1个sum来表示。比较两个sum即比较所有生产调度对象和消费的对象等价。
  3. 如何让每次测试的生产对象不一样？`xorShift`中等质量的随机数产生器。


## Part V: Advanced Topics

### C13: Explicit locks

### C14: Building Custom Synchronizers

### C15: Atomic Variable and Nonblocking Synchronization

### C16: The Java Memory Model

## Appendix

### A: Annotations for Concurrency

## 3 总结 ##


{: .img_middle_hg}
![regular expression]({{site.url}}/assets/images/posts/2015-06-01/client mysql.jpg)

{% highlight mysql linenos %}

{% endhighlight %}

## 4 参考资料 ##







