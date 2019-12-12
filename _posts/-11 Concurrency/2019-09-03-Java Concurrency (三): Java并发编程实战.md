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
![multithreads procedure summary]({{site.url}}/assets/images/posts/-11_Concurrency/2019-09-03-Java Concurrency (三) Java并发编程实战/Multiple CPU & Multiple Threads.png)


### 1.2 Java内存模型: Java如何解决可见性和有序性问题

> Java内存模型: 通过3个关键字`volatile`, `final` 和 `synchronized`, 6条`Happens Before`来确保一定粒度的cache invalidation, aotmicity, mutual exclusiveness and unredorder.

#### 1.2.1 3个关键字 `volatile`, `final`, `synchronized`

##### 1.2.1.1 对变量`volatile`, `final`

> `volatile`, 上图的1, cache invalidation，对于volatile变量的读写，禁用cpu memory cache。

> `final`, 对于final的变量，在构造器里确保初始化完全。

##### 1.2.1.2 对函数 `synchronized`

> `synchronized`, 上图的0,1,2, 即mutual exclusive, cache invalidation and atomic. 对于synchronized的函数或者代码块(block)，同一个syncrhonized的锁的前提下，不同线程之间的该syncrhonized代码的执行是atomic, mutual exclusive, 涉及到的变量是cache invalidation的，且保证后执行的synchornized代码的线程能看到前面执完synchornized代码的线程的变量的改变。

#### 1.2.2 6个Happens Before (reorder的规则)

> 6 Happens Before, 即上图中的-1, 编译的顺序保证。

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

即上图中0的保证。

{% highlight java linenos %}
{% endhighlight %}

### 1.4 互斥锁(下): 如何用一把锁保护多个资源

Account类，需要转账从accountA到accountB, accountB到accountC, 不同的实例需要用同一个锁

{% highlight java linenos %}
/* 不可行，因为accountA的sycnrhonized的锁是accountA, accountB的sycnrhonized的锁是accountB
class Account {
  private int balance;
  // 转账
  synchronized void transfer(
      Account target, int amt){
    if (this.balance > amt) {
      this.balance -= amt;
      target.balance += amt;
    }
  } 
}
*/

// 用Account.class类锁，保证每个实例的锁都是Account类，保证了正确性，但是都成了串行，性能在实际应用中不可行。
class Account {
  private int balance;
  // 转账
  void transfer(Account target, int amt){
    synchronized(Account.class) {
      if (this.balance > amt) {
        this.balance -= amt;
        target.balance += amt;
      }
    }
  } 
}

{% endhighlight %}

### 1.5 死锁怎么办

> 死锁的形成：锁的等待形成有向有环图。A->B->C->D..->N->A

> 细粒度锁： 相比锁Account.class, 锁accountA和accountB，粒度要小，但是代价是可能形成死锁。

{% highlight java linenos %}
class Account {
  private int balance;
  // 转账
  void transfer(Account target, int amt){
    // 锁定转出账户
    synchronized(this) {              
      // 锁定转入账户
      synchronized(target) {           
        if (this.balance > amt) {
          this.balance -= amt;
          target.balance += amt;
        }
      }
    }
  } 
}
{% endhighlight %}

解决方案
1. 互斥，共享资源 X 和 Y 只能被一个线程占用；
2. 占有且等待，线程 T1 已经取得共享资源 X，在等待共享资源 Y 的时候，不释放共享资源 X；
3. 不可抢占，其他线程不能强行抢占线程 T1 占有的资源；
4. 循环等待，线程 T1 等待线程 T2 占有的资源，线程 T2 等待线程 T1 占有的资源，就是循环等待。

{% highlight java linenos %}
// 破坏2， 占用且等待

class Allocator {
  private List<Object> als =
    new ArrayList<>();
  // 一次性申请所有资源
  synchronized boolean apply(
    Object from, Object to){
    if(als.contains(from) ||
         als.contains(to)){
      return false;  
    } else {
      als.add(from);
      als.add(to);  
    }
    return true;
  }
  // 归还资源
  synchronized void free(
    Object from, Object to){
    als.remove(from);
    als.remove(to);
  }
}

class Account {
  // actr应该为单例
  private Allocator actr;
  private int balance;
  // 转账
  void transfer(Account target, int amt){
    // 一次性申请转出账户和转入账户，直到成功
    while(!actr.apply(this, target))
      ；
    try{
      // 锁定转出账户
      synchronized(this){              
        // 锁定转入账户
        synchronized(target){           
          if (this.balance > amt){
            this.balance -= amt;
            target.balance += amt;
          }
        }
      }
    } finally {
      actr.free(this, target)
    }
  } 
}
{% endhighlight %}


{% highlight java linenos %}
// 破坏4，循环等待条件，对于“循环等待”这个条件，可以靠按序申请资源来预防。所谓按序申请，是指资源是有线性顺序的，申请的时候可以先申请资源序号小的，再申请资源序号大的，这样线性化后自然就不存在循环了。这个的的代价比破坏2的解决方案小。

class Account {
  private int id;
  private int balance;
  // 转账
  void transfer(Account target, int amt){
    Account left = this        ①
    Account right = target;    ②
    if (this.id > target.id) { ③
      left = target;           ④
      right = this;            ⑤
    }                          ⑥
    // 锁定序号小的账户
    synchronized(left){
      // 锁定序号大的账户
      synchronized(right){ 
        if (this.balance > amt){
          this.balance -= amt;
          target.balance += amt;
        }
      }
    }
  } 
}
{% endhighlight %}

### 1.6 “等待-通知”优化循环等待

> 用sleep-notify模式优化等待: `while(!actr.apply(this, target))；`太耗时，转主动询问为被动等待通知

{% highlight java linenos %}

class Allocator {
  private List<Object> als;
  // 一次性申请所有资源
  synchronized void apply(
    Object from, Object to){
    // 经典写法
    while(als.contains(from) ||
         als.contains(to)){
      try{
        wait(); //释放锁
      }catch(Exception e){
      }   
    } 
    als.add(from);
    als.add(to);  
  }
  // 归还资源
  synchronized void free(
    Object from, Object to){
    als.remove(from);
    als.remove(to);
    notifyAll();
  }
}
{% endhighlight %} 

### 1.7 安全性，活跃性以及性能问题

> 安全性：互斥

> 活跃性：死锁；活锁(两路人相互谦让，结果往左右都碰在一起，前进不了，通过等待一个随机时间来解决)

> 性能性: 阿姆达尔（Amdahl）定律, S = $$\frac{1}{1-p + \frac{p}{n}}$$。即串行率为5%，假设n无限大，那么活得的并行性能提升最大为20倍

第一，既然使用锁会带来性能问题，那最好的方案自然就是使用无锁的算法和数据结构了。在这方面有很多相关的技术，例如线程本地存储 (Thread Local Storage, TLS)、写入时复制 (Copy-on-write)、乐观锁等；Java 并发包里面的原子类也是一种无锁的数据结构；Disruptor 则是一个无锁的内存队列，性能都非常。

第二，减少锁持有的时间。互斥锁本质上是将并行的程序串行化，所以要增加并行度，一定要减少持有锁的时间。这个方案具体的实现技术也有很多，例如使用细粒度的锁，一个典型的例子就是 Java 并发包里的 ConcurrentHashMap，它使用了所谓分段锁的技术（这个技术后面我们会详细介绍）；还可以使用读写锁，也就是读是无锁的，只有写的时候才会互斥。

性能方面的度量指标有很多，我觉得有三个指标非常重要，就是：吞吐量、延迟和并发量。吞吐量：指的是单位时间内能处理的请求数量。吞吐量越高，说明性能越好。延迟：指的是从发出请求到收到响应的时间。延迟越小，说明性能越好。并发量：指的是能同时处理的请求数量，一般来说随着并发量的增加、延迟也会增加。所以延迟这个指标，一般都会是基于并发量来说的。例如并发量是 1000 的时候，延迟是 50 毫秒。

### 1.8 管程: 并发编程的万能钥匙

> 管程模型: 锁和条件变量。其做为一个整体和信号量是等价的。只不过管程模型更符合OOP,所以Java选择了它。

{: .img_middle_mid}
![multithreads procedure summary]({{site.url}}/assets/images/posts/-11_Concurrency/2019-09-03-Java Concurrency (三) Java并发编程实战/管程模型.png)


{% highlight java linenos %}

public class BlockedQueue<T>{
  final Lock lock =
    new ReentrantLock();
  // 条件变量：队列不满  
  final Condition notFull =
    lock.newCondition();
  // 条件变量：队列不空  
  final Condition notEmpty =
    lock.newCondition();

  // 入队
  void enq(T x) {
    lock.lock();
    try {
      while (队列已满){
        // 等待队列不满 
        notFull.await();
      }  
      // 省略入队操作...
      //入队后,通知可出队
      notEmpty.signal();
    }finally {
      lock.unlock();
    }
  }
  // 出队
  void deq(){
    lock.lock();
    try {
      while (队列已空){
        // 等待队列不空
        notEmpty.await();
      }
      // 省略出队操作...
      //出队后，通知可入队
      notFull.signal();
    }finally {
      lock.unlock();
    }  
  }
}
{% endhighlight %}

### 1.9 Java线程(上): 生命周期

见[Thread生命周期]({{site.url}}/-11 concurrency/2019/09/01/Java-Concurrency-(一)-Thread.html#4-总结)。

### 1.10 Java线程(中): 创建多少线程才是合适的

> CPU密集型，最佳线程个数等于CPU个数+1; IO密集型, 最佳线程数 =CPU 核数 * [ 1 +（I/O 耗时 / CPU 耗时）]。

### 1.11 Java线程(下): 为什么局部变量是线程安全的

> 局部变量线程安全的原因：因为多线程的问题根源在于共享可写变量，如果是局部变量，它只在线程的栈上分配，对其他线程是不可见的，类似(退化成1个cpu1个线程执行的情况),所以是线程安全的。

局部变量是和方法同生共死的，一个变量如果想跨越方法的边界，就必须创建在堆里

### 1.12 如何用面向对象思想写好并发程序

1. 封装共享变量 (Allocator)
2. 识别共享变量间的约束条件 (多个共享变量的关系)
3. 制定并发访问策略 (避免共享，不变模式，管程及java.util.concurrent包)

注意事项
1. 优先使用成熟类工具,如`java.uitl.concurrent`;
2. 迫不得已才使用低级原语， `semaphore`, `lock`等;
3. 避免过早优化;


### 1.13 理论基础模块热点问题答疑

> 锁的声明和初始化: 参见[Java安全编码标准](https://book.douban.com/subject/24846041/)。锁，应是私有的、不可变的、不可重用的，

{% highlight java linenos %}
// 普通对象锁
private final Object 
  lock = new Object();
// 静态对象锁
private static final Object
  lock = new Object(); 
{% endhighlight %}

## 2. 并发工具类(14讲)

### 2.1 Lock和Condition(上): 隐藏在并发包中的管程

> 为什么需要`java.util.concurrent`里的`Lock`和`Condition`: 因为`synchronized`在获取锁之前，若锁被占用，会一直阻塞。而并发包里的`Lock`实现了若锁获取不了，可以放弃，或者timeout，它有3个主要API, `void tryLock()`, `void tryLock(long time, Timeout unit)`, `void lockInterruptly() throws InterruptedException`。

{% highlight java linenos %}
// 下面代码会出现死锁吗？不会，但会活锁。
class Account {
  private int balance;
  private final Lock lock
          = new ReentrantLock();
  // 转账
  void transfer(Account tar, int amt){
    while (true) {
      if(this.lock.tryLock()) {
        try {
          if (tar.lock.tryLock()) {
            try {
              this.balance -= amt;
              tar.balance += amt;
            } finally {
              tar.lock.unlock();
            }
          }//if
        } finally {
          this.lock.unlock();
        }
      }//if
    }//while
  }//transfer
}
{% endhighlight %}


### 2.2 Lock和Condition(下): Dubbo如何用管程实现异步转同步




{% highlight java linenos %}

{% endhighlight %}

### 2.3 Semaphore: 如何快速实现一个限流器

{% highlight java linenos %}
class ObjPool<T, R> {
  final List<T> pool;
  // 用信号量实现限流器
  final Semaphore sem;
  // 构造函数
  ObjPool(int size, T t){
    pool = new Vector<T>(){};
    for(int i=0; i<size; i++){
      pool.add(t);
    }
    sem = new Semaphore(size);
  }
  // 利用对象池的对象，调用func
  R exec(Function<T,R> func) {
    T t = null;
    sem.acquire();
    try {
      t = pool.remove(0);
      return func.apply(t);
    } finally {
      pool.add(t);
      sem.release();
    }
  }
}
// 创建对象池
ObjPool<Long, String> pool = 
  new ObjPool<Long, String>(10, 2);
// 通过对象池获取t，之后执行
pool.exec(t -> {
    System.out.println(t);
    return t.toString();
});
{% endhighlight %}

### 2.4 ReadWriteLock: 如何快速实现一个完备的缓存

> 互斥锁： 读读互斥，写写互斥，读写互斥； 读写锁：读读不互斥，读写互斥，写写互斥。因此读写锁是在都多写少的情况下多互斥锁的优化。

{% highlight java linenos %}

class Cache<K,V> {
  final Map<K, V> m =
    new HashMap<>();
  final ReadWriteLock rwl =
    new ReentrantReadWriteLock();
  // 读锁
  final Lock r = rwl.readLock();
  // 写锁
  final Lock w = rwl.writeLock();
  // 读缓存
  V get(K key) {
    r.lock();
    try { return m.get(key); }
    finally { r.unlock(); }
  }
  // 写缓存
  V put(K key, V value) {
    w.lock();
    try { return m.put(key, v); }
    finally { w.unlock(); }
  }
}
{% endhighlight %}


懒加载
{% highlight java linenos %}

class Cache<K,V> {
  final Map<K, V> m =
    new HashMap<>();
  final ReadWriteLock rwl = 
    new ReentrantReadWriteLock();
  final Lock r = rwl.readLock();
  final Lock w = rwl.writeLock();
 
  V get(K key) {
    V v = null;
    //读缓存
    r.lock();         ①
    try {
      v = m.get(key); ②
    } finally{
      r.unlock();     ③
    }
    //缓存中存在，返回
    if(v != null) {   ④
      return v;
    }  
    //缓存中不存在，查询数据库
    w.lock();         ⑤
    try {
      //再次验证
      //其他线程可能已经查询过数据库
      v = m.get(key); ⑥
      if(v == null){  ⑦
        //查询数据库
        v=省略代码无数
        m.put(key, v);
      }
    } finally{
      w.unlock();
    }
    return v; 
  }
}
{% endhighlight %}


写锁的降级
{% highlight java linenos %}

class CachedData {
  Object data;
  volatile boolean cacheValid;
  final ReadWriteLock rwl =
    new ReentrantReadWriteLock();
  // 读锁  
  final Lock r = rwl.readLock();
  //写锁
  final Lock w = rwl.writeLock();
  
  void processCachedData() {
    // 获取读锁
    r.lock();
    if (!cacheValid) {
      // 释放读锁，因为不允许读锁的升级
      r.unlock();
      // 获取写锁
      w.lock();
      try {
        // 再次检查状态  
        if (!cacheValid) {
          data = ...
          cacheValid = true;
        }
        // 释放写锁前，降级为读锁
        // 降级是可以的
        r.lock(); ①
      } finally {
        // 释放写锁
        w.unlock(); 
      }
    }
    // 此处仍然持有读锁
    try {use(data);} 
    finally {r.unlock();}
  }
}
{% endhighlight %}

读写锁的升降级： 写锁可以降级为读锁(本线程在释放写锁之前，不存在其他线程持有读写锁的情况); 读锁不能升级为写锁(因为其他线程可能持有读锁，可能导致阻塞)。


### 2.5 StampedLock: 有没有比读写锁更快的锁

> StampedLock, 写锁(读写锁的写锁一样)，悲观读锁(读写锁的读锁一样)，乐观读(不加锁，仅增加一个版本号，在取完数据后，使用前验证一下版本号，如果不一样就进行悲观读锁获取)

{% highlight java linenos %}

class Point {
  private int x, y;
  final StampedLock sl = 
    new StampedLock();
  //计算到原点的距离  
  int distanceFromOrigin() {
    // 乐观读
    long stamp = 
      sl.tryOptimisticRead();
    // 读入局部变量，
    // 读的过程数据可能被修改
    int curX = x, curY = y;
    //判断执行读操作期间，
    //是否存在写操作，如果存在，
    //则sl.validate返回false
    if (!sl.validate(stamp)){  // <---- a
      // 升级为悲观读锁
      stamp = sl.readLock();
      try {
        curX = x;
        curY = y;
      } finally {
        //释放悲观读锁
        sl.unlockRead(stamp);
      }
    } 
    return Math.sqrt( // <---- b
      curX * curX + curY * curY);
  }
}
{% endhighlight %}

思考题：若a验证成功，在b执行前，数据被修改了，如何处理？

### 2.6 CountDownLatch和CyclicBarrier: 如何让多线程步调一致


{% highlight java linenos %}


{% endhighlight %}


### 2.7 并发容器: 都有哪些坑需要我们填


{% highlight java linenos %}


{% endhighlight %}

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







