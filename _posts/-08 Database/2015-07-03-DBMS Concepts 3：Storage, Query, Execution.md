---
layout: post
title: DBMS Concepts 3：Storage, Indexing, Query (Compiler, Optimizer, Executer)
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

### 1.1 Storage and File Structure ###

{: .img_middle_hg}
![regular expression]({{site.url}}/assets/images/posts/-08 Database/DBMS Concepts/2015-07-03-DBMS Concepts 3：Storage, Query and Exectution/Part 3_CH10 Organization and Records in Files.png)

### 1.2 Indexing ###

{: .img_middle_hg}
![regular expression]({{site.url}}/assets/images/posts/-08 Database/DBMS Concepts/2015-07-03-DBMS Concepts 3：Storage, Query and Exectution/Part 3_CH11 Indexing.png)

### 1.3 Query Compiler (Parser, Logical Query Generator, Physical Query Generator) 

{: .img_middle_hg}
![regular expression]({{site.url}}/assets/images/posts/-08 Database/DBMS Concepts/2015-07-03-DBMS Concepts 3：Storage, Query and Exectution/Part 3_CH13 Query Compiler.png)

### 1.4 Query Executer ###

{: .img_middle_hg}
![regular expression]({{site.url}}/assets/images/posts/-08 Database/DBMS Concepts/2015-07-03-DBMS Concepts 3：Storage, Query and Exectution/Part 3_CH12 Query Execution.png)








{: .img_middle_lg}
![regular expression]({{site.url}}/assets/images/posts/2015-06-01/MySQL overview.png)


## 2 MySQL实战 ## 

{% highlight mysql linenos %}
{% endhighlight %}


## 3 总结 ##

Database,Table,Column,Row的操作逃不出增删改查4种，只不过命令名字和规则略有不同。按照这个原则，我们
对**MySQL的客户端mysql**总结成下表，以供参考。

{: .img_middle_hg}
![regular expression]({{site.url}}/assets/images/posts/2015-06-01/client mysql.jpg)


## 4 参考资料 ##
- [《Database System Concepts》](https://www.amazon.com/Database-Concepts-Abraham-Silberschatz-Professor/dp/0073523321);
- [《Database Systems: The Complete Book》](https://www.amazon.com/Database-Systems-Complete-Book-2nd/dp/0131873253);
- [《Database Management System》](https://www.amazon.com/Database-Management-Systems-Raghu-Ramakrishnan/dp/0072465638);





