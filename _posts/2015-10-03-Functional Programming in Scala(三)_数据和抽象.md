---
layout: post
title: Functional Programming in Scala(三)：数据和抽象
categories: [Functional Programming]
tags: [High Order Function, Curring]
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

## 1. 问题的由来 ##

我们在上一节中提到，其实函数和变量在更高一级的抽象上是一样的，它们的声明和定义都有**关键词**，**名称**，**类型**，**字面值**。那么你或许会问，那什么是区别于函数和数据的本质呢？答案是**有无输入**。如果仔细看下图(函数有输入不是常识么？别急，我们一步一步剖析函数和数据的异同)，你会发现函数有**输入**，这体现在函数的**类型**和**完整字面值(Block)**上。

{: .img_middle_mid}
![function and variable](/assets/images/posts/2015-10-02/function and variable.png)

这一不同可不得了，引出一系列崭新而深刻的问题：

+ **函数**作用在**数据**上可以**输入数据**和**输出数据**，**函数**能否作用在**函数**上？
+ **函数**有**输入**，那么**输入**的**参数个数**之间有没有关系呢？

这就是我们下面要讨论的**高阶函数(函数输入输出与函数有关)**和**柯里化(函数输入个数的关系)**。



## 2. 高阶函数和柯里化 ##

### 2.1 高阶函数 ###

在scala里，函数作为一等公民，享有和其他数据(也是一等公民)一样的待遇，包括作为函数的输入和输出。这样使得函数的输入输出除了可以是数据外，还可以是函数。这就引出一个函数阶级的问题：

>**一阶函数**：输入输出都为数据；<br/>
**高阶函数**：输入输出至少有一个为函数。

我们先从一个简单的求和问题来，下面是两个求和函数，上下界分别是`a`和`b`：

+ sumInts     = &sum;<sub>k=a</sub><sup>b</sup> k；
+ sumCube = &sum;<sub>k=a</sub><sup>b</sup> k<sup>3</sup>；
它们的实现如下：

{% highlight scala linenos %}

def sumInts(a:Int,b:Int):Int = {
  if (a > b) 0
  else a + sumInts(a+1,b)
}                                               
  
sumInts(1,3)                         // 1+2+3 = 6          

def sumCube(a:Int,b:Int):Int = {
  if (a > b) 0
  else a*a*a + sumCube(a+1,b)
}                                          
    
sumCube(1,3)                        // 1*1*1 + 2*2*2 + 3*3*3 = 35

{% endhighlight %}

这两个函数可以看到都是一阶函数。但是这两个函数有共性：都是求和，且上下界都为a和b。不同的是求和的单项不一样。我们能不能把它的共性抽象出来，使得任何满足这种共性的函数不用每次都写递归求和呢？请看下面代码：

{% highlight scala linenos %}

def sum(f:Int=>Int, a:Int,b:Int):Int = {            //高阶函数，输入是一个函数，a，b
    if(a>b) 0 else f(a)+sum(f,a+1,b)
}

def sumInts(a:Int,b:Int) = sum((x:Int) => x, a, b)  //一阶函数，输入两个Int，输出一个Int
                                                  
sumInts(1,3)                                        //6
  
def sumCube(a:Int,b:Int) = sum((x:Int)=>x*x*x,a,b)  //一阶函数，输入两个Int，输出一个Int
                                                  
sumCube(1,3)                                        //35

{% endhighlight %}

这里我们写了一个高阶函数`sum(f:Int=>Int, a:Int,b:Int):Int`，输入是一个函数(Int=>Int)，a，b，输出是Int。相比于上例的`sumCube`和`sumInt`，我们将他们的不同点用函数f抽象出来，剩下的共同点的实现还是一样。因此本例中**一阶函数**`sumInt`和**一阶函数**`sumCube`可以用**高阶函数**`sum`表示，输入分别是block`(x:Int)=>x`和`(x:Int)=>x*x*x`。

这样高阶函数就很好地抽象了低阶函数，使得低阶函数的实现变的简单而不重复。

### 2.2 柯里化 ###

在上面的例子中，我们可以看到高阶函数`sum(f:Int=>Int, a:Int,b:Int):Int`有**三个输入参数**，如何将三个输入函数变成一个输入函数而不影响其实现呢？这个时候，我们不要忘了**函数**的返回也可以是**函数**。我们能否使其输入是f，输出变成`(a:Int,b:Int)=>Int`呢？请看下面代码。

{% highlight scala linenos %}

def sum(f:Int=>Int):(Int,Int)=>Int = {
  def sumF(a:Int,b:Int):Int = {
    if (a>b) 0 else f(a)+sumF(a+1,b)
  }
  sumF
}                                         //sum: (Int => Int)=>(Int, Int) => Int
  
def sumInts = sum((x:Int)=>x)             //sumInts: (Int, Int) => Int
sumInts(1,3)                              //6
sum((x:Int)=>x)(1,3)                      //6
  
def sumCube = sum((x:Int)=> x*x*x)        //sumCube: (Int, Int) => Int
sumCube(1,3)                              //36
sum((x:Int)=> x*x*x)(1,3)                 //36

{% endhighlight %}

由上例可以看出`sum`输入一个函数(类型为(Int=>Int))，返回一个函数(类型为(Int,Int)=>Int)，即输入为单参数，返回的一阶函数输入也是单参数。因此，对于最终的执行有两种形式：

1. `sumCube = sum((x:Int)=> x*x*x)`，用一个函数名`sumCube`获取这个返回函数，然后再调用它`sumCube(1,3)`；
2. 不需要这个中间变量，直接用`sum((x:Int)=> x*x*x)(1,3)`调用。

第二种情况实现了我们上面提到的高阶函数也只需输入1个参数而不影响其最终实现。这样，所有阶级的函数(包括低阶和高阶)都可以完美的统一起来用单参数表示。

>**柯里化**：将**n参数函数**转成**单参数函数**的过程。方法是通过不断转换成一个包含**n个单参数的函数**的嵌套**树形结构**。每一个树形结构的**上层节点**的输入参数对所有**下层节点**的函数**可见**(参数之间先后关系更立体)。

{% highlight scala linenos %}
def sum(f:Int=>Int, a:Int,b:Int):Int = {            //多参数
    if(a>b) 0 else f(a)+sum(f,a+1,b)
}

def sum(f:Int=>Int):(Int,Int)=>Int = {              //单参数
  def sumF(a:Int,b:Int):Int = {
    if (a>b) 0 else f(a)+sumF(a+1,b)
  }
  sumF
} 
//在Scala里，第二种单参数形式可以写成以下形式的语法糖，使单参数调用的形式更直观。
def sum(f:Int=>Int)(a:Int,b:Int): Int = {           //单参数
  if (a>b) 0 else f(a)+sum(f)(a+1,b)
}              

def sumInts = sum((x:Int)=>x)(_,_)                  //中间函数的语法稍微不同，用(_,_)表示第二个单参数没有
sumInts(1,3)                                        //6
sum((x:Int)=>x)(1,3)                                //6

def sumCube = sum((x:Int)=>x*x*x)(_,_)   
sumCube(1,3)                                        //36
sum((x:Int)=> x*x*x)(1,3)                           //36

{% endhighlight %}

### 2.3 λ-Calculus ###

为了深入理解**Currying**的前世今生，不得不提计算机科学家**Haskell Curry**和**λ-Calculus**(我们在上一节已经简单介绍了一下λ演算)。
**Haskell Curry**是**Haskell**，一门纯函数式语言的创造者。在**Haskell**里面，默认的函数都是单参数的，那么就有一个问题：

>**Haskell** only has **single argument function**. How can Haskell implementing **multiple arguments function**? The answer is using **Currying**，which can return a function that can take extra single argument and do it recursively until **n arguments function** are satisfied。

既然Currying是Haskell实现多参数函数的工具，那么我们更深入一步发问，为什么Haskell语言在设计的时候只允许单参数函数？很多教科书把这个问题当作既成事实，却没有告诉你为什么。要回答这个问题，我们得看Haskell背后设计的原理是什么？Haskell语言设计原理建立在**λ-Calculus**之上。再上一步问题便是“那**λ-Calculus**为什么又只允许单参数函数？”。这就问到了**函数式编程**的核心问题了。且听我慢慢道来。

在上个世纪30s年代，正是美国经历大萧条的时期。经济萧条就像病毒一样，扩散到美国每一寸土地，老百姓衣不遮体，食不果腹(万恶的资本主义社会啊)。但是在美国的一个角落里，却有那么一些人免于贫瘠带来的生活上的困扰。他们每天端着一杯咖啡穿梭于宽敞的办公室，和幽静的花园小径，讨论着高深莫测的学术问题。这个角落就是Princeton大学，在这些人中，有四位专注于研究**形式系统(formal system)**的数学家叫做**Alonzo Church**，**Alan Turing**，**John von Neumann**和**Kurt Gödel**。他们的工作的共同之处在于研究**计算(Computation)**：如果我们有一台拥有无限计算能力的电脑，我们能解决什么类型的问题，是否能自动解决这些问题，是否有一些问题是在其能力范围外的？其中有一个问题是：

> 不同设计的机器是否在计算能力上等价?

为了回答这个问题，**Alonzo Church**在与其他人的合作中创造出一套名叫**λ-Calculus**的**形式系统**。**λ-Calculus**的本质是以函数作为输入输出的**函数**为中心的一门**编程语言**（由于那个时候计算机还没发展起来，更准确的说其实不是**编程语言**而是建立在虚拟计算机上的一套**计算规则**）。这句话我们现在来讲就是**λ-Calculus**的本质是**函数(包括一阶和高阶函数)**。

同时**Alan Turing**也在进行着相近的工作，他创造出一套不同的**形式系统**：**图灵机(Turing machine)**(当时应该不叫这个名字吧，会取自己的名字么)。不久后**λ-Calculus**和**Turing machine**被证明在计算能力上是等价的。

>**命令式编程和函数式编程分别基于图灵机和λ-Calculus发展起来**。

因此命令式编程和函数式编程的计算能力是等价的。我们再接着看。那么什么是**λ-Calculus**呢？

>**λ-Calculus**的中心是**&lt;expression&gt;**，它被递归定义如下：<br/>
**&lt;expression&gt;**   := **&lt;name&gt;** | **&lt;Function&gt;** |**&lt;application&gt;**<br/>
  **&lt;function&gt;**   := **λ&lt;name&gt;**.**&lt;expression&gt;**<br/>
**&lt;application&gt;**  := **&lt;expression&gt;****&lt;expression&gt;**


其中**&lt;expression&gt;** 即可以是一个**&lt;name&gt;**，一个**&lt;Function&gt;**，也可以是一个**&lt;application&gt;**。**&lt;name&gt;**是variable(变量)；**&lt;applicaton&gt;**更像是一个**&lt;function&gt;**的调用，即第一个**&lt;expression&gt;**是**&lt;function&gt;**，第二个**&lt;expression&gt;**是**&lt;name&gt;**(变量)。你可以看到λ-Calculus的**&lt;function&gt;**只有一个输入变量**&lt;name&gt;**。


那么以上这套形式系统的定义有什么好处呢。

>λ calculus is universal in the sense that any computable function can be expressed and evaluated using this formalism。

也就是说你只要遵循**λ calculus**的定义，就可以完成所有的计算。好了，现在我们来整理下Currying背后的逻辑:

1. λ calculus可以完成所有的计算，它是建立在函数基础上；
2. λ calculus的重要形式之一是函数只能是单参数；
3. 如何用单参数函数构造多参数函数呢，用Currying，即返回高阶函数。
4. Currying在Scala里有一种语法糖`f(arg1)(arg)...(argn)`，让开发者看起来更直观。

> 这样我们就完成了用Currying这种形式来计算所有函数的逻辑(包括单参数和多参数函数)。

这也就是我们为什么要用Currying。

## 3 Assignment ##

这次的作业是用函数式编程完成数据结构**Set(集合)**。`Type Set: Int=>Boolean`，Set被定义成一个输入Int返回Boolean的函数。若包含输入Int，返回true；反之false。(是不是有点脑洞大开的感觉？)

它有一系列操作：

1. `def singleton(elem:Int):Set`，单例的构造方法，输入一个elem，返回一个Set；
2. `def contains(elem:Int, s:Set):Boolean`；
3. `def union(s:Set,p:Set):Set`；
4. ...
5. `def forall(s:Set,p:Int=>Boolean):Boolean`，是否所有的s中的元素都满足p。
6. `def exist(s:Set,p:Int=>Boolean):Boolean`，是否在s中有元素不满足p。 
7. `def map(s:Set,f:Int=>Int):Set`，输入一个set，返回一个经过f变换后的set。

具体代码见[这里](https://github.com/shunmian/-2_Functional-Programming-in-Scala)。

`map`函数需要遍历s，由于Set的定义，不能直接完成这个操作，因此作业中设定了我们要处理的数字的上下界。
这要借助`exist`函数，而`exist`函数本身又建立在`forall`函数上。这真是有种**虚无生两极，两极生四象，四象生八卦**的感觉，**上帝**创造了**Alonzo Church**，**Alanzo Church**创造了**λ-Calculus**，**λ-Calculus**催生了现在的**函数式编程**，**函数式编程**又用**函数**实现了数据结构**Set**，**Set**中的复杂函数又建立在一个个基础函数上。任何事物都有一个源头，顺着时间的长河回溯，上帝之前又是什么呢？




## 4 总结 ##

本节我们其实围绕的重点是**Currying**：

1. 首先通过一个具体的例子用**高阶函数**推出**Currying**这一工具的形式；
2. 在例子之后，为了更清楚理解**Currying**背后的逻辑。我们进行了一系列的梳理。我们了解了**λ-Calculus**可以推出任何计算形式，它是一个Universal的计算抽象形式的存在；在遵循**λ-Calculus**单参数函数的基础上，如何完成多参数函数呢，答案是用Currying(这也是**λ-Calculus** universal的一个佐证，即可以实现所有输入参数个数的函数)。


最后将Currying总结成一句话和一幅图：多参数(平等关系)函数通过Currying表示成单参数(上下级关系)函数，应用起来更直观方便。

{: .img_middle_mid}
![Currying](/assets/images/posts/2015-10-02/Currying.png)

## 5 参考资料 ##
- [《Structure and Interpretation of Computer Programs》](https://mitpress.mit.edu/sicp/full-text/book/book.html);
- [Martin Odersky: Scala with Style](https://www.youtube.com/watch?v=kkTFx3-duc8);
- [SF Scala: Martin Odersky, Scala -- the Simple Parts](https://www.youtube.com/watch?v=ecekSCX3B4Q);
- [Programming Languages: Lambda Calculus](https://www.youtube.com/watch?v=v1IlyzxP6Sg);
- [Functional Programming For The Rest of Us](http://www.defmacro.org/ramblings/fp.html);



