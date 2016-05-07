---
layout: post
title: Functional Programming in Scala(一)：λ-演算 Part III：抽象数据 
categories: [Functional Programming]
tags: [Data Abstraction]
number: [-2.1]
fullview: false
shortinfo: 在前两篇文章中，我们在λ-Calculus的定义下，了解了Primitive Procedure(”+,-,*,/, <, >,||, &&, if else“) 以及在此基础上组合出来的Compound Procedure，即函数(包括一阶和高阶)。Compound Procedure提升了Procedure的抽象级别，增加了编程的模块化，扩展了函数式语言的表达能力。而同时，从Data的角度来看，我们之前所使用的数据都是Primitive Data(int，float，boolean等），能否将Primitive Data抽象成Compound Data(即用c语言里的结构体来理解，只有数据，没有函数)，从而从数据角度提高函数式语言的表达能力呢？
---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1. Abstraction With Data ##

在前两篇文章中，我们在**λ-Calculus**的定义下，了解了**Primitive Procedure**(+,-,*,/, <, >. 
||, &&, if else)以及在此基础上组合出来的**Compound Procedure**，即**函数**(包括一阶和高阶)。**Compound Procedure**提升了**Procedure**的抽象级别，增加了编程的模块化，扩展了函数式语言的表达能力。而同时，从**Data**的角度来看，我们之前所使用的数据都是**Primitive Data**(int，float，boolean等），能否将**Primitive Data**抽象成**Compound Data**(即用c语言里的结构体来理解，只有数据，没有函数)，从而从数据角度提高函数式语言的表达能力呢？


>**Procedure Abstraction**： separate the way the procedure would be **used** from the details of how the procedure would be **implemented** in terms of primitive procedures；<br/>
**Data Abstraction**： separate the way the data would be **used** from the details of how the data would be **implemented** in terms of primitive datas；<br/>
**Constructor**：the interface between **use** and **implementation**。

## 2. Rational例子 ##

接下来我们来看一个Compound Data的具体例子，有理数。

有理数是所有可以被表示成两个整数的商的数。它有一个分子和一个分母。我们还定义了用函数对有理数进行操作，比如求和，求差，求最大值等。需要注意的是这些函数是定义在Rational 类型的外面的，而Rationl里面只有数据(分子和分母)。函数gcd是用来求最大公约数的。

{% highlight scala linenos %}

object Main extends App {

  //the compound data is only composed of data
  class Rational(x:Int,y:Int){  
    require(y !=0,"demoninator must be non-zero")
    val numer = x/gcd(x,y)
    val denomi= y/gcd(x,y)
    private def gcd(a:Int, b:Int):Int = if(b==0) a else gcd(b,a%b)
  }
  
  
  // some compound procedure is defined outside "Rational" data  
  def toString(r: Rational) = r.numer + "/" + r.denomi

  def makeRationl(x: Int) = new Rational(x, 1)
  def neg(r: Rational) = new Rational(-r.numer, r.denomi)

  def add(r1: Rational, r2: Rational): Rational = {
    new Rational(r1.numer * r2.denomi + r1.denomi * r2.numer, r1.denomi * r2.denomi)
  }

  def sub(r1: Rational, r2: Rational): Rational = add(r1, neg(r2))

  def less(r1: Rational, r2: Rational): Boolean = r1.numer * r2.denomi - r1.denomi * r2.numer < 0
  def max(r1: Rational, r2: Rational) = if (less(r1, r2)) r2 else r1
  
  
  //the compound procedure is used to react to the compound data
  val r1:Rational = new Rational(4,5)  
  val r2:Rational = new Rational(3,4)
  //for compound data, the interface between usage and implementation is "new" constructor
  
  
  val r3 = add(r1,r2)
  println(toString(r3))
  
  val r4 = sub(r1,r2)
  println(toString(r4))
    
  val r5 = max(r1,r2)
  println(toString(r5))
}

{% endhighlight %}

这个例子很好的诠释了**Compound Data**，即基础型数据类型组合起来的新的数据类型，c语言里的结构体就是**Compound Data**。


## 3. λ-Calculus总结##

到现在为止，我们都还没有涉及OOP的概念，在non-OOP的前提下，我们实现了如下关于函数和数据类型的概念：

1. **λ-Calculus** can express all the calculation。It contains function and vaiable(data)；
2. **Primitive Procedure**(+,-,*,/, <, >. 
||, &&, if else) can be used to build **Compound Procedure**(Function)。Function in **λ-Calculus** can only take one argument，then how **λ-Calculus** can be claimed to be universal if it cannot present multi-argument function? The answer is of course it can， only by using Currying(nested high order function)；
3. **Primitive Data**(int，float，boolean）can be used to build **Compound Data**；
4. the **Compound Procedure** and **Compound Data** both improve the modularity，conceptual level and expressive ability of **λ-Calculus**.


那么现在的问题是，以上1-4点都是在non-OOP下的实现，如何将**λ-Calculus**(Functional programming)和OOP结合起来呢？**Compound Data**用OOP结合method实现Class是很容易想到呢，那么另外三种该如何实现呢(**Compound Data**，**Primitive Procedure**，**Compound Procedure**)？

合上书本，有一个问题一直萦绕在脑中，目前为止，我们处在一个怎样的编程世界中呢？到底我们现在在哪里？下面这张二维图或许是一个参考答案：

{: .img_middle_mid}
![compound data](/assets/images/posts/2015-10-03/compound data.png)



## 4 参考资料 ##
- [《Structure and Interpretation of Computer Programs》](https://mitpress.mit.edu/sicp/full-text/book/book.html);
- [Martin Odersky: Scala with Style](https://www.youtube.com/watch?v=kkTFx3-duc8);
- [SF Scala: Martin Odersky, Scala -- the Simple Parts](https://www.youtube.com/watch?v=ecekSCX3B4Q);
- [Programming Languages: Lambda Calculus](https://www.youtube.com/watch?v=v1IlyzxP6Sg);
- [Functional Programming For The Rest of Us](http://www.defmacro.org/ramblings/fp.html);



