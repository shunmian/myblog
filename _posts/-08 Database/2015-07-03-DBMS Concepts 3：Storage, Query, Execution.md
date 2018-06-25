---
layout: post
title: DBMS Concepts 3：Storage, Query, Execution
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

### 1.1 Storage ###

#### 1.1.1 Query Parser, Planner, Optimizer ####

SQL is declarative: user tells the DBMS what answer they want, not how to get the answer. There can be a big difference in performance based on plan is used (1.3hour vs 0.45s from last lecture)

#### 1.1.2 Executer (Processing Model)####

A DBMS's processing model defiens how the system executes a query plan

3 approaches:

1. Iterator Model

2. Materialization Model

3. Vectorized / Batch Model

Case study:

1. sorting execution, `SELECT ... ORDER BY`, `SELECT ... GROUP BY`

2. join execution


#### 1.1.3 Access Methods ####

Internal Meta-data, Core Data Storage, Temprory Data Structures(Hash table, buckets); Table Indexes(tree).

##### 1.1.3.1 Hash Table

##### 1.1.3.2 Tree

a table index is a replica of a subset of a table's columns that are organized for efficient access using a subset of those columns. The DBMS ensures that the contents of the table and the index are always in syncs.

B+tree(a self balance tree allow 增删改查 O(log n), B-tree, B-link-tree, B*tree
Skip List, 
Radix Tree, 
Extra Index Stuff




#### 1.1.4 Buffer Pool Manager ####

#### 1.1.5 Disk Manager ####

### 1.2 Execution ###










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





