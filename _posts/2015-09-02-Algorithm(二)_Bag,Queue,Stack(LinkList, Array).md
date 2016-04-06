---
layout: post
title: Algorithm(二)：包，队列，栈（链表，数组） 
categories: [Algorithm]
tags: [Queue, Bag, Stack, LinkedList, Array, Generics, Iterable]
number: [-2.2.2]
fullview: false
shortinfo: 包，队列，栈是基本的数据结构，在计算机科学里有着广泛的应用。本文用链表和数组来实现包，队列和栈。借着这三个数据结构我们还介绍泛型(Generics)和可迭代(Iterable)接口。
---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1. 介绍 ##
包(Bag)，队列(Queue)，栈(Stack) 在计算机科学里作为最重要的三个基本数据结构之一有着广泛的应用。对于他们的实现,有两种方案，分别是基于链表(Linked-List)和数组(Array)。链表和数组对于查找(前者是O(N),后者是O(1))和增删(前者是O(1),后者是O(N))各自有优势。下面我们先介绍链表和数组，再用他们实现包，队列和栈。最后我们引入泛型的概念和可迭代的接口来使得包，队列，栈能够优雅地实现存储各个类型的数据以及快速枚举。

## 2. 链表(Linked-List)，数组(Array) ##
链表便于增删(O(1))，查找效率低(O(N)); 数组便于查找(用下标O(1)),增删效率低(由于固定长度，增加减少元素时要copy到新的Array。最优算法：items = capacity时，capactiy double; items = 1/4 *capacity时,capacity half。时间复杂度是(O(N))。链表和数组的空间复杂度都是O(N)。

{: .img_middle_mid}
![LinkedList&Array](/assets/images/posts/2015-09-02/LinkedList.png)

## 3. 包(Bag)，队列(Queue)，栈(Stack) ##

### 3.1 包 ###
包是无序的，需要的API如下：
{% highlight java linenos %}
class BagOfStrings

Bag()                       //create an empty bag
void add(Item x)            //insert a new item onto bag
int size()                  //number of items in bag
{% endhighlight %}

### 3.2 队列###
队列是FIFO(先进先出)。
{% highlight java linenos %}
class QueueOfStrings

QueueOfStrings()            //create an empty queue
void enqueue(String item)   //insert a new string onto queue
String dequeue()            //remove and return the string least recently added
boolean isEmpty()           //is the queue empty?
int size()                  //number of strings on the queue

{% endhighlight %}

### 3.3 栈 ###
队列是LIFO(后进先出)。
{% highlight java linenos %}
class StackOfStrings

StackOfStrings()            //create an empty stack
void push(String item)      //insert a new string onto stack
String pop()                //remove and return the string
most recently added
boolean isEmpty()           //is the stack empty?
int size()                  //number of strings on the stack

{% endhighlight %}

## 4 泛型(Generic) ##
如果我们存储的不只是String，还有Integer，Double,或者我们自己的Object在包，队列，或者栈里。我们如果再实现那些类型的包，队列，栈，就有大量重复的代码。泛型优雅地解决了这个问题，将类型参数化。

{% highlight java linenos %}
public class FixedCapacityStack<Item>
{
 private Item[] s;
 private int N = 0;

 public FixedCapacityStack(int capacity)
 { s = (Item[]) new Object[capacity]; }

 public boolean isEmpty()
 { return N == 0; }

 public void push(Item item)
 { s[N++] = item; }

 public Item pop()
 { return s[--N]; }
}
{% endhighlight %}


## 5 可迭代(Iterable) ##

Iterable是Iterator(实现了hasNext和next方法)的工厂方法，实现了Iterable就能用foreach快速遍历。

Iterable：

{% highlight java linenos %}
public interface Iterable<Item>
{
 Iterator<Item> iterator();
}
{% endhighlight %}


Iterator：

{% highlight java linenos %}
public interface Iterator<Item>
{
 boolean hasNext();
 Item next();
 void remove();
}
{% endhighlight %}

Foreach 快速遍历：

{% highlight java linenos %}
for (String s : stack)
 StdOut.println(s);
{% endhighlight %}

## 6 总结 ##
包，队列，栈可以用链表和数组实现。泛型可以用于类型参数化。可迭代可以实现快速枚举。

## 7 参考资料 ##
- [Algorithm](http://algs4.cs.princeton.edu/home/);
- [Visualize Algorithm](http://visualgo.net/);





