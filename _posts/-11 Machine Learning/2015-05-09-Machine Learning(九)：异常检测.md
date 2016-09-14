---
layout: post
title: Machine Learning(九)：异常检测和推荐系统
categories: [Machine Learning]
tags: [Machine Learning]
number: [-11.1]
fullview: false
shortinfo: 本文介绍非监督式学习的另外两个重要问题：异常检测和推荐系统。

---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1 非监督式学习 ##

### 1.3 异常检测(Anomaly Detection) ###

{: .img_middle_hg}
![异常检测](/assets/images/posts/2015-05-09/异常检测.png)


### 1.4 推荐系统 ###

{: .img_middle_hg}
![推荐系统](/assets/images/posts/2015-05-09/推荐系统.png)






## 2 作业 ##



见[这里](https://github.com/shunmian/-11-Machine-Learning)。附上一张跑分图。

{: .img_middle_mid}
![assignment8](/assets/images/posts/2015-05-09/assignment8.png)

## 3 总结 ##

本文介绍了非监督式学习的另外两个重要问题：**异常检测**和**推荐系统**。

1. **异常检测**用于有大量正常数据和少量非正常数据，它不同于监督式学习的分类(通过学习**大量正常**和**大量不正常**数据)，通过高斯分布，排除非正常数据。

2. **推荐系统**通过协同过滤算法，可以同时学习用户的喜好$\Theta$和电影的特征$X$。即使刚开始只有少量数据，随着用户的增加和电影的评分增加，$\Theta$和$X$就会越来越准确。



## 4 参考资料 ##
- [《Unsupervised Learning》](https://en.wikipedia.org/wiki/Unsupervised_learning);





