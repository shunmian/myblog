---
layout: post
title: Effective C++
categories: [00 CPP]
tags: [CPP]
number: [0.1]
fullview: false
shortinfo: 本文是对《Effective C++》的书的总结。

---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1. 书内容

### 1.1 让自己习惯C++ ##

#### Item 01: 视C++为一个语言联邦

#### Item 02: 尽量以`const`, `enum`, `inline`替换`#define`

#### Item 03: 尽可能使用`const`

#### Item 04: 确定对象呗使用前已先被初始化

### 1.2 构造/析构/赋值运算

#### Item 05: 了解C++默默编写并调用哪些函数

#### Item 06: 若不想使用编译器自动生成的函数，就该明确拒绝

#### Item 07: 为多态基类声明`virtual`析构函数

#### Item 08: 别让异常逃离析构函数

#### Item 09: 绝不在构造和析构过程中调用`virtual`函数

#### Item 10: 令`operator=`返回一个`reference to *this`

#### Item 11: 令`operator=`处理"自我赋值"

#### Item 12: 复制对象时勿忘其每一个成分

### 1.3 资源管理

#### Item 13: 以对象管理资源

#### Item 14: 在资源管理类中小心`copying`行为

#### Item 15: 在资源管理类中提供对原始资源的访问

#### Item 16: 成对使用`new`和`delete`时要采取相同形式

#### Item 17: 以独立语句将`new`ed对象置入智能指针

### 1.4 设计与声明

#### Item 18: 让接口容易被正确使用，不易被误用

#### Item 19: 设计`class`犹如设计`type`

#### Item 20: 宁以`pass-by-reference-to-const`替换`pass-by-value`

#### Item 21: 必须返回对象时，别妄想返回其reference

#### Item 22: 将成员变量声明为`private`

#### Item 23: 宁以`non-member`、`non-friend`替换`member`函数

#### Item 24: 若所有参数皆需类型转换，请为此采用`non-member`函数

#### Item 25: 考虑写出一个不抛异常的`swap`函数


### 1.5 实现

#### Item 26: 尽可能延后变量定义式的出现时间

#### Item 27: 尽量少做转型动作

#### Item 28: 避免返回`handles`指向对象内部成分

#### Item 29: 为"异常安全"而努力是值得的

#### Item 30: 透彻了解`inline`的里里外外

#### Item 31: 将文件间的编译依存关系降至最低

### 1.6 继承与面向对象设计

#### Item 32: 确定你的`public`继承塑模出`is-a`关系

#### Item 33: 避免遮掩继承而来的名称

#### Item 34: 区分接口继承和实现继承

#### Item 35: 考虑`virtual`函数以外的其他选择

#### Item 36: 绝不重新定义继承而来的`non-virtual`函数

#### Item 37: 绝不重新定义继承而来的缺省参数值

#### Item 38: 通过复合塑模出`has-a`或"根据某物实现出"

#### Item 39: 明智而审慎地使用`private`继承

#### Item 40: 明智而审慎地使用多重继承

### 1.7 模板与泛型编程

#### Item 41: 了解隐式接口和编译期多态

#### Item 42: 了解`typename`的双重意义

#### Item 43: 学习处理模板化基类内的名称

#### Item 44: 将与参数无关的代码抽离`templates`

#### Item 45: 运用成员函数模板接受所有兼容类型

#### Item 46: 需要类型转换时请为模板定义非成员函数

#### Item 47: 请使用`traits classes`表现类型信息

#### Item 48: 认识template元编程

### 1.8 定制new和delete

#### Item 49: 了解`new-handler`的行为

#### Item 50: 了解`new`和`delete`的合理替换时机

#### Item 51: 编写`new`和`delete`时需固守常规

#### Item 52: 写了`placement new`也要写`placement delete`

### 1.9 杂项讨论

#### Item 53: 不要轻忽编译器的警告

#### Item 54: 让自己熟悉包括TR1在内的标准程序库

#### Item 55: 让自己熟悉`boost`

## 2. 总结 ##

{% highlight cpp linenos %}
{% endhighlight %}

{: .img_middle_hg}
![Network overview](/assets/images/posts/2014-06-01-C Review/Chapter 14 The Preprocessor.png)


## 3. Reference ##

- [《C++Primer》](https://book.douban.com/subject/24089577/);
- [《Effective C++》](https://book.douban.com/subject/1842426//);



