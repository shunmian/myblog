---
layout: post
title: Spring Framework
categories: [03 Java]
tags: [Java, Spring]
number: [3.11]
fullview: false
shortinfo: 本文是对Spring Framework的总结。
---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1 Spring Framework Summary ##

{: .img_middle_hg}
![Spring Summary.png]({{site.url}}/assets/images/posts/03 Java/2016-11-11-Spring Framework/Spring Summary.png)

## 2 Spring Boot

### Q0 What is Spring Boot

简化Spring项目的初始搭建和开发过程。

### Q1 How to Start a Spring Project via Spring Boot

下载[Spring Boot Suit](https://spring.io/tools), `File`->`New`->`Spring Starter Project`->选择Services->开始。


### Q2 How to Use JPA

JPA(Java Persistence API)是Sun官方提出的Java持久化规范。它为Java开发人员提供了一种对象/关联映射工具来管理Java应用中的关系数据。他的出现主要是为了简化现有的持久化开发工作和整合ORM技术，结束现在Hibernate，TopLink，JDO等ORM框架各自为营的局面。

Spring Boot Suit里选择`SQL`->`JPA`就可以直接使用。JPA使得Project只到ORM层, ORM层到DB层由JPA来自动管理。

### Q3 How to Build and Deploy

{% highlight java linenos %}

cd /{project}
mvn install clean
java -jar target/{build-file-name}

{% endhighlight %}


## 2 参考资料 ##
- [Spring 揭秘](https://book.douban.com/subject/3897837/);
