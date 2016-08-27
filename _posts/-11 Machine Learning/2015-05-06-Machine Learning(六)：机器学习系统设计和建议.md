---
layout: post
title: Machine Learning(六)：机器学习系统设计和建议
categories: [Machine Learning]
tags: [Machine Learning]
number: [-11.1]
fullview: false
shortinfo: 。

---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1 应用机器学习的建议 ##

### 1.1 评估学习算法 ###

#### 1.1.1 机器学习诊断 ####

当你的一个机器学习的算法实现后，你发现error过大，这个时候，你应该如何选择下一步呢？是扩大训练数据规模还是降低$\lambda$呢。通常来说我们有以下几种方式可以尝试：

1. 获取更多训练数据；

2. 减少feature；

3. 增加feature；

4. 增加高次项；

5. 降低$\lambda$；

6. 增加$\lambda$。

但是他们之间哪个更有效呢？很多机器学习的实践者通过自己的感觉来随机选择优先级，使得浪费大量时间才发现这一项没有太多用处。比如如果选择扩充训练数据，通常可以占据你6个月以上时间。6个月后才发现我可能只需要增加feature就能解决问题就已经浪费了大量的时间。我们下面介绍几种方法可以帮我们剔除掉这个list中的一半以上的选项，使得我们可以用更短的时间focus在最有可能解决问题的选项上。

#### 1.1.2 评估一个预测函数 ####

如何评估一个预测函数的准确性呢，单单看训练后的error是不够的，必须要对新的data预测的error也足够小。比如过度拟合虽然拟合的error很小，但是对新data预测的error往往会很大。那么如何获取新data用以预测呢，一个实用的方法是：

1. 将已有数据随机排列；
2. 选取前70%作为训练data，后30%作为预测data；

只有两者都足够小的情况下，这个预测函数才算准确。预测data的error可以分为下面两种情况：

1. 对于线性拟合，$
J_{test}(\Theta) = \frac 1 {2m_{test}} \sum_{i=1}^m (h_{\Theta}(x_{test}^{(i)}-y_{test}^{(i)})^{2}
$

2. 对于分类，
$$
\begin{align}
&J_{test}(\Theta)= \frac 1 {m_{test}} \sum_{i=1}^m err((h_{\Theta}(x_{test}^{(i)},y_{test}^{(i)}) 
\\
&\text{ where $err(h_{\Theta}(x_{test}^{(i)},y_{test}^{(i)}) =
\begin{cases}
1, &\text{if $h_{\Theta}(x_{test}^{(i)} ≥ 0.5 $ and $y=0$ or $h_{\Theta}(x_{test}^{(i)} < 0.5 $ and $y=1$  } \\
0, &\text{otherwise} \\
\end{cases}$}
\end{align}
$$

#### 1.1.3 模型选择(feature个数)和Train/Validation/Test Sets ####

那么如何选择**feature个数**和预测**generalized error**(指新的data的error)呢？请看下图，用**Train(60%)/Validation(20%)/Test(20%)**算出的**generalized error**更准确。

{: .img_middle_hg}
![Feature个数 vs Generalized Error](/assets/images/posts/2015-05-06/Feature个数 vs Generalized Error.png)


### 1.2 Bias vs. Variance ### 


#### 1.2.1 如何确定feature个数####

如何判断feature个数过少(High Bias,underfitting)或者feature个数过多呢(High Variance, overfitting)，我们可以参考$J_{train}(\theta)$和$J_{cv}(\theta)或者J_{test}(\theta)$的关系。

{: .img_middle_hg}
![Feature个数和baisvariance](/assets/images/posts/2015-05-06/Feature个数和baisvariance.png)



#### 1.2.2 如何确定$λ$ ####

正则化是用来解决overfitting的问题，但是$λ$过大会导致underfitting问题，$λ$过小会有overfitting问题。如何选择$λ$的大小呢。

{: .img_middle_hg}
![lambda和baisvariance](/assets/images/posts/2015-05-06/lambda和baisvariance.png)




#### 1.2.3 学习曲线和Bias/Varaince ####

#### 1.2.4 小结 ####

## 2 机器学习系统设计 ##

### 2.1 垃圾邮件分类器 ###

### 2.2 处理错误数据 ###

### 2.3 使用大规模数据 ###


## 3 总结 ##


{: .img_middle_hg}
![regular expression](/assets/images/posts/2015-06-01/client mysql.jpg)

{% highlight mysql linenos %}

{% endhighlight %}

## 4 参考资料 ##
- [《MySQL in One Tutorial》](https://www.youtube.com/watch?v=yPu6qV5byu4);
- [《MySQL Cookbook》](https://www.amazon.com/MySQL-Cookbook-Paul-DuBois/dp/059652708X/ref=sr_1_2?ie=UTF8&qid=1469005314&sr=8-2&keywords=mysql+cookbook);
- [《MySQL Tutorial》](http://www.tutorialspoint.com/mysql/);





