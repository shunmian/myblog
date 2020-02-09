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

giving B happens, how likely A happening; when B happens, the sample space change from $$\omega$$ to $$B$$
giving A happens, how likely B happening;


### QA

$$y = f(x)$$(函数将x隐射程y) vs $$ p = P(X)$$(样本空间的概率分布):

## 3 Independence

Independence of A and B means:

$$ P(A,B) = P(A) \times P(B) $$ or
$$ P(B|A) = P(B) $$

{: .img_middle_lg}
![gcc & gdb]({{site.url}}/assets/images/posts/-00_Math/Probability/2014-11-01-Probability Systems Analysis and Applied Probability (一)/independence.png)

## 4 Counting

### 4.1 Principles of counting

### 4.2 Eaxamples

#### 4.2.1 permutations(排列)

#### 4.2.2 k-permutations

$$ A! $$

#### 4.2.3 combinations(组合)

choose k items set out of total m item.

$$ C_k^m =  \frac {m!} {(m-k)!k!} $$

#### 4.2.4 partitions

## 5, 6 & 7 Discrete Random Variables I

### 5.1 Random variable

Random variable X: function from sample space to the real numbers

{: .img_middle_lg}
![gcc & gdb]({{site.url}}/assets/images/posts/-00_Math/Probability/2014-11-01-Probability Systems Analysis and Applied Probability (一)/random variable.jpg)

### 5.2 Probability mass function (PMF)

离散随机变量在各特定取值上的概率。

### 5.3 Expectation

$$ E[X] = \sum_{x \in X} xP(x)$$

in general $$E(g(x)) \ne g(E(x))$$;

$$E(\alpha) = \alpha$$

$$E(\alpha X) = \alpha E(X) $$

$$E(\alpha X + \beta) = \alpha E(X) + \beta$$

### 5.4 Variance

$$var(X) = E[(X-E(X))^2] = E[X^2] - (E(X))^2$$

$$var(X) \ge 0 $$

$$var(\alpha X + \beta) = {\alpha}^2 var(X) $$

$$ \sigma (X) = \sqrt{var (X)} $$

### 5.5 Conditional PMF

$$P(X=x| A)$$

$$E(X|A) = \sum_x xP(X=x|A)$$

### 5.6 Geometric PMF

{: .img_middle_mid}
![gcc & gdb]({{site.url}}/assets/images/posts/-00_Math/Probability/2014-11-01-Probability Systems Analysis and Applied Probability (一)/Geometric PMF.png)


### 5.7 Total expectation theorem

$$E[X] = P(A_1)E[X|A_1] + ... + P(A_n)E[X|A_n]$$

### 5.8 Join PMF of two random variables

$$ P(X=x, Y =y) $$

$$P(X=x|Y=y) = \frac {P(X=x, Y = y)} {P(Y=y)}$$

{: .img_middle_mid}
![gcc & gdb]({{site.url}}/assets/images/posts/-00_Math/Probability/2014-11-01-Probability Systems Analysis and Applied Probability (一)/Joint PMF.png)

### 5.9 Multiple random variable

#### 5.9.1 Joint PMF

#### 5.9.2 Conditioning

$$PX,Y,Z(x,y,z) = PX(x)PY(y|X=x)PZ(z)Y=y, X=x$$

#### 5.9.3 Independence

$$PX,Y,Z(x,y,z) = PX(x)PY(y)PZ(z)$$

#### 5.9.4 Expectations & Varience


{: .img_middle_mid}
![gcc & gdb]({{site.url}}/assets/images/posts/-00_Math/Probability/2014-11-01-Probability Systems Analysis and Applied Probability (一)/multiple random variable.png)




## 3 总结 ##

{: .img_middle_hg}
![gcc & gdb]({{site.url}}/assets/images/posts/-00_Math/Probability/2014-11-01-Probability Systems Analysis and Applied Probability (一)/independence.png)

## 4 Reference ##

- [《Probabilistic Systems Analysis and Applied Probability》](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-041sc-probabilistic-systems-analysis-and-applied-probability-fall-2013/); 




