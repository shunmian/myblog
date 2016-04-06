---
layout: post
title: Algorithm(一)： 时间空间复杂度
categories: [Algorithm]
tags: [Order-Of-Growth, Memory]
number: [-2.2.1]
fullview: false
shortinfo: code = algorithm + data Strcuture。这是一个系列的数据结构和算法的博客，学习资料来自于 Princeton的教授Kevin Wayne, Robert Sedgewick的Algorithmn PartI & Part II 课程(Youtube上有视频)。算法和数据结构的最终目的是以最少的时间和空间来解决问题。因此时间上我们用时间复杂度表示，空间上我们用空间复杂度表示。本文简单介绍这两种复杂度，作为算法和数据结构的性能的比较标准。
---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1. 算法和数据结构的两把尺子 ##
算法和数据结构的最终目的是以最少的时间和空间来解决问题。标定这两者的分别是时间复杂度和空间复杂度。

## 2. 时间复杂度 ##
我们以大O表示法表示上确界，即不会超过该复杂度乘以常数。时间复杂度分为以下几类函数: O(1), O(logN), O(N), O(NlogN), O(N<sup>2</sup>),O(N<sup>3</sup>), O(2<sup>N</sup>)。前四种表示优秀的算法，即计算量随N呈线性或以下关系。

{: .img_middle_mid}
![time complexity](/assets/images/posts/2015-09-01/time complexity.png)
![time complexity](/assets/images/posts/2015-09-01/time complexity graph.png)

## 3. 空间复杂度 ##

空间复杂度比时间复杂度要简单。对于java来说，几种元类型的数据大小如下图所示。要注意的是Object有16 bytes的overhead用于存储Object的信息; 指针大小为8 bytes; padding是确保每一个Object的大小都是8的倍数; 如果有内部类，则有额外的reference 8 byte指向所在的类。

{: .img_middle_mid}
![space complexity](/assets/images/posts/2015-09-01/memory0.png)

{: .img_middle_mid}
![space complexity](/assets/images/posts/2015-09-01/memory1.png)
![space complexity](/assets/images/posts/2015-09-01/memory2.png)



## 4 总结 ##
我们简单介绍了时间复杂度和空间复杂度的概念。我们将用他们来衡量之后算法和数据结构的性能。

## 5 参考资料 ##
- [Algorithm](http://algs4.cs.princeton.edu/home/);
- [Visualize Algorithm](http://visualgo.net/);





