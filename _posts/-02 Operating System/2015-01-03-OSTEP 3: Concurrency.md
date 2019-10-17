---
layout: post
title: OSTEP 3：Concurrency
categories: [-02 Operating System]
tags: [Operating System, Unix]
number: [-02.1]
fullview: false
shortinfo: OSTEP Concurrency。

---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1 Concurrency Summary ##

> Concurrency (in a normal (non-OS) program): multiple threads run at the same time within a process; not multiple process run at the same time within the OS;

{: .img_middle_hg}
![VM_Summary]({{site.url}}/assets/images/posts/-02_Operating System/OSTEP/2015-01-03-OSTEP 3_Concurrency/Concurrency_Summary.png)


## 2 The high level logic

The shared data access by multiple threads is the origin of concurrency challenge. The pattern of shared data is can be categorized by read/write and consumer/producer point of view

1. P1: (read+write) * multiple identical threads, `counter++` example; solved by lock(atomicity, testAndSet hardware primitive)
2. P2: (read+write) * multiple unidentical threads (producer + consumer), `buffer produce/consumer`; solved by lock(atomicity,  testAndSet hardware primitiv) and conditional variable(sleep/awake, yield OS primitive support)

What is a semaphore? semaphore = lock + conditional variable, in other words
1. one can implement semaphore based on lock and conditon;
2. one can implement lock and condition based on lock;

## 2 参考资料 ##

- [《Operating Systems: Three Easy Pieces》](http://pages.cs.wisc.edu/~remzi/OSTEP/)



