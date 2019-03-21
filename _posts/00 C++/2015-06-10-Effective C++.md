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

C++ 有4个主要的sub langauge:

- C: 即原始的C语言
- Object-Oriented C++: C++最初被设计的初衷,即C with Classes
- Template C++: generic programming, 又称之为template metaprogramming
- STL: 以template为基础的程序库。

我们要有这种观念，在不同sub langauge之间切换时，其最佳实践也会不同。

因此C++并不是一个带有一组守则的一体语言；它是由4个次语言组成的联邦政府，每个次语言都有自己的规约。记住这4个次语言你就会发现C++容易了解的多。

#### Item 02: 尽量以`const`, `enum`, `inline`替换`#define`

#### Item 03: 尽可能使用`const`

> 对于指针, *左边的const表示指向物不可变，*右边的const表示指针不可变。

{% highlight cpp linenos %}
string s1 = "Hello";
string *p = s1              //non-const pointer, non-const data
const string *p = s1        //non-const pointer, const data
string *const p = s1        //const pointer, non-const data
const string *const p = s1  //const pointer, const data
{% endhighlight %}

> 对于STL的迭代器, const表示指向物不可变，const_iterator表示迭代器本身不可变

{% highlight cpp linenos %}
const std::vector<int>::iterator iter = vec.begin();
*iter = 10; //错误，指向物不可变
++iter;     //正确，迭代器本身可变

std::vector<int>::const_iterator iter = vec.begin();
*iter = 10; //正确，指向物可变
++iter;     //错误，迭代器本身不可变

{% endhighlight %}

> 当`const`和`non-const`成员函数有着实质等价的实现时，令`non-const`版本调用`const`版本可避免代码重复。

{% highlight cpp linenos %}
class TextBlock {
    public:
        const char& operator[](std::size_t position) const
        {

        }
        char & operator[](std::size_t position)
        {
            return const_cast<char&>(
                static_cast<const TextBlock&>(*this)[position];
            )
        }
}

{% endhighlight %}


#### Item 04: 确定对象被使用前已先被初始化

- 构造函数最好使用成员初值列(member initialization list),而不要在构造函数本体内使用赋值操作(assignment)。初值列列出的成员变量，其排列次序应该和它们在class中的声明次序相同。

- 为避免"跨编译单元之初始化次序"问题，请以`local static`对象替换`non-local static`对象。

### 1.2 构造/析构/赋值运算

#### Item 05: 了解C++默默编写并调用哪些函数

- 编译器可以暗自为class创建default构造函数，copy构造函数， copy assignment操作符，以及析构函数。

#### Item 06: 若不想使用编译器自动生成的函数，就该明确拒绝

- 为驳回编译器自动(暗自)提供的技能，可将相应的成员函数声明为`private`并且不予实现。使用像`Uncopyable`这样的`base class`(或者`boost`的`noncopyable`)也是一种做法。

{% highlight cpp linenos %}
#include <iostream>
using namespace std;

class Uncopyable {
    protected:
        Uncopyable() {}
        ~Uncopyable() {}
    private:
        Uncopyable(const Uncopyable&);
        Uncopyable& operator=(const Uncopyable&);
};

class HomeForSale2: private Uncopyable {

};

class HomeForSale {
    public:
    HomeForSale() {
        cout << "Empty default constructor" << endl;
    }

    ~HomeForSale(){
        cout << "Empty destructor" << endl;
    }

    private: 

    HomeForSale(const HomeForSale & rhs);
    
    HomeForSale& operator=(const HomeForSale &rhs);
};

int main(){

    HomeForSale2 h2;
    HomeForSale h3;
    HomeForSale h4(h2);  // forbidden by compiler
    h4 = h3;             // forbidden by compiler
    
    HomeForSale e2;
    HomeForSale e3;
    HomeForSale e4(e2);  // forbidden by compiler
    e4 = e3;             // forbidden by compiler
        
    return 0;
}

{% endhighlight %}

#### Item 07: 为多态基类声明`virtual`析构函数

#### Item 08: 别让异常逃离析构函数

#### Item 09: 绝不在构造和析构过程中调用`virtual`函数

#### Item 10: 令`operator=`返回一个`reference to *this`

- 令赋值(assignment)操作符返回一个`reference to *this`是为了便于链式赋值`x=y=z`(等价于`x=(y=z)`)

#### Item 11: 令`operator=`处理"自我赋值"

#### Item 12: 复制对象时勿忘其每一个成分

- `Copying`函数应该确保复制"对象内的所有成员变量"及"所有`base class成分`"。
- 不要尝试以某个`copying`函数实现另一个`copying`函数。应该将共同机能放进第三个函数中，并由两个`copying`函数共同调用。

{% highlight cpp linenos %}
PriorityCustomer::PriorityCustomer (const PriorityCustomer &rhs) : Customer(rhs), priority(rhs.priority) {
}

{% endhighlight %}


### 1.3 资源管理

#### Item 13: 以对象管理资源

#### Item 14: 在资源管理类中小心`copying`行为

- 复制RAII对象必须一并复制它所管理的资源，所以资源的copying行为决定RAII对象的copying行为。
- 普遍而常见的RAII class copying行为是: 抑制copying或施行应用计数法。不过其他行为也都可能被实现。

#### Item 15: 在资源管理类中提供对原始资源的访问

#### Item 16: 成对使用`new`和`delete`时要采取相同形式

- If you use `[]` in a `new` expression, you must use `[]` in the corresponding `delete` expression. If you don't use `[]` in a `new` expression, you must not use `[]` in the corresponding `delete` expression.

#### Item 17: 以独立语句将`new`ed对象置入智能指针

- Store newed objects in smart pointers in standalone statements. Failure to do this can lead to subtle resource leaks when execeptions are thrown.

### 1.4 设计与声明

#### Item 18: 让接口容易被正确使用，不易被误用

#### Item 19: 设计`class`犹如设计`type`

#### Item 20: 宁以`pass-by-reference-to-const`替换`pass-by-value`

- Prefer pass-by-reference-to-const over pass-by-value. It's typically more efficient and it aovids the slicing problem.

- The rule doesn't apply to built-in types and STL iterator and function object types. For them, pass-by-value is usually appropriate. 

#### Item 21: 必须返回对象时，别妄想返回其reference

- never return a pointer or reference to a local stack object.

#### Item 22: 将成员变量声明为`private`

- Declare data memebers `private`.

- `protected` is no more encapsulated than `public`.

#### Item 23: 宁以`non-member`、`non-friend`替换`member`函数

#### Item 24: 若所有参数皆需类型转换，请为此采用`non-member`函数

#### Item 25: 考虑写出一个不抛异常的`swap`函数


### 1.5 实现

#### Item 26: 尽可能延后变量定义式的出现时间

- Postpone variable definitions as long as possible. It increases program clarity and improves program efficiency.

#### Item 27: 尽量少做转型动作

#### Item 28: 避免返回`handles`指向对象内部成分

- Avoid returning handles (references, pointers, or iterators) to object internals. Not returning handles increases encapsulation, hepls `const` member act `const`, and minimizes the creation of dangling handles.

#### Item 29: 为"异常安全"而努力是值得的

#### Item 30: 透彻了解`inline`的里里外外

The idea behind an inline function is to replace **each call** of that function with its code body.
Bear in mind that `inline` is a request to compilers, not a command, which means compiler can ignore. `inline` can be requested either implicit or explicit.

{% highlight cpp linenos %}
// implicit inline
class Person {
    public:
        int age() const {return theAge};    // an implicit inline request
}
    private:
        int theAge;

// explicit inline
template<typename T>
inline const T& std::max(const T &a, const T &b) {  // an explicit inline, requires `inline` key word and put in header file.
    return a < b ? b : a;
}
{% endhighlight %}

- `virtual function` inline will be rejected. `virtual function` means "wait until runtime to figure out which function to call", and `inline` means "before execution, replace the call site with the called function".



#### Item 31: 将文件间的编译依存关系降至最低

### 1.6 继承与面向对象设计

#### Item 32: 确定你的`public`继承塑模出`is-a`关系

- `public inheritance` means `is-a` relationship, anywhere that base class applies (`void f(BaseClass *b)`), also applies to derived class (`void f (DerivedClass *d)`). 记住以上论点只对`public`继承成立，对`private`和`protected`继承并不成立。

#### Item 33: 避免遮掩继承而来的名称

- `derived classes` 内的名称会遮掩 `base classes`内的名称。在public继承下从来没有人希望如此。
- 为了让遮掩的名称再见天日，可使用`using`声明式或转交函数`forwarding functions`。

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
- [《Effective C++》](https://book.douban.com/subject/1842426/);




