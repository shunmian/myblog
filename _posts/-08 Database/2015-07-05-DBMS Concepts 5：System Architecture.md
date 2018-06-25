---
layout: post
title: DBMS Concepts 5：System Architecture(Client-Server, Parallel, Distributed)
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

## 1 ##

### 1.1 Relational Databases

### 1.1.1  Relational Data Model ###

### 1.1.2 Relational Algebra ###

### 1.1.3 Advanced SQL ###

window function `ROW_NUMBER`, `RANK`, `OVER`, `PARTITION BY`

you should always strive to compute your answer as a single SQL statement

### 1.1.4 Functional Dependencies ###

How do we design a "good" database schema(logic level)? integrity, reduce redundancy are two key matrics.

What is `Super Key`? Why we need care about `Super Key`? They help us determine whether it is okay to decom[ose a table into multiple sub-tables. They ensure that we are able to recreate the original relation through joins.

`Candidate Key`

`Primary Key`


### 1.1.5 Normal Forms ###

1NF: all types must be atomic and no repreating groups.

2NF: 1NF and non-key attributes fully depend on the candidate key

3NF

BCNF

4&5NF

6NF

### 1.2 Storage

Query Planning
Operator Execution
Access Methods
Buffer Pool Manager
Disk Manager

### 1.2.1 Database Storage ###

Allow the DBMS to manage databases that exceed the amount of memory available. Reading/Writing to disk is expensive, so it must be managed carefully.

DBMS always wants to control things itself instead of relying on OS: specialized prefetching, buffer replacement policy, thread/process scheduling, flushing data to disk.

How DBMS represents the database in files on disk? (Persistency, or spatial: File storage, page layout, Tuple layout, Storage Models.


### 1.2.2 Buffer Pools ###

N-ary storage advantage(fast insert, update and delete, good for queries that need the entire tuple) vs disadvantages(not good for scanning large portions of the table and/or a subset of the attributes).

Deomposition storage model



How DBMS manages its memory and move data back-and-forth from disk? (VM, or temporal,  buffer pools)

tools to coordinate with OS on this problem

1. madvise， tell OS how you expect to read certain pages

2. mlock, tell the os that memory ranges cannot be paged out

3. msync, tell the OS to flush memory ranges out to disk

Locks vs Latches

### 1.2.3 Hash Tables ###

Access Methods

### 1.2.4 Order Preserving Trees ###

Access Methods

### 1.2.5 Query Processing ###

### 1.11 Sorting & Joins ###

### 1.12 Hash Joins & Aggregation ###

### 1.13 Query Optimization ###

### 1.14 Parallel Execution ###

### 1.15 Embedded Database Logic ###

### 1.16 Concurrency Control Theory ###

### 1.17 Two-Phase Locking ###

### 1.18 Index Concurrency Control ###

### 1.19 Timestamp Ordering Concurrency Controll ###

### 1.20 Multi-Version Concurrency Control ###

### 1.21 Logging Schemes ###

### 1.22 Database Recovery ###

### 1.23 Distributed OLTP Systems ###

### 1.24 Barry Morris ###

### 1.3 Execution

### 1.4 Concurrency Control

### 1.5 Recovery

### 1.6 Distributed Databases



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
- [《Database System Concepts》](https://www.amazon.com/Database-Concepts-Abraham-Silberschatz-Professor/dp/0073523321);
- [《Database Systems: The Complete Book》](https://www.amazon.com/Database-Systems-Complete-Book-2nd/dp/0131873253);
- [《Database Management System》](https://www.amazon.com/Database-Management-Systems-Raghu-Ramakrishnan/dp/0072465638);





