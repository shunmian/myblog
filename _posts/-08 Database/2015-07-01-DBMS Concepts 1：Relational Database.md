---
layout: post
title: DBMS Concepts 1：Relational Database
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

## 1 Relational Databases ##

**What is relationship in relational database**: a row in a table represents a relationship among a set of values.

**Analogy between database and programming language**: database schema(class definition), database instance(class variable).

**Super Key vs Primary Key vs Candidate Key**.

**Relational Operation**: The input and output of relational operation are both a single relation, this is the foundation for composition of relational operation. 

{% highlight mysql linenos %}
SELECT *
FROM (SELECT *
      FROM Student
      WHERE age < 10
      )
WHERE gender = 'FEMALE'
{% endhighlight %}



### 1.1 SQL ###

#### 1.1.1 Basic

**What does `From R1, R2` actually mean**:  The `From R1, R2` forms a cartesian product with r1 * r2's combination. It's like two for loop that generates all possible combination. The next question is that how to do it efficiently with nested for loops.

{: .img_middle_hg}
![regular expression]({{site.url}}/assets/images/posts/-08 Database/DBMS Concepts/2015-07-01-DBMS Concepts 1：Relational Database/DBCB_CH6 SQL_Summary.png)

#### 1.1.2 Intermediate

##### 1.1.2.1 Views

{: .img_middle_hg}
![regular expression]({{site.url}}/assets/images/posts/-08 Database/DBMS Concepts/2015-07-01-DBMS Concepts 1：Relational Database/DBCB_CH8_2 Views.png)

##### 1.1.2.2 Transactions 

{: .img_middle_hg}
![regular expression]({{site.url}}/assets/images/posts/-08 Database/DBMS Concepts/2015-07-01-DBMS Concepts 1：Relational Database/DBCB_CH8 Transactions.png)

##### 1.1.2.3 Authorization

{: .img_middle_hg}
![regular expression]({{site.url}}/assets/images/posts/-08 Database/DBMS Concepts/2015-07-01-DBMS Concepts 1：Relational Database/DBCB_CH10 Authorization.png)

#### 1.1.3 Advanced

##### 1.1.3.1 Contraints and Triggers

**What is a Trigger**: A trigger is a statement that the system executes automaticlaly as a side effect of a modification to the database when a event occurs. In a word, a trigger is an event listener in database.

{: .img_middle_hg}
![regular expression]({{site.url}}/assets/images/posts/-08 Database/DBMS Concepts/2015-07-01-DBMS Concepts 1：Relational Database/DBCB_CH7 Contraints and Triggers.png)

##### 1.1.3.2 Recursion

{: .img_middle_hg}
![regular expression]({{site.url}}/assets/images/posts/-08 Database/DBMS Concepts/2015-07-01-DBMS Concepts 1：Relational Database/DBCB_CH6_2 SQL.png)

##### 1.1.3.3 Functions


{% highlight mysql linenos %}
CREATE FUNCTION dept_count(dept_name VARCHAR(20))
  RETURN INTEGER
  BEGIN
  DECLARE d_count INTEGER:
    SELECT COUNT(*) INTO d_count
    FROM instructor
    WHERE instructor.dept_name = dept_name
  RETURN d_count
  END

SELECT dept_name, budge
FROM instructor
WHERE dept_count(dept_name) > 12
{% endhighlight %}

##### 1.1.3.4 On-Line Analytical Processing (OLAP)

**What is OLAP**: provide the function to view different summaries of multidimensional data.

{: .img_middle_hg}
![regular expression]({{site.url}}/assets/images/posts/-08 Database/DBMS Concepts/2015-07-01-DBMS Concepts 1：Relational Database/DBCB_CH20 OLAP.png)

##### 1.1.3.5 Index

{: .img_middle_hg}
![regular expression]({{site.url}}/assets/images/posts/-08 Database/DBMS Concepts/2015-07-01-DBMS Concepts 1：Relational Database/DBCB_CH6 Index.png)



### A1 Programming Language for XML

### A2 NoSQL Systems

{: .img_middle_hg}
![regular expression]({{site.url}}/assets/images/posts/-08 Database/DBMS Concepts/2015-07-01-DBMS Concepts 1：Relational Database/DBCB_A2 NoSQL.png)

#### A0 course Notes

1. Cloud Programmer, Data scientist, Data engineer, Machine Learning Architect

## 4 参考资料 ##
- [《Database System Concepts》](https://www.amazon.com/Database-Concepts-Abraham-Silberschatz-Professor/dp/0073523321);
- [《Database Systems: The Complete Book》](https://www.amazon.com/Database-Systems-Complete-Book-2nd/dp/0131873253);
- [《Database Management System》](https://www.amazon.com/Database-Management-Systems-Raghu-Ramakrishnan/dp/0072465638);





