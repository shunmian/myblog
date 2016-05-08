---
layout: post
title: FP in Scala(二)：OOP和λ-演算的结合 Part II：List
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

如果说让你定义一个布尔基础类**Boolean**，你会怎么做呢？Scala里的实现如下，先上代码：

{% highlight scala linenos %}
package week4

object Main{
   
 abstract class Boolean{
   
    def ifThenElse[T](e1: => T, e2: => T): T
    
    def && (b2: => Boolean): Boolean = ifThenElse(b2,False)
    def || (b2: => Boolean): Boolean = ifThenElse(True,b2)
    def unary_! : Boolean            = ifThenElse(False,True)
    
    def == (b2: Boolean): Boolean = ifThenElse(b2, b2.unary_!)
    def != (b2: Boolean): Boolean = ifThenElse(b2.unary_!, b2)
  }
  
  object True extends Boolean{
    def ifThenElse[T](e1: => T, e2: => T): T = e1
  }
  
  object False extends Boolean{
    def ifThenElse[T](e1: => T, e2: => T): T = e2
  }
  
   def main(args: Array[String]) {
     
    def p(b:Boolean) = b.ifThenElse(println("True"),println("False")) 
     
    p(True)               //True
    p(False)              //False
    
    p(True && False)      //False
    p(True && True)       //True
    p(False && True)      //False
    p(False && False)     //False
    
    p(True || False)      //True
    p(True || True)       //True
    p(False || True)      //True
    p(False || False)     //False
    
    p(!True)              //False
    p(!False)             //True

    p(True == False)      //False
    p(True == True)       //True
    p(False == False)     //True
    p(False == True)      //Flase
    
    p(True != False)      //True
    p(True != True)       //False
    p(False != False)     //False
    p(False != True)      //True
  }
}
{% endhighlight %}

课程里只是给了如上一个完成了的Boolean的实现，令人感叹于它的优雅。可是如果是让你重头开始自己设计Boolean，怎样才能获得这样的结果呢？对于编程学习者，我们渴求的不是Boolean的实现，而是Boolean实现的思路；正如物理学家渴求的不是相对论，而是发现相对论的那个头脑。我们来试着思考下：

1. 首先，`Boolean`有两个子类`True`和`False`，这是毋庸置疑的；
2. 这两个子类实现的最基本的功能应该就是单元操作，而不是多元操作；
3. 那么我们先看看单元操作，有取反`!`，和条件判断 `if (b:Boolean) e1 else e2`；
4. 我们暂且将这个函数定义为`def ifThenElse[T](e1: => T, e2: => T): T`，即假定Scala已经自动实现了上述将`if (b:Boolean) e1 else e2`转换成`b.ifThenElse(e1,e2)`；
5. 那么两个子类`True`和`False`对该函数的实现分别为返回`e1`和`e2`也就理所应当了；
6. 在这个基础上，我们尝试用`ifThenElse[T](e1: => T, e2: => T): T`实现取反的单元操作和其他二元操作，结果证明是可行的。

我觉得上述思路应该是一个正常的思路，如果一开始就尝试用一个general的公式取实现Boolean所有的单元和多元操作，比较困难。我们留一个小问题，请同学自己实现Boolean的 **< method**.


最后Boolean的实现用以下这张图表示。

{: .img_middle_mid}
![Boolean](/assets/images/posts/2015-10-04/Boolean.png)



### 2.2 Compound Data is Class ###

这个同学们应该都很熟悉了，就是最常见的类的对data和function的封装(当function被封装在类里，我们称之为method，具体区别见[2.4]({{ site.baseurl}}/functional%20programming/2015/10/04/Functional-Programming-in-Scala(二)_OOP和λ-演算的结合.html#compound-procedure-is-class)。我们重新改写[λ-演算 Part III：抽象数据]({{ site.baseurl}}/functional%20programming/2015/10/03/Functional-Programming-in-Scala(一)_λ-演算-Part-III-抽象数据.html)的有理数的例子，将**Compound Data**改写成**类**，只需将函数封装到数据里面即可。

{% highlight scala linenos %}
object Main {

  class Rational(x: Int, y: Int) {
    require(y != 0, "demoninator must be non-zero")
    val numer = x / gcd(x, y)
    val denomi = y / gcd(x, y)
    private def gcd(a: Int, b: Int): Int = if (b == 0) a else gcd(b, a % b)

    // compared to the previous compound data example, here function are defined inside Rational
    override def toString() = this.numer + "/" + this.denomi

    def makeRationl(x: Int) = new Rational(x, 1)
    def neg(r: Rational) = new Rational(-r.numer, r.denomi)

    def add(r2: Rational): Rational = {
      new Rational(this.numer * r2.denomi + this.denomi * r2.numer, this.denomi * r2.denomi)
    }

    def sub(r2: Rational): Rational = add(neg(r2))

    def less(r2: Rational): Boolean = this.numer * r2.denomi - this.denomi * r2.numer < 0
    def max(r2: Rational) = if (this.less(r2)) r2 else this

  }

  def main(args: Array[String]) {

    val r1: Rational = new Rational(4, 5)
    val r2: Rational = new Rational(3, 4)
    
    val r3 = r1.add(r2)
    println(r3)

    val r4 = r1.sub(r2)
    println(r4)

    val r5 = r1.max(r2)
    println(r5)
  }
}
{% endhighlight %}

### 2.3 Primitive Procedure is Class ###

那么如何将诸如+,-,*,\的**Primitive Procedure**表示成类呢，其实我们在[2.1]({{ site.baseurl}}/functional%20programming/2015/10/04/Functional-Programming-in-Scala(二)_OOP和λ-演算的结合.html#compound-procedure-is-class)已经看到了如何将。。------------------------------------------





### 2.4 Compound Procedure is Class ###

**Compound Procedure**即**函数**，在scala里，函数如何才能使一个类呢？

>**function variable** are **class**，and **function value** are **object**。<br/>
**function value** is from instantiation of function literals(anonymous functions)。

如果一个函数的类型是 `A=>B`，那么在scala里，这会转成`scala.Function1[A,B]`，其中A和B是泛型，1表示输入参数是1个，Function1[A,B]表示1个输入类型A和1个输出类型B的函数类。那么这个类的定义是什么呢？是一个如下的接口，

{% highlight scala linenos %}
trait Function1[A,B]{
  def apply(x:A):B
}

//变量f1是Int=>Int的函数，函数体是(x:Int)=>x*x；这个定义的完整版如下f2(f1,和f2等价)
val f1: Int=>Int = (x:Int)=>x*x

//变量f2，实例化一个Function1[A,B]的子类Function1[Int,Int],其中的apply method的实现就是f1中的函数体。
val f2 = new Function1[Int,Int]{
  def apply(x:Int)=x*x
}

//f1调用
f1(3)			//9

//f1会被转换成
f1.apply(3)		//9


{% endhighlight %}

上面f2实例化一个Function1[A,B]的子类Function1[Int,Int],其中的apply method的实现就是f1中的函数体。

也许有人会问，apply 会再实例化一个函数类吗，如果会，不就陷入死循环了吗？

这里我们要着重讲解两个概念**Function vs Method**。

>A **function** in Scala is a complete object，which **contains methods**， One of these methods is the apply method， which contains the code that implements the body of the function。 A method(an OOP concept) is defined within class and without class, there is no method。

在了解function和method的关系下，有几个method和function相互替代的地方需要注意：

<ol>

<li> method 只能是def，function可以是val(即一个变量指向一个函数object)。</li>
<li> method可以被隐式转换成function，如：

{% highlight scala linenos %}

def m(x:Int) = x*x
val f  = m    			  //error
val f1 = m _  			  //return a new Function1[Int,Int]{def apply(x:Int)=x*x}
val f2 = m(_) 			  //the same as f1
val f3 = new Function1[Int,Int]{	  //f1,f2 are actually converted as f3
  def apply(x:Int)= m(x)
 }

{% endhighlight %}

</li>


<li> function通常比实现同样功能的method占用更多内存，但是function可以有OOP带来的其它好处，比如Scala默认实现了toString()。所以有些时候用function用内存换来的性能是值得的。

{% highlight scala linenos %}

def m(x:Int) = x*x
m.toString()	//error
f1.toString()	//res5: String = &lt;function1>&gt;

{% endhighlight %}

</li>

<li>def evaluates every time it gets called while val evaluates only once。

{% highlight scala linenos %}

def isDivisibleBy(k: Int): Int => Boolean = i => i % k == 0
def isEven1 = isDivisibleBy(2)		
isEven1(2)(5)
isEven1(2)(5)			// isDivisibleBy(k: Int): Int => Boolean is called every time

val isEven2 = isDivisibleBy(2)	
isEven2(2)(5)
isEven2(2)(5)			// isDivisibleBy(k: Int): Int => Boolean is called only once during val isEven2's definition.


{% endhighlight %}

</li>


</ol>



{% highlight scala linenos %}

{% endhighlight %}




## 3. Scala中的类 ##

既然**Scala**中万物皆类，我们来看下类需要特别注意的地方，包括语法和类等级(Class Hierachy)。

### 3.1 类的关键词 ###

Scala里类的语法还有以下关键词。

<ol>

<li><b>this</b>，和Java里的this一样，在类里指自己这个实例。但是Scala里的<b>this</b>还可以是一个构造器。

{% highlight scala linenos %}

class Rational(x: Int, y: Int) {		//这是一个默认构造器
...
  def this(x: Int) = this(x,1) 		//如果只输入一个参数x，那么自动生成分子为x，分母为1的Rational实例
...
}

{% endhighlight %}
</li>

<li><b>require</b>，used to enforce a precondition on the caller of a function。

{% highlight scala linenos %}

class Rational(x: Int, y: Int) {
  require(y != 0, "demoninator must be non-zero")	//用来规定一个precondition，当对Rational构造器调用时。
...
}

{% endhighlight %}
</li>

<li><b>assert</b>，used tp cjeck the code of the function itself。

{% highlight scala linenos %}

class Rational(x: Int, y: Int) {	
...
  assert(y != 0)		//
...
}

{% endhighlight %}

<b>assert</b>和<b>assert</b>的区别在他们各自的定义里基本说清楚了，需要补充的是<b>assert</b>其实更多的是类的implementation的时候的先决条件，而<b>assert</b>更多的是一种对程序当前状态是否已达预期的一种判断。

</li>

<li><b>trait</b>，类似Java里的interface，但是比它强大，因为<b>trait</b>可以有<b>method</b>的具体实现和field(但是不能有value)。<b>Swift的protocal</b>和<b>Scala的trait</b>非常相似。

{% highlight scala linenos %}

trait Movable{	
...
  val speed:Int；			//field cannot have value
  def trace(x:Int) = x*x 	//method can have implementation，can be override
...
}

{% endhighlight %}
</li>
</ol>




### 3.2 多态和泛型 ###

<blockquote><b>Polymorphism(多态)</b>，在OOP中有两种形式存在于类中：
<ol>
<li> 类的<b>subTyping</b>，即当需要一个父类的时候，子类可以代替父类；</li>
<li> 类的<b>generic</b>，即定义类和定义类中的method的时候，input argument type can be parameterized。</li>
</ol>
</blockquote> 


### 3.3 类等级 ###

{: .img_middle_lg}
![scala class hierarchy](/assets/images/posts/2015-10-04/scala class hierarchy.png)

在Scala里，类等级(Class Hierachy)如上图所示：

1. 所有类的祖先是`Any`。`Any`又包括`AnyVal`和`AnyRef`，即分别是**Primitive Data**和**Compound Data**；

2. `AnyRef`里的底部的子类是`Null`，`AnyVal`里的底部的子类是`Nothing`。同时`Nothing`又是`Null`的子类。

3. 关于`AnyRef`里的`Iterable`，`Seq`，`List`等接口我们暂且不表。


### 3.4 运行时和dynamic method dispatch ###

这里暂且不表，具体请先参见[Objective-C的runtime系列]({{ site.baseurl}}/objective-c/2016/03/14/OC-Runtime(一)_Sending-Message.html)。


## 4. pattern match ##




{: .img_middle_mid}
![Currying](/assets/images/posts/2015-10-02/Currying.png)

## 5 参考资料 ##
- [《Structure and Interpretation of Computer Programs》](https://mitpress.mit.edu/sicp/full-text/book/book.html);
- [Martin Odersky: Scala with Style](https://www.youtube.com/watch?v=kkTFx3-duc8);
- [SF Scala: Martin Odersky, Scala -- the Simple Parts](https://www.youtube.com/watch?v=ecekSCX3B4Q);
- [Programming Languages: Lambda Calculus](https://www.youtube.com/watch?v=v1IlyzxP6Sg);
- [Functional Programming For The Rest of Us](http://www.defmacro.org/ramblings/fp.html);



