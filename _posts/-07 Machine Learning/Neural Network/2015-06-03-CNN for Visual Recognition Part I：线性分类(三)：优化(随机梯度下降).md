---
layout: post
title: CNN for VR Part I：线性分类(三)：优化(随机梯度下降)
categories: [-07 Machine Learning]
tags: [Machine Learning]
number: [-11.1]
fullview: false
shortinfo: 机器学习(Machine Learning)是通过非显性编程让计算机获得学习的能力，这在现代计算机科学中有着广泛的应用，从google的搜索分类，到OCR的训练以及AlphaGo的人工智能等等。本文是Coursera上吴恩达教授的《Machine Learning》系列课程的第一篇笔记：线性回归之单变量。

---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1 Optimization ##

[上一篇文章]({{site.baseurl}}/-07%20machine%20learning/2015/06/02/CNN-for-Visual-Recognition-Part-I-线性分类(二)-分数函数和损失函数(SVM,Softmax))介绍了图片分类问题中的两个key components：

1. **评分函数(Score Function)**：将原始数据映射到预测label；

2. **损失函数(Loss Function)**：测量评分函数和真实值的差距。

更具体的说，SVM损失函数具有如下格式：

$$
L = \frac{1}{N} \sum_i \sum_{j\neq y_i} \left[ \max(0, f(x_i; W)_j - f(x_i; W)_{y_i} + 1) \right] + \alpha R(W)
$$

我们将要介绍第3种也是最后1种component，即**Optimization**，用来最小化上述损失函数来获得最优评分函数。一旦我们理解了这3个component如何协同工作，我们会重新回顾第1个component来扩展比线性分类其更复杂的形式：即首先整个Neural Networks，其次是Convolutional Neural Networks。在这过程中，损失函数和optimization过程相对保持不变。


### 1.1 Visualizing the Loss Function ###

### 1.2 Optimization Strategies ###

#### 1.2.1 Random Search ####

#### 1.2.2 Random Local Search ####

#### 1.2.3 Following the Gradient ####

### 1.3 Computing the Gradient ###

#### 1.3.1 Numerically with Finite Differences ####

#### 1.3.2 Analytically with Calculus ####

### 1.4 Gradient descent ###


## 2 Summary ##


{: .img_middle_lg}
![Image Classification Challenges](/assets/images/posts/07_Machine Learning/Convolutional Neural Network/2015-06-01-CNN for Visual Recognition Part I：入门(一)：图片分类/Image Classification Challenges.jpeg)

repeat until convergence：

$$
\theta_0 := \theta_0 - \alpha \frac 1 m \sum_{i=1}^m[h_\theta(x^{(i)})-y^{(i)}]
$$


$$
\theta_1 := \theta_1 - \alpha \frac 1 m \sum_{i=1}^m \lbrace[h_\theta(x^{(i)})-y^{(i)}]x^{(i)}\rbrace
$$



## 6 参考资料 ##
- ["CS231n: Convolutional Neural Networks for Visual Recognition"](http://cs231n.stanford.edu/);
- ["CS231n Course Video 2016 Winter"](https://www.youtube.com/watch?v=g-PvXUjD6qg&index=1&list=PLIUoqCcJd2BjsI11qafvMWv_UqiH1Wu3Q);
- ["Deep Learning"](http://www.deeplearningbook.org/);


