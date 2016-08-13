---
layout: post
title: Machine Learning(三)：分类
categories: [Machine Learning]
tags: [Machine Learning]
number: [-11.1]
fullview: false
shortinfo: M。

---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1 Logistic Regression介绍##

现在我们从**回归**问题转到**分类**问题。别被**Logistic Regression**这个词迷惑了(之所以叫这个名字是由于历史问题，见[这里](http://papers.tinbergen.nl/02119.pdf))，它是**分类**问题，而不是**回归问题**。

## 2 Logistic Regression详解##

不像输出y是一个连续的函数，**Logistic Regression**的输出是离散数据，即$y\in \lbrace 0,1, \cdots, n \rbrace $。

### 2.1 二分类 ###

我们现在首先考虑最简单的情况，即即$y\in \lbrace 0,1 \rbrace $。我们称之为**二分类**问题。

有人会说这好办，我们只要给原来的线性回归的输出map到一个$\lbrace 0,1, \cdots, n \rbrace$值即可，需要做的是找一个map的边界。但是这会过度简化模型导致输出不准确，请看下图例子。

{: .img_middle_lg}
![线性回归map到二分类](/assets/images/posts/2015-05-03/线性回归map到二分类.png)

新加一对**Training Data**就会使得原来的预测函数不准确。

那么该如何确定预测函数的形式呢，请往下接着看。

#### 2.1.1 预测函数 ####

$$
g(z) = \frac 1 {1+ e^{-z}}
$$

其中$g(z)$的图形如下所示，其将任何实数转换成$\lbrace 0,1\rbrace$之间的值。g(z)被称之为双弯曲函数(Sigmoid Function)或者逻辑函数(Logistic Function)。

{: .img_middle_lg}
![logistic function](/assets/images/posts/2015-05-03/logistic function.png)

我们将线性回归的预测函数$h_\theta(x)$代入到$z$：

$$
h_\theta(x) = g(\theta^Tx) = \frac 1 {1+ e^{-\theta^Tx}}
$$

那么该如何解读$h_\theta(x)$的函数呢？如果$h_\theta(x)=0.7=70%$，就意味着有$70%$的概率我们的输出是1，即：

$$
h_\theta(x) = p(y=1 |x;\theta) = 1 -  p(y=0 |x;\theta)
$$

那么我们来看下决定边界(Decision Bouhdary)：

$$
z = 0
$$

$$
h_\theta(x) ≥ 0 ⇒ y= 1
$$

$$
h_\theta(x) < 0 ⇒ y= 0
$$


#### 2.1.2 成本函数 ####

##### 2.1.2.1 复杂成本函数 ##### 

##### 2.1.2.2 简单成本函数 ##### 

#### 2.1.3 梯度下降 ####

#### 2.1.4 高级优化 ####

### 2.2 多分类 ###

## 3 正则化 ##

### 3.1 拟合问题 ###

#### 3.1.1 过度拟合 ####

#### 3.1.2 不足拟合 ####

### 3.2 成本函数 ###

### 3.3 正则化应用 ###

#### 3.3.1 正则化线性回归 ####

##### 3.3.1.1 梯度下降 #####

##### 3.3.1.2 标准方程 #####

#### 3.3.2 正则化逻辑回归 ####

##### 3.3.2.1 梯度下降 #####




## 4 总结 ##


{: .img_middle_hg}
![regular expression](/assets/images/posts/2015-06-01/client mysql.jpg)

{% highlight mysql linenos %}

{% endhighlight %}

## 5 参考资料 ##

- [《MySQL in One Tutorial》](https://www.youtube.com/watch?v=yPu6qV5byu4);
- [《MySQL Cookbook》](https://www.amazon.com/MySQL-Cookbook-Paul-DuBois/dp/059652708X/ref=sr_1_2?ie=UTF8&qid=1469005314&sr=8-2&keywords=mysql+cookbook);
- [《MySQL Tutorial》](http://www.tutorialspoint.com/mysql/);





