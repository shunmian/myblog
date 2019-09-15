---
layout: post
title: Java Concurrency Foundamentals 
categories: [Concurrency]
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

## 1. Introduction

Two types of multi-task programming
- multi-process
- multi-threads

## 2. The ways to define a thread

> 2 ways to define a thread: extending the `Thread` class, or implementing `Runnable` interface.

Every java program starts with one thread that is the `main` thread. The thread scheduling is implemented by JVM. So We cannot garantee the order of threads execution order.



{% highlight java linenos %}

class MyThread extends Thread {
  public void run() {
    for (int i = 0; i < 10; i ++) {
      System.out.println("Child: " + i);
    }
  }  
}

class MyThreadDemo {

  static public void main(String[] args) {
    MyThread myThread = new MyThread();
    myThread.start();
    /* 
      Here we have 2 threads running, main and myThread. The JVM will schedule thread and execute run method of myThread, so the 
      Out put can be intermixing of "Parent: *" and "Child:". If we change the above  myThread.start() to myThread.run(), no running myThread is executed; the run method is called in main thread so the output is determined with 10 "Child: *" followed by 10 "Parent: *" 
    */
    for (int i = 0; i < 10; i ++) {
      System.out.println("Parent: " + i);
    }
  }
}

{% endhighlight %}


## 3. Getting and Setting name of thread

## 4. Thread priority

## 5. The method to prevent thread execution

## 6. Synchronization

## 7. Inter threads communication

## 8. Deadlock

## 9. Daemon Threads

## 10. Multi-threads enhancements

## 3 总结 ##


{: .img_middle_hg}
![regular expression]({{site.url}}/assets/images/posts/2015-06-01/client mysql.jpg)

{% highlight mysql linenos %}

{% endhighlight %}

## 4 参考资料 ##







