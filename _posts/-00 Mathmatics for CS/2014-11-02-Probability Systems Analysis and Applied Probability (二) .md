---
layout: post
title: PSAAP(二)：General Random Variables
categories: [-00 Math]
tags: [Probability Theory]
number: [-0.1]
fullview: false
shortinfo: 本文是对MIT 公开课6041 Probabilistic Systems Analysis and Applied Probability 的总结。

---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}


## 8:  Continuous Random Variables ##

Note: numerical value of random variable is determined by even from sample space.

- PMF is the density function for disrete random variable;
- PDF is the density function for continuous random variable;

### 8.1 Probability density functions

$$E(X) = \int_{-\infty}^{\infty} xf(x)dx $$

$$E(g(X)) = \int_{-\infty}^{\infty} g(x)f(x)dx $$

$$var(X) = \int_{-\infty}^{\infty} (x-E(X))^2f(x)dx $$

### 8.2 Cumulative distribution functions (CMF)

CMF is the general notation for describe both discrete and continuous PMF for random variables

$$F_X(x) = P(X \le x) = \int_{-\infty}x f_X(t)dt $$

### 8.3 Normal random variables

{: .img_middle_lg}
![Gaussian normal PDF]({{site.url}}/assets/images/posts/-00_Math/Probability/2014-11-02-Probability Systems Analysis and Applied Probability (二)/Gaussian normal PDF.png)

## 9 Multiple Continuous Random Variable

Conditioning & Independencd

{: .img_middle_lg}
![Gaussian normal PDF]({{site.url}}/assets/images/posts/-00_Math/Probability/2014-11-02-Probability Systems Analysis and Applied Probability (二)/Multiple random variable.png)


## 9: 


{: .img_middle_mid}
![gcc & gdb]({{site.url}}/assets/images/posts/-00_Math/Probability/2014-11-01-Probability Systems Analysis and Applied Probability (一)/multiple random variable.png)




## 3 总结 ##

{: .img_middle_hg}
![gcc & gdb]({{site.url}}/assets/images/posts/-00_Math/Probability/2014-11-01-Probability Systems Analysis and Applied Probability (一)/independence.png)

## 4 Reference ##

- [《Probabilistic Systems Analysis and Applied Probability》](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-041sc-probabilistic-systems-analysis-and-applied-probability-fall-2013/); 




