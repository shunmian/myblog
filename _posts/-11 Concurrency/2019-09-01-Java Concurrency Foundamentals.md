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

{% highlight java linenos %}
Thread.yield();

Thread.sleep(long ms);
Thread.sleep(int s);

t1.join();
t1.join(long ms); // throws InterruptedException
t1.join(int s); // throws InterruptedException

t1.interrupt(); // put a sleeping or joint thread into execution 


{% endhighlight %}

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
// main thread wait for child thread
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

// child thread wait for main thread.
class MyRunnable implements Runnable {

  static Thread mt;
  public void run() {
    try {
    mt.join();
    }catch (InterruptedException e) {
    }
    for (int i = 0; i < 10; i ++) {
       System.out.println(Thread.currentThread().getName() +  ": Child without args: " + i);
       try{
          Thread.sleep(200);
       } catch (InterruptedException e) {
          System.out.println("interuppted: " + i);
       }
    }
  } 
}


class MyRunnableDemo {

  static public void main(String[] args) {
    MyRunnable myRunnable  = new MyRunnable();
    Thread t1 = new Thread(myRunnable);
    t1.setName("C1");
    MyRunnable.mt = Thread.currentThread(); 
     t1.start();
   for (int i = 0; i < 10; i ++) {
      System.out.println("Parent: " + i);
      try{
      Thread.sleep(200);
      }catch (Exception e) {

      }
    }
  }
}

{% endhighlight %}

> `Thread.sleep(long ms)`: wait for ms milliseconds. `Thread.sleep(int s)`: wait for s seconds.

> `t1.interrupt`: wake up sleep or join thread

{% highlight java linenos %}
class MyRunnable implements Runnable {
  public void run() {
    try {
      for (int i = 0; i < 10; i ++) {
        System.out.println(Thread.currentThread().getName() +  ": Child without args: " + i);
        Thread.sleep(200);
      }
    } catch(InterruptedException e) {
      System.out.println("Child thread interuppted");
    }
  }
}


class MyRunnableDemo {
  static public void main(String[] args) {
    MyRunnable myRunnable  = new MyRunnable();
    Thread t1 = new Thread(myRunnable);
    t1.start();
    t1.interrupt();
    System.out.println("Parent thread end");
  }
}
{% endhighlight %}


{% highlight java linenos %}
class MyRunnable implements Runnable {
  public void run() {
    for (int i = 0; i < 1000; i ++) {
      System.out.println(Thread.currentThread().getName() +  ": Child without args: " + i);
    }
  
    System.out.println(Thread.currentThread().getName() +  "I'm going to sleep");
    try {
      Thread.sleep(1000);
      System.out.println(Thread.currentThread().getName() +  "I'm sleep");
    } catch(InterruptedException e) {
      System.out.println(Thread.currentThread().getName() +  "I'm interrupted");
    }
  }

}


class MyRunnableDemo {
  static public void main(String[] args) {
    MyRunnable myRunnable  = new MyRunnable();
    Thread t1 = new Thread(myRunnable);
    t1.start();
    t1.interrupt();
    System.out.println("Parent thread end");
  }
}
/* Output:
Child without args: 1
...
Child without args: 999
                    <- interrupt method will wait until t1 enter into waiting state
I'm going to sleep
I'm interrupted
*/
{% endhighlight %}


{: .img_middle_lg}
![regular expression]({{site.url}}/assets/images/posts//-11_Concurrency/2019-09-01-Java Concurrency Foundamentals/thread-giveup-methods-summary.png)


## 6. Synchronization

> `synchronizd`: a modifier only for procedure (function or block of code) not for data (class or variable). synchronization garantuees only one thread can execute the procedure. `synchronized` increase thread waiting overhead to avoid data inconsistent issue. `synchronized` always pair with lock. The lock acquiring and release is performed by the JVM automatically. Each object has just one internal lock that used by all the `synchronized` methods for that object. For method that only read data, no `synchronized` is needed; For that that includes write to data, `synchronized` is needed for data consistency.


{% highlight mysql linenos %}
class Reservation {
  // synchronized make sure it is only executed by one thread 
  synchronized void book () {
    for (int i = 0; i < 100; i ++) {
      System.out.println(Thread.currentThread().getName() +  ": Child without args: " + i);
    }
  }
}

class MyRunnable implements Runnable {
  String name;
  Reservation reservation;
  
  MyRunnable(String name, Reservation reservation){
    this.name = name;
    this.reservation = reservation;
  }

  public void run() {
    this.reservation.book();
  }

}


class MyRunnableDemo {
  static public void main(String[] args) {
    Reservation reservation = new Reservation();
    MyRunnable myRunnable1 = new MyRunnable("r1", reservation);
    MyRunnable myRunnable2 = new MyRunnable("r2", reservation);
    Thread t1 = new Thread(myRunnable1);
    Thread t2 = new Thread(myRunnable2);
    t1.start();
    t2.start();
    System.out.println("Parent thread end");
  }
}
{% endhighlight %}

> `synchronized` block. If a method contains several lines, and only line 9 needs to synchronize. It is not recommended to synchronize the entire funciton, which slow down unnecessary performance due to unnecessary synchronization. In this case, one can use `synchronized` block to only synchronize line 9 to minimize synchronization code.


{% highlight mysql linenos %}
class Reservation {
  
  void book () {
    // a 100 lines of code doesn't require synchronization
    for (int i = 0; i < 100; i ++) {
      System.out.println(Thread.currentThread().getName() +  "outside : Child without args: " + i);
    }

    // only this block needs synchronization
    synchronized(this) {
      for (int i = 0; i < 100; i ++) {
        System.out.println(Thread.currentThread().getName() +  " inside: Child without args: " + i);
      }
    }
  }
}

class MyRunnable implements Runnable {
  String name;
  Reservation reservation;
  
  MyRunnable(String name, Reservation reservation){
    this.name = name;
    this.reservation = reservation;
  }

  public void run() {
    this.reservation.book();
  }

}


class MyRunnableDemo {
  static public void main(String[] args) {
    Reservation reservation = new Reservation();
    MyRunnable myRunnable1 = new MyRunnable("r1", reservation);
    Thread t1 = new Thread(myRunnable1);
    t1.setName("Thread A");
    Thread t2 = new Thread(myRunnable1);
    t2.setName("Thread B");
    t1.start();
    t2.start();
    System.out.println("Parent thread end");
  }
}
{% endhighlight %}


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







