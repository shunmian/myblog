---
layout: post
title: Relational Database Index Design and the Optimizers
categories: [-08 Database]
tags: [Database,MySQL]
number: [-6.1.1]
fullview: false
shortinfo: 《Relational Database Index Design and the Optimizers》笔记。

---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1 Introduction ##

This book explains topics such as

1. how to calculate the costs and benefits of indexes;
2. how to estimate query speed;
3. how to estimate query speed;
4. how to determine whether indexes will be more expensive to maintain than the benefit they provide.
4. introduce a three-start system for grading how suitable an index is for a query. The index will earn a one start if
    - it places relevant rows adjacent to each other
    - its rows are sorted in order the query needs
    - it contains all the columns needed for the query

### CH1 MySQL Architecture and History

## 2 Building a Solid Foundation

### CH2 Benchmarking MySQL

## 3 总结 ##



{: .img_middle_hg}
![regular expression]({{site.url}}/assets/images/posts/2015-06-01/client mysql.jpg)


## 4 参考资料 ##
- [《High Performance MySQL》](https://book.douban.com/subject/10443458/);





