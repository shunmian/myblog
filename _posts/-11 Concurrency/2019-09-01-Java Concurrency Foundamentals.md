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

> 2 ways to define a thread: extending the `Thread` class, or implementing `Runnable` interface. Latter is recommended over the former since latter can extends from other class, which is more flexible.

Every java program starts with one thread that is the `main` thread. The thread scheduling is implemented by JVM. So We cannot garantee the order of threads execution order.

### 2.1 Extending Thread Class

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

`thread.start()` responsible for 3 things:
- Register this thread with thread scheduler;
- Perform all other mandatory activities;
- invokde `thread.run()`.

In java there is no other way to create a thread except run `thread.start()`.

If run method is overloaded, `myThread.start()` will call the `run` method without args.

If `MyThread` doesn't override `run` method, the parent class `Thread`'s `run` method will be run, which has empty body by default.

Do not override `start` method, otherwise the default behavior of start will lose.

### 2.2 Implementing Runnable Interface

Runnable(I) -> Thread -> MyThread; or Runnable(I) -> MyRunnable;

{: .img_middle_mid}
![regular expression]({{site.url}}/assets/images/posts//-11_Concurrency/2019-09-01-Java Concurrency Foundamentals/Runnable Inteface.png)

{% highlight java linenos %}

class MyRunnable implements Runnable {
  public void run() {
    for (int i = 0; i < 10; i ++) {
      System.out.println("Child without args: " + i);
    }
  } 
}


class MyRunnableDemo {

  static public void main(String[] args) {
    MyRunnable myRunnable  = new MyRunnable();
    Thread t = new Thread(myRunnable); // use myRunnable to instantiate Thread.
    t.start(); // This will call myRunnable.run();
    for (int i = 0; i < 10; i ++) {
      System.out.println("Parent: " + i);
    }

    System.out.println(Thread.currentThread().setName("MyMain"));
    System.out.println(Thread.currentThread().getName());
  }
}

{% endhighlight %}

## 3. Getting and Setting name of thread

{% highlight java linenos %}
System.out.println(Thread.currentThread().setName("MyMain"));
System.out.println(Thread.currentThread().getName());
{% endhighlight %}

## 4. Thread priority

> Thread priority ranges from 1(min) to 10(max)

{% highlight java linenos %}
Thread.MIN_PRIORITY //1
Thread.NORM_PRIORITY // 5
Thread.MAX_PRIORITY // 10

Thread.currentThread().getPriority();
Thread.currentThread().setPriority(8);

Thread t = new Thread();
t.getPriority() // default to the calling thread's priority, which is 8
{% endhighlight %}


## 5. The method to prevent thread execution

> `Thread.yield()`: current thread gives up execution.


{% highlight java linenos %}

class MyRunnable implements Runnable {
  public void run() {
    for (int i = 0; i < 10; i ++) {
      System.out.println("Child without args: " + i);
      Thread.yield(); // <- at end of each loop, this Runnable will give up possessing of proccesor and be put in thread waiting set. The thread scheduler will choose the next thread to run based on thread scheduler policy
    }
    System.out.println(Thread.currentThread());
  } 
}


class MyRunnableDemo {

  static public void main(String[] args) {
    MyRunnable myRunnable  = new MyRunnable();
    Thread t = new Thread(myRunnable);
    t.start();;
    for (int i = 0; i < 10; i ++) {
      System.out.println("Parent: " + i);
    }
    Thread.currentThread().setName("MyMain");
      System.out.println(Thread.currentThread());
  }
}

{% endhighlight %}

> `t1.join()`, calling thread will wait until t1 finish. `t1.join(ms)`, will wait ms milliseconds and will throw exception when time is up.




{% highlight java linenos %}

class MyRunnable implements Runnable {
  public void run() {
    for (int i = 0; i < 10; i ++) {
       System.out.println(Thread.currentThread().getName() +  ": Child without args: " + i);
       try{
          Thread.sleep(2000);
       } catch (InterruptedException e) {
          System.out.println("interuppted: " + i);
       }
    }
    System.out.println();
  } 
}


class MyRunnableDemo {

  static public void main(String[] args) {
    MyRunnable myRunnable  = new MyRunnable();
    Thread t1 = new Thread(myRunnable);
    t1.setName("C1");
    
     t1.start();
    try {
      t1.join();
    } catch (InterruptedException e) {
      e.printStackTrace();
    }

    for (int i = 0; i < 10; i ++) {
      System.out.println("Parent: " + i);
    }
    Thread.currentThread().setName("MyMain");
      System.out.println(Thread.currentThread());
  }
}

{% endhighlight %}


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







