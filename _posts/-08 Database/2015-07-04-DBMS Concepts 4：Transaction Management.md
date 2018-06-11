---
layout: post
title: DBMS Concepts 4：Transaction Management(Concurrency, Recovery)
categories: [-08 Database]
tags: [Database,MySQL]
number: [-6.1.1]
fullview: false
shortinfo: DBSM实现。

---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1 Transaction Management ##

### 1.1 Concurrency

Process Models (Worker, the DBMS component that is responsible for executing tasks on behalf of the client and returning the results). 3 approaches: process per dbms worker, process pool, thread per dbms worker

Execution Parallelism

I/O Parallelism


Embeded bdatabase logic?


========

we both change the same record in a table at the same time. How to avoid race condition.

a transaction is the execution of a sequence of one or more operations (e.g., SQL queries) on a shared database to perform some higher-level function.

strawman system: 1). Execute each txn one-by-one(serial order); 2) before a txn starts, copy the entire database to a new file and make all changes to that file, if txn completes succeeded, overwrite the original file with the new one; else, just remove the dirty copy.

better approach is to allow concurrent execution of independent transactions.

#### 1.1.1 locking

0. tool(lock vs latch(Mutex, as low level primitive));

1. Lock Types (share lock for read; exclusive lock for write)

2. pessimistic: Two-Phase Locking(Growing, Shrinking);

3. Deadlock Detection + Prevention

4. Hierarchical Locking

#### 1.1.2 timestamp

pessimistic: Two-Phase Locking(Growing, Shrinking); optimistic: Timestamp ordering(use timestamps to determine the serializability order of txns, using system clock, logical counter, or hybrid).

#### 1.1.3 multi-version concurrency

### 1.2 logging + Recovery



### 1.3 Distributed

OLTP(On-line Transaction Processing)
OLAP(On-line Analytical Processing)

nuodb

{: .img_middle_lg}
![regular expression](/assets/images/posts/2015-06-01/MySQL overview.png)


## 2 MySQL实战 ## 

{% highlight mysql linenos %}
{% endhighlight %}


## 3 总结 ##

Database,Table,Column,Row的操作逃不出增删改查4种，只不过命令名字和规则略有不同。按照这个原则，我们
对**MySQL的客户端mysql**总结成下表，以供参考。

{: .img_middle_hg}
![regular expression](/assets/images/posts/2015-06-01/client mysql.jpg)


## 4 参考资料 ##
- [《MySQL in One Tutorial》](https://www.youtube.com/watch?v=yPu6qV5byu4);
- [《MySQL Cookbook》](https://www.amazon.com/MySQL-Cookbook-Paul-DuBois/dp/059652708X/ref=sr_1_2?ie=UTF8&qid=1469005314&sr=8-2&keywords=mysql+cookbook);
- [《MySQL Tutorial》](http://www.tutorialspoint.com/mysql/);





