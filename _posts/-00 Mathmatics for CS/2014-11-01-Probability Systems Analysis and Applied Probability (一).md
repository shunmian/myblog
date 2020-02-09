---
layout: post
title: PSAAP(一)：Probability Models and Discrete Random Variables 
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

## 1 & 2:  Probability Models and Axioms ##

### 1.1 Probability as a mathematical framework for reasoning abut uncertainty

### 1.2 Probabilistic models

#### 1.2.1 Sample space

> Sample space: all possible outcome。离散例子， 投硬币， set(正面，反面)； 连续例子, 投飞镖在一个2维正方形内。

#### 1.2.2 probability law

### 1.3 Axioms of probability

- Nonnegative: $$ P(A) \ge 0 $$;
- Normalizaton: $$ P(\omega) $$;
- Additivity: $$ if A \cap B = \varnothing, then P(A \cup B) = P(A) + P(B)  $$

### 1.4 Simple examples

### 1.5 Condtitional Probability

$$ P(A|B) \times P(B) = P(A,B) $$

### 1.6 Three important laws

#### 1.6.1 Multiplication

#### 1.6.2 Total probability

$$ P(B) = P(B|A_1) \times P(A_1) +  P(B|A_2) \times P(A_2) + P(B|A_3) \times P(A_3) $$

#### 1.6.3 Baye's law

$$ P(A,B) = P(A|B) \times P(B) = P(B|A) \times P(A) $$

giving B happens, how likely A happening;
giving A happens, how likely B happening;

### QA

$$y = f(x)$$(函数将x隐射程y) vs $$ p = P(X)$$(样本空间的概率分布):


## 3 Independence



#### 1.2.1 Determinants

#### 1.2.2 Rank

#### 1.2.3 Linear Mappings

#### 1.2.4 Eignvalues and Eigenvectors 

## 2 GDB ##

## 3 总结 ##

{: .img_middle_hg}
![gcc & gdb]({{site.url}}/assets/images/posts/2014-06-30-A1 C Tools for Linux/gdb.png)

## 4 Reference ##

- [《Probabilistic Systems Analysis and Applied Probability》](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-041sc-probabilistic-systems-analysis-and-applied-probability-fall-2013/);





