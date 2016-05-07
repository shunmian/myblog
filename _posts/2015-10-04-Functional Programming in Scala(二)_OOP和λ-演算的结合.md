---
layout: post
title: Functional Programming in Scala(二)：OOP和λ-演算的结合 
categories: [Functional Programming]
tags: [OOP&&FP]
number: [-2.2]
fullview: false
shortinfo: 什么是λ-Calculus，函数式编程的理论基础是什么，什么是高阶函数, 为什么有Currying, 函数式编程为什么需要单参数函数？本文将为您抽丝剥茧，一一梳理。
---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1. OOP ##




{: .img_middle_mid}
![compound data](/assets/images/posts/2015-10-03/compound data.png)



## 2. 万物皆类 ##


### 2.1 Primitive Data is Class ###

如果说让你定义一个布尔基础类**Boolean**，你会怎么做呢？一般的思路先是从布尔类型需要满足的操作着手

1. 实现`if(b1) e1 else e2`，即当b1为true的时候，返回e1，否则返回e2；
2. 实现`b1 && b2`，只有b1和b2同为true时返回true，否则返回false；
3. 实现`b1 || b2`，只有b1和b2同为false时返回false，否则返回true；
4. 实现`!b1`，b1为true返回false，为false返回true。

暂时就想到那么多了。Scala里用一种极其优雅的形式实现了拥有这几种功能的Boolean类型，上代码：

{% highlight scala linenos %}

{% endhighlight %}






### 2.2 Compound Data is Class ###

### 2.3 Primitive Procedure is Class ###

### 2.4 Compound Procedure is Class ###





{% highlight scala linenos %}

{% endhighlight %}




## 4. 多态 ##

## 5. Class Hierachy ##

{: .img_middle_mid}
![Currying](/assets/images/posts/2015-10-02/Currying.png)

## 5 参考资料 ##
- [《Structure and Interpretation of Computer Programs》](https://mitpress.mit.edu/sicp/full-text/book/book.html);
- [Martin Odersky: Scala with Style](https://www.youtube.com/watch?v=kkTFx3-duc8);
- [SF Scala: Martin Odersky, Scala -- the Simple Parts](https://www.youtube.com/watch?v=ecekSCX3B4Q);
- [Programming Languages: Lambda Calculus](https://www.youtube.com/watch?v=v1IlyzxP6Sg);
- [Functional Programming For The Rest of Us](http://www.defmacro.org/ramblings/fp.html);



