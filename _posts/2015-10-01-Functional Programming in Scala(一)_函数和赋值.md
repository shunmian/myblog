---
layout: post
title: Functional Programming in Scala(一)：函数和赋值
categories: [Functional Programming]
tags: [Function, Evaluation]
number: [-2.1]
fullview: false
shortinfo: 函数式编程(Functional Programming)。
---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1. 什么是函数式编程 ##

{: .img_middle_lg}
![Programming Paradigm](/assets/images/posts/2015-10-01/Programming Paradigm.png)

编程范式的发展有两个正交的方向，一个是从**数据和函数的封装**的角度(Non-OOP to OOP), 另一个是**数据和函数的关系**角度(命令式编程(函数围绕数据)和函数式编程(数据围绕函数))。

命令式编程和函数式编程的区别有如下几点：

1. 从**数据的可变性**角度，命令式编程专注于**逐步更改可变数据**，函数式编程专注于**转换不可变数据**；
2. 从**函数的副作用**角度，命令式编程的Function允许**有副作用**，比如有一个函数`trimFileNames()`，从当前文件夹读入子文件夹，处理它们的名字(去掉空格)，然后存储文件夹名字。在这个过程中，`trimFileNames()`涉及如何获取input data，处理input data 得到result data，最后如何利用result data。函数式编程的Function**不允许有副作用**，它不关心(也不用关心)如何获取input data和如何利用result data，他只要有一个映射，将input data 转成 result data 返回即可。
4. 从**数据和函数的关系**角度，命令式编程是**函数围绕数据**，对数据进行读，改，存；函数式编程是**数据围绕函数**，函数是一等公民。
3. 从**多线程**角度，命令式编程由于数据的可变性，因此不同线程对同一个全局变量的赋值会导致不同的结果**(Non-deterministic = Parallel Programming + Mutable data)**，不同线程之间的纠缠会令编程异常困难，但是同时对于存储空间的要求并不高，因为数据可以共享。函数式编程由于数据的不可变性，因此不同线程对于**不可变数据共享是安全的**，函数式编程是处理多线程的一个有效编程范式。


如何将OOP和命令式编程结合已经是上个世纪50s年代的事情了，到现在21世纪的20s年代，OOP已经发展的非常成熟了，我们现在用的Java，Objective-C，C++，C#都是这一结合的典范。如何将OOP和函数式编程结合却是刚刚崭露头角的编程的研究方向。Scala语言正是基于这一理念发展起来，而现在苹果开发的Swift更是将OOP，命令式编程与函数式编程结合起来（Swift的函数式语法和理念和Scala相似，由于Scala先于Swift存在，因此有理由相信Swift是借鉴于Scala）。

因此如果要扎实地学好Swift，除了从Objective-C入手外，还得熟悉Scala。下面我们来看看Scala的**函数(Function)**和**赋值(Evaluation)**。  

## 2 函数(Function)和赋值(Evaluation) ##

### 2.1 Evaluation ###

> **λ演算(λ-Calculus)**：是一应用于研究**函数定义**、**函数应用**和**递归**的形式系统。它可以被称为最小的通用程序设计语言。它包括一条变换规则（变量替换）和一条函数定义方式，Lambda演算之通用在于，任何一个可计算函数都能用这种形式来表达和求值。因而，它是等价于图灵机的。尽管如此，Lambda演算强调的是变换规则的运用，而非实现它们的具体机器。可以认为这是一种更接近软件而非硬件的方式。Lambda演算对**函数式编程语言有巨大的影响**，比如Lisp语言、ML语言和Haskell语言。

> **值替换模型(Substituion Model)**：由于不依赖外部变量，给定**输入**函数的返回**结果永远不变**，在**λ演算的基础上**，我们可以用值替换的方式（substitution model）化繁为简，轻松得出一段程序的计算结果。

> **赋值(Evaluation)**：函数的值替换动作。

关于值替换模型，我们可以看下面这个例子，`sumOfSquare(3,4)`就是一步步将函数替换成函数的返回值**(不断赋值)**。

+ 赋值的策略有两种：**Call-By-Value(CBV)**，**Call-By-name**；
+ **CBV**先reduce argument，再evaluate Function；**CBN**use unreduced argument to evaluate Function；
+ 在Scala里，默认`x:Int`形式是CBV，如果要CBN，则用`x: =>Int`。
+ 如果一个函数CBV terminates(不会无限循环)，则CBN也terminates。反之不成立，反例请看下图。
+ `def`，定义函数的关键字，是CBN，`val`，定义变量（不可变）的关键字，是CBV。

{: .img_middle_hg}
![evaluation](/assets/images/posts/2015-10-01/evaluation.png)


### 2.2 Conditonals ###

Scala也用if-else来执行条件语句，我们看下面这个例子用牛顿方法计算平方根`sqrt(x: Double):Double`：

1. 给定一个猜测的值`guess`，求`x/guess`；
2. 若`guess`与`x/guess`的差值<某个很小的值，则返回该值；如果大于，则用`(guess + x/guess)/2`代替`guess`继续第一步。

我们来看具体代码：
{% highlight scala linenos %}
  def sqrt(x: Double): Double = {
  
    def abs(x: Double): Double = if (x < 0) -x else x

    def sqrtIter(guess: Double, x: Double): Double =
      if (isGoodEnough(guess, x)) guess
      else sqrtIter(improved(guess, x), x)

    def isGoodEnough(guess: Double, x: Double): Boolean =
      abs(guess * guess - x) < 0.001

    def improved(guess: Double, x: Double): Double =
      (guess + x / guess) / 2

    sqrtIter(1, x)
  }                                       
  
  sqrt(2)                                //> res1: Double = 1.4142156862745097
  sqrt(4)                                //> res2: Double = 2.0000000929222947
  sqrt(1e-6)                             //> res3: Double = 0.031260655525445276|
  sqrt(1e60)
{% endhighlight %}

我们可以看到sqrt(2)和sqrt(4)的值都是正确的，但是当输入x很小(结果不准确)或者很大时(无限循环)该函数运行结果不正确。原因在于`isGoodEnough(guess: Double, x: Double): Boolean`这个函数不应该用绝对值比较，而应该和输入的x做相对比较(因为x很小时，0.001不够小；x很大时，不会记录小数点后3三位，无法收敛导致无限循环)，我们将其改为如下：


{% highlight scala linenos %}
{
...
    def isGoodEnough(guess: Double, x: Double): Boolean =
      abs(guess * guess - x)/x < 0.001
...
}

  sqrt(2)                                //> res1: Double = 1.4142156862745097
  sqrt(4)                                //> res2: Double = 2.000609756097561
  sqrt(1e-6)                             //> res3: Double = 0.0010000001533016628
  sqrt(1e60)                             //> res4: Double = 1.0000788456669446E30

{% endhighlight %}
此时运行结果是正确的。

### 2.3 Function and Blocks###

> **Block**：借用《Pro Multithreading and Memory Management for iOS and OS X》书中，Kazuki Sakamoto 对block的定义“拥有自动变量（可以在block声明的语义环境里捕捉变量的状态）的匿名（使函数体(code)成为和数据(data)一样的一等公民，作为函数调用时输入的实参（argument））函数。”

要理解这一点我们先看看什么是函数。其实函数和变量是一回事，定义的时候有**关键词**，有**名字**，有**类型**，有**字面值(Literal)**。匿名函数(Block)是函数的**字面值**，只不过在写匿名函数的时候需要显式注明输入输出类型，如`(x：Int):Int =>x*x`而不是只写`x*x`;由于变量的字面值可以推断其类型，因此匿名值(应该没有这个叫法吧，这里指字面值)直接写字面值即可，如3表示整型。

{: .img_middle_mid}
![function and variable](/assets/images/posts/2015-10-01/function and variable.png)

由于block可以看到上下文中的变量，因此之前的`sqrt`函数可以在内部定义的函数里取消`x`作为输入参数。

{% highlight scala linenos %}
def sqrt2(x: Double): Double = {

    def abs(x: Double): Double = if (x < 0) -x else x

    def sqrtIter(guess: Double): Double =
      if (isGoodEnough(guess)) guess
      else sqrtIter(improved(guess))

    def isGoodEnough(guess: Double): Boolean =
      abs(guess * guess - x) / x < 0.000001

    def improved(guess: Double): Double =
      (guess + x / guess) / 2

    sqrtIter(1)
  }                                        

  sqrt2(2)                                 //> res5: Double = 1.4142135623746899
  sqrt(4)                                  //> res6: Double = 2.000609756097561
  sqrt(1e-6)                               //> res7: Double = 0.0010000001533016628
  sqrt(1e60)                               //> res8: Double = 1.0000788456669446E30

{% endhighlight %}



### 2.4 Tail Recursion ###

要理解尾递归得先理解递归，那么什么是递归呢？

{: .img_middle_mid}
![recursion0](/assets/images/posts/2015-10-01/recursion0.png)

开个玩笑，递归应该是长这样子的。

{: .img_middle_lg}
![recursion](/assets/images/posts/2015-10-01/recursion.png)

同学们一般对于递归函数感觉是块不好啃的硬骨头。其实递归函数用数学归纳法去理解并不困难。

<blockquote><b>数学归纳法</b>的思想如下，一般地，证明一个与自然数n有关的命题P(n），有如下步骤：

<ul>
<li><b>step1</b> 证明当n取第一个值n<sub>0</sub>时命题成立。n<sub>0</sub>对于一般数列取值为0或1，但也有特殊情况；</li>
<li><b>step2</b> 假设当n=k（k≥n0，k为自然数）时命题成立，证明当n=k+1时命题也成立。</li>
<li><b>综合（1）（2）</b>，对一切自然数n（≥n<sub>0</sub>），命题P(n）都成立。</li>
</ul>

</blockquote>



其实，数学归纳法利用的是递推的原理，形象地可以叫做多米诺原理。因为N+1的成立就可以向前向后递推所有数都成立。
因此我们再回头看上面的尾递归版本的阶乘函数。n==0时，是退出条件。

在理解了递归函数后，我们看看什么是尾递归。



> **尾递归(Tail Recursion)**
：一个函数中所有递归形式的调用都出现在函数的末尾，且递归函数的返回值不属于表达式的一部分时，称为尾递归。


下面举两个栗子：

第一个栗子是求最大公约数gcd(GGreatest common divisor。第二个是求阶乘。

{: .img_middle_lg}
![tail recursion](/assets/images/posts/2015-10-01/tail recursion.png)

由于第n次阶乘的表达式的一部分(这里是 n *)都需要保留在**栈**中，每当进入一个函数调用，栈就会加一层**栈帧**，每当函数返回，栈就会减一层栈帧。由于栈的大小不是无限的，所以，递归调用的次数过多，会导致**栈溢出**。我们应在递归函数中**尽量使用尾递归避免栈溢出**。

那么我们可以改写阶乘函数为尾递归函数吗，答案是肯定的，请看下面代码：
{% highlight scala linenos %}
 def factorial(n:Int):Int = {
    def factLoop(n:Int, acc:Int):Int = {
        if (n==0) acc
        else factLoop(n-1, acc * n)
    }
    factLoop(n,1)
 }                                                //> factorial: (n: Int)Int

 factorial(4)                                     //> res2: Int = 24
{% endhighlight %}

这个新改写的函数每次调用factLoop的时候，返回下一个factLoop的值。

## 3 Assignment ##

{: .img_middle_lg}
![Assignment](/assets/images/posts/2015-10-01/assignment.png)

+ **Pascal triangle**：递归比较简单，退出条件也很明显，分别是`c==0`和`c==r`的时候；
+ **Parenthesis Balance**：用一个`acc：Int`来存储，每遇见一个`{`+1,`}`-1。退出条件是`chars.isEmpty`或者`acc < 0`；
+ **Counting Money**稍微需要仔细思考，退出条件是`Money == 0`，和`Money < 0 || coins.isEmpty`。

具体代码见[这里](http://users.aims.ac.za/~mackay/sorting/sorting.html)。


## 4 总结 ##

本节我们对什么是函数式编程做了一个总结：

1. 函数无副作用；
2. 通过函数转换不可变数据而非改变原有数据来获取新数据；
3. 数据围绕函数而非函数围绕数据，函数也是一等公民。

通过函数和变量的声明与定义的比较，可以看出他们同样拥有**关键词**，**名称**，**类型**，**字面值**，因此有理由在一个更抽象的层面将函数和变量统一对待。对于函数，**类型 + 数据(其实是函数体)**就是**匿名函数**，也就是**Block**。


## 5 参考资料 ##
- [《Structure and Interpretation of Computer Programs》](https://mitpress.mit.edu/sicp/full-text/book/book.html);
- [Martin Odersky: Scala with Style](https://www.youtube.com/watch?v=kkTFx3-duc8);
- [SF Scala: Martin Odersky, Scala -- the Simple Parts](https://www.youtube.com/watch?v=ecekSCX3B4Q);


