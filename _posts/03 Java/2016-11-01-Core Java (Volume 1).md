---
layout: post
title: Core Java (Volume 1)
categories: [03 Java]
tags: [Java]
number: [3.1]
fullview: false
shortinfo: 本文是对《Core Java (Volume 1)》的总结。
---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1 Content ##

### Chapter 4: Object and Class

#### 4.0 `javac` and `java` command

In project root directory, run `javac MyClass.java` to compile `Myclass.java` to `Myclass.class` java bytecode, and then `java MyClass` to run  `Myclass.class` on jvm.

#### 4.1 Encapsulation (instance field), Polymorphism (instance method), Inheritance

> **Encapsulation (Information Hiding)**: instance field is the **state** of an instance, which should be only accessed (read write) via instance method. If any instance field is changed from outside without calling the instance method, encapsulation is broken.

{: .img_middle_hg}
![JS React Summary](/assets/images/posts/04 Web/JS/2016-10-03-React入门/JS React Summary.png)

#### 4.2 Relationship between classed

1. Dependence ("uses-a");
2. Aggregation ("has-a");
3. Inheritance ("is-a");

#### 4.7 Packages

1. you can only import `java.time.*` as `java.time` is a single package rather than import `java.*`,which means multiple package. In other words, a package is the largest unit for import.

2. import with `static` key word: `import static java.lang.System.*` allow you to call `out.println()` instead of `System.out.println()`.

3. to export a class in a package, use `package com.mycompany`(the package name) before declaring the class.

#### 4.8 The Class Path

1. `classdir` TBC

#### 4.9 Documentation Comments

1. javadoc

## 2 others

1. Java native method ? 

2. Factory method vs constructor: factory method can have different name while constructor must use the same name as class name; factory method can also return a subclass while constructor can only return that class.



{% highlight js linenos %}

{% endhighlight %}



  ## 2 参考资料 ##
- [React](https://facebook.github.io/react/);
- [Learning React](https://www.amazon.com/Learning-React-Kirupa-Chinnathambi/dp/0134546318);
- [React Higher Order Components in depth](https://medium.com/@franleplant/react-higher-order-components-in-depth-cf9032ee6c3e);
