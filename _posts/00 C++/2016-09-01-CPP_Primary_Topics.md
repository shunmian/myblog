---
layout: post
title: CPP Primary Topics
categories: [00 CPP]
tags: [CPP]
number: [0.1]
fullview: false
shortinfo: 本文是对CPP Test Library： googleTest的总结。

---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1. Topics

### 1.1 Stack Winding & Unwinding

栈缠绕: 函数调用时，函数会依据调用顺序依次入栈 

栈解开: 函数返回时，函数会依据调用顺序，反序出栈；同时会发生在函数异常。栈解开时，局部对象的析构函数会被调用。

### 1.2 RAII

> **RAII (Resource Aquisition Is (in wrapper object) Initilization)**: resource (an object, an file or an lock) has 3 usecases, creation, usage and deletion, which should happend in wrapper object's constructor, other member functions and destructor. The RAII's foundamental mechanism is that stack object's desctructor would be called when that stack frame is returned (either normal return or by middle exception throw). The RAII applied to stack allocated object `Book b1` and also heap allocated object, which is managed by a stack allocated object called `unique_ptr` for `Book b2`. The RAII name might not be that user friendly, other people prefer to call it **SBMM(Scope Bound Memory Management)**. 

{% highlight cpp linenos %}
// Book.h

#ifndef CPPTOPICS_BOOK_H
#define CPPTOPICS_BOOK_H

#include <iostream>

using namespace std;

class Book {
public:
    Book(){
        cout << "Book :" << name_ << " default constructor being called" << endl;
    };
    Book(string name): name_(name){
        cout << "Book :" << name_ << " constructor being called" << endl;
    };
    ~Book(){
        cout << "Book :" << name_ << " destructor being called" << endl;
    }
private:
    string name_;
};

#endif //CPPTOPICS_BOOK_H

//main.cpp

#include "Book.h"
#include <memory>

void allocateRawPtr(){
    try {
        Book b1;
        Book *b2 = new Book("C++ primer") ;
        throw runtime_error("Trouble"); // b1 destructor being called; b2 destructor being called (nothing happened for raw pointer)
    } catch ( const runtime_error & e){
        cout << "error catched" << endl;
    }
}

void allocateUniqPtr(){
    try {
        Book b1;
        unique_ptr<Book> sb(new Book("C++ primer")); // b1 destructor being called; b2 destructor being called (which deletes the acquired resource for unique_ptr pointer)
        throw runtime_error("Trouble");
    } catch ( const runtime_error & e){
        cout << "error catched" << endl;
    }
}

int main(){
    allocateRawPtr();
    /*output:
      Book : default constructor being called
      Book : C++ primer constructor being called
      Book : destructor being called
      error catched
    */

    allocateUniqPtr();
    /*output:
      Book : default constructor being called
      Book : C++ primer constructor being called
      Book : C++ primer destructor being called
      Book : destructor being called
      error catched
    */
}
{% endhighlight %}

Reference:
- [C++ 05 - RAII ( Resource Acquisition Is Initialization)](https://www.youtube.com/watch?v=IRMiB8YoINs)

### 1.3 explicit constructor

{% highlight cpp linenos %}
class  MutexLock {
 public:
  explicit MutexLock(Mutex *mu)
      : mu_(mu)  {
    this->mu_->Lock();
  }
  ~MutexLock() { this->mu_->Unlock(); }
{% endhighlight %}


### 1.4 copy constructor and assignment operator private make it uncopiable


{% highlight cpp linenos %}

{% endhighlight %}



## 2. 总结 ##

1. 用`select`来读取timeout之内的fd的I/O;若比如0.5s之内用户没有按旋转俄罗斯，则下移。


## 3. Reference ##

- [《C++Primer》](https://book.douban.com/subject/24089577/);
- [《Effective C++》](https://book.douban.com/subject/1842426/);
- [《More Effective C++》](https://book.douban.com/subject/1457891/);


