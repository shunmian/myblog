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

> Fork/Join: 多线程的divide and conqure思想。`RecursiveTask`递归定义了任务如何divide和conqure， 实例方法`fork`和`join`定义了多线程的如何协作。 `ForkJoinPool`管理`RecursiveTask`的线程池。Fork/Join类似与单机版的Map/Reduce。

{% highlight mysql linenos %}

package divide;

import java.util.concurrent.ForkJoinPool;
import java.util.concurrent.Future;
import java.util.concurrent.RecursiveTask;

public class ForkAndJoinAddition extends RecursiveTask<Long> {

  final long THRESH_HOLD = 10000000000L;

  long start;
  long end;
  long sum;

  ForkAndJoinAddition(long start, long end) {
    this.start = start;
    this.end = end;
    this.sum = 0;
  }

  @Override
  protected Long compute() {
   
   Boolean shouldCompute = end - start < this.THRESH_HOLD; 

   if(shouldCompute) {
      for (long i = this.start; i <= this.end; i++) {
        this.sum += i;
      }
   } else {
      long middle = (start + end) / 2;
      ForkAndJoinAddition left = new ForkAndJoinAddition(start, middle);
      ForkAndJoinAddition right = new ForkAndJoinAddition(middle + 1, end);

      left.fork();
      right.fork();

      long leftSum = left.join();
      long rightSum = right.join();

      this.sum = leftSum + rightSum;
   }

    return this.sum;
  }

  public static long run(long start, long end) {
    ForkJoinPool forkJoinPool = new ForkJoinPool();
    ForkAndJoinAddition forkAndJoinAddition = new ForkAndJoinAddition(start, end);
    Future<Long> totalSum = forkJoinPool.submit(forkAndJoinAddition);

    try {
      long result = totalSum.get();
      System.out.println(start + " + ... + " + end + " = " + result);
      return result;
    } catch(Exception e) {
      return 0;
    }
  }
  public static void main(String[] args) {
    ForkAndJoinAddition.run(1,4);
  }
}

{% endhighlight %}

### 1.3 Future

> Future, 类似与js的Promise，封装了一个异步过程的返回值或错误。通常与`Callable`结合(`Future<Integer> result = executor.submit(task)`)。

{% highlight mysql linenos %}
public class Test {
    public static void main(String[] args) {
        ExecutorService executor = Executors.newCachedThreadPool();
        Task task = new Task();
        Future<Integer> result = executor.submit(task);
        executor.shutdown();
         
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e1) {
            e1.printStackTrace();
        }
         
        System.out.println("主线程在执行任务");
         
        try {
            System.out.println("task运行结果"+result.get());
        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (ExecutionException e) {
            e.printStackTrace();
        }
         
        System.out.println("所有任务执行完毕");
    }
}
class Task implements Callable<Integer>{
    @Override
    public Integer call() throws Exception {
        System.out.println("子线程在进行计算");
        Thread.sleep(3000);
        int sum = 0;
        for(int i=0;i<100;i++)
            sum += i;
        return sum;
    }
}
{% endhighlight %}

### 1.4 Guarded Suspension模式

> Guarede suspension: 获取锁之后需要检查某一条件是否满足，若不满足，则block，直到满足。满足后需要重新检测条件，通过while而不是if来实现。

{% highlight mysql linenos %}


public class Example {
    synchronized void guardedMethod() {
        while (!preCondition()) {
            try {
                // Continue to wait
                wait();
                // …
            } catch (InterruptedException e) {
                // …
            }
        }
        // Actual task implementation
    }
    synchronized void alterObjectStateMethod() {
        // Change the object state
        // …
        // Inform waiting threads
        notify();
    }
}

{% endhighlight %}

### 1.5 Balking模式

> Balking: 获取锁后，若条件不满足，立即返回(不像Guarded Suspension，一直等待直到条件满足)。 Balking模式适用与两个线程做同样的动作，若其中一个做完，另一个不做立即返回。比如有个用户线程要手动存储修改的数据到文件，还有个后台线程以每秒一次的频率自动存储数据到文本， 若用户线程已经在1秒的间隔内手动保存，则后台线程1秒到后检查到已存储，则立即返回；若用户线程修改后在1秒的间隔内不存储，则后台线程1秒到后检查到为存储，则执行存储。此后用户线程超常进行存储时，发现修改已存储，则不存储。

{% highlight mysql linenos %}

// Data.java

package divide;

import java.io.FileWriter;
import java.io.IOException;

public class Data {
  private String fileName;
  private String content;
  private Boolean changed;

  Data(String fileName, String content) {
    this.fileName = fileName;
    this.content = content;
    this.changed = false;
  }

  synchronized void change(String content) {
    this.content = content;
    this.changed = true;
  }

  synchronized void save() throws IOException {
    if (!this.changed) {
      return;
    }
    this.doSave();
  }

  void doSave() throws IOException {
    System.out.println(Thread.currentThread().getName() + " calls doSave, content = " + content);
    FileWriter fileWrite = new FileWriter(this.fileName);
    fileWrite.write(this.content);
    fileWrite.close();
    this.changed = false;
  }
  
}

// ChangerThread.java
package divide;

import java.io.IOException;
import java.util.Random;

class ChangerThread extends Thread {
  private final Data data;
  private final Random random = new Random();

 ChangerThread(String name, Data data) {
   super(name);
   this.data = data;
 }

  public void run() {
    try {
      for (int i = 0; true; i++) {
        this.data.change("No: " + i);
        Thread.sleep(random.nextInt(1000)); //执行其他操作
        this.data.save();
      }
    } catch (IOException e) {
      e.printStackTrace();
    } catch(InterruptedException e) {
      e.printStackTrace();
    }
  }
}

// SaverThread

package divide;

import java.io.IOException;

class SaverThread extends Thread {
  private final Data data;

 SaverThread(String name, Data data) {
   super(name);
   this.data = data;
 }

  public void run() {
    try {
      while (true) {
        this.data.save();
        Thread.sleep(1000);
      }
    } catch (IOException e) {
      e.printStackTrace();
    } catch(InterruptedException e) {
      e.printStackTrace();
    }
  }
}

// Balking.java

public class Balking {
  public static void main(String[] args) {
    System.out.println("Test Balking");
    Data data = new Data("data.txt", "empty");
    new ChangerThread("ChangerThread", data).start();
    new SaverThread("SaverThread", data).start();
  }
}

{% endhighlight %}


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







