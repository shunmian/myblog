---
layout: post
title: More Effective C++
categories: [00 CPP]
tags: [CPP]
number: [0.1]
fullview: false
shortinfo: 本文是对《More Effective C++》的书的总结。

---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1. 书内容

### 1.1 基础 ##

#### Item 1: 仔细区别`pointers`和`references`

#### Item 2: 最好使用C++转型操作符

#### Item 3: 绝对不要以多态方式处理数组

#### Item 4: 非必要不要提供`default constructor`

### 1.2 操作符

#### Item 5: 对定制的"类型转换函数"保持警觉

#### Item 6: 区别`increment/decrement`前置和后置形式

#### Item 7: 千万不要重载`&&`,`||`,和`,`操作符

#### Item 8: 了解各种不同意义的`new`和`delete`

### 1.3 异常

#### Item 9: 利用`destructor`避免泄漏资源

#### Item 10: 在`constructor`内组织资源泄漏

#### Item 11: 禁止异常`exception`流出`destructor`之外

#### Item 12: 了解"抛出一个`exception`"与"传递一个参数"或"调用一个虚函数"之间的差异

#### Item 13: 以`by reference`方式捕捉`exception`

#### Item 14: 明智运用`exception specifications`

#### Item 15: 了解异常处理的成本

### 1.4 效率

#### Item 16: 谨记80-20法则

#### Item 17: 考虑使用`lazy evaluation`

#### Item 18: 分期摊还预期的计算成本

#### Item 19: 了解临时对象的来源

#### Item 20: 协助完成"返回值优化(RVO)"

#### Item 21: 利用重载技术避免隐式类型转换

#### Item 22: 考虑以操作符复合形式`op=`取代其独身形式`op`

#### Item 23: 考虑使用其他程序库

#### Item 24: 了解`virtual functions`,`multiple inheritance`,`virtual base class`,`runtime type identification`的成本

### 1.5 技术

#### Item 25: 将`constructor`和`non-member functions`虚化

#### Item 26: 限制某个`class`所能产生的对象数量

#### Item 27: 要求或禁止对象产生于`heap`之中

#### Item 28: 智能指针

#### Item 29: 引用计数

#### Item 30: 替身类，代理类

#### Item 31: 让函数根据一个以上的对象类型来决定如何虚化

### 1.6 杂项讨论

#### Item 32: 在未来时态下发展程序

#### Item 33: 将非尾类设计为抽象类

#### Item 34: 如何在同一个程序中结合C++和C

#### Item 35: 让自己习惯于标准C++语言






## 2. 总结 ##

{% highlight cpp linenos %}
{% endhighlight %}

{: .img_middle_hg}
![Network overview](/assets/images/posts/2014-06-01-C Review/Chapter 14 The Preprocessor.png)


## 3. Reference ##

- [《C++Primer》](https://book.douban.com/subject/24089577/);
- [《Effective C++》](https://book.douban.com/subject/1842426/);
- [《More Effective C++》](https://book.douban.com/subject/1457891/);


