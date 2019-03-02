---
layout: post
title: Houjie1：C++ OOP
categories: [00 CPP]
tags: [CPP]
number: [0.1]
fullview: false
shortinfo: 本文是对《C++ OOP》的课程总结。

---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## Part I The Bacisc ##

### CH1 Basic C++ Programming

### CH2 Procedural Programming

> Why use reference? declare a parameter as a reference is to 1) allow us to modify directly the actual object being passed to the function if no modifying one can prefix `const` to the reference and 2)  eliminate the overhead of copying a large object.

> Place the default value in the function declaration rather than in the function definition.

> An inline function represents a request to the compiler to expand the function at each call point. With an inline function, the compiler replaces the function call with a copy of the code to be executed.

> Function overloading is implemented based on functions signature, which in C++ only counts function name and its paratemers, EXCLUDING its return type.

> 函数声明的对齐

{% highlight cpp linenos %}
// NumSeq.h
bool                seq_elem(int pos, int &elem); const vector<int> *fibon_seq(int size);
const vector<int>*  lucas_seq(int size);
const vector<int>*  pell_seq(int size);
const vector<int>*  triang_seq(int size);
const vector<int>*  square_seq(int size);
const vector<int>*  pent_seq(int size);
{% endhighlight %}

> 函数指针定义`const vector<int>* (*seq_ptr)(int)`, `const vector<int>* (*seq_ptr[])(int)`.

### CH3 Generic Programming

> iterator sits between container and algorithm. `vector<string> cs_vec; vector<string>::iterator = cs_vec.begin();`, `iterator` for read and write; `const vector<string> cs_vec; vector<string>::const_iterator = cs_vec.begin();`, `const_iterator` for read-only.

#### CH3.1 Generic container

{% highlight cpp linenos %}
#include <vector>
#include <list>
#include <deque>
{% endhighlight %}

#### CH3.2 Generic algorithm 

{% highlight cpp linenos %}
#include <algorithm>
{% endhighlight %}

#### CH3.3 Functor

{% highlight cpp linenos %}
#include <functional>
binary_search(vec.begin(), vec.end(), elem, greater<int>());
// another example
class MyFunctor
{
   public:
     int operator()(int x) { return x * 2;}
}

MyFunctor doubler;
int x = doubler(5);
{% endhighlight %}

> Functor: the class who override `operator()` 

#### CH3.4 Iterator

### CH4 Object-Based Programming

### CH5 Object-Oriented Programming

### CH6 Programming with Templates

### CH7 Exception Handling

## 6 总结 ##

{% highlight cpp linenos %}
{% endhighlight %}

{: .img_middle_hg}
![Network overview](/assets/images/posts/2014-06-01-C Review/Chapter 14 The Preprocessor.png)


## 5 Reference ##

- [《Essential C++》](https://book.douban.com/subject/1456836/)
- [《C++Primer》](https://book.douban.com/subject/24089577/);
- [《STL源码剖析》](https://book.douban.com/subject/1110934/);
- [《深度探索c++对象模型》](https://book.douban.com/subject/10427315/);



