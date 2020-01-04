---
layout: post
title: Linear Algibra - Immersive Study 
categories: [-00 Math]
tags: [Linear Algibra]
number: [-0.1]
fullview: false
shortinfo: 本文是对Linear Algibra的总结。

---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1 Introduction ##

矩阵可以从两个角度理解

1. 静态， 多维空间的坐标，封装数据。

2. 动态， 线性变换。
  2.1 秩      是线性变化后基向量的空间维度
  2.2 行列式   是线性变换后基向量张成的面积 
  2.3 特征向量 是线性变换后仍在同一直线上的向量，特征值是这些向量的伸缩程度。

### 1.1 矩阵静态

#### 1.1.1 Vectors 

#### 1.1.2 Dot Product

$$\vec{U} \cdot \vec{V} = \begin{bmatrix} u_{1} \\\ u_{2}\end{bmatrix}  \cdot  \begin{bmatrix} v_{1} \\\ v_{2}\end{bmatrix} = u_{1}v_{1} - u_{2}v_{2} = |\vec{U}||\vec{V}|cos(<\vec{U}, \vec{V}>)$$

$$\vec{U}$$投射到$$\vec{V}$$上的大小与$$|\vec{V}|$$的乘积。

#### 1.1.3 Vector Product

$$\vec{U} \times \vec{V} = |U||V| sin(\theta)$$
大小为由uv向量形成的平行四边形的面积，方向为右手法则指向的垂直于uv平面

- Scalar triple product: (v X u) * w, 大小为由u,v,w形成的立方体的体积，为标量。

- Vector triple product: 


#### 1.1.4 Matrix

> Matrix: 2 dimentional scalar array.

### 1.2 矩阵动态

#### 1.2.1 Determinants

二维行列式

$$A = \begin{bmatrix}a_{11} & a_{12}\\a_{21} & a_{22}\end{bmatrix} = \begin{bmatrix}\vec{a_{1}} & \vec{a_{2}}\end{bmatrix}$$
$$det(A) =|\vec{a_{1}} \times\vec{a_{2}}| = a_{11}a_{22} - a_{12}a_{21}
= 两个向量张成的平行四边形的面积$$

{: .img_middle_hg}
![2dDerminants]({{site.url}}/assets/images/posts/-00_Math/LinearAlgibra/2dDerminants.png)

三维行列式

$$A = \begin{bmatrix}a_{11} & a_{12} & a_{13}\\a_{21} & a_{22}& a_{23}\\a_{31} & a_{32}& a_{33}\end{bmatrix} = \begin{bmatrix}\vec{a_{1}} & \vec{a_{2}} & \vec{a_{3}}\end{bmatrix}$$
$$det(A) =|\vec{a_{1}} \times\vec{a_{2}}| = a_{11}a_{22}a_{33}+a_{12}a_{23}a_{31}+a_{13}a_{21}a_{32}-a_{13}a_{22}a_{31}-a_{11}a_{23}a_{32}-a_{12}a_{21}a_{33}=三维向量张成的平行立方体的体积$$

{: .img_middle_hg}
![3dDerminants]({{site.url}}/assets/images/posts/-00_Math/LinearAlgibra/3dDerminants.png)

#### 1.2.2 Rank

$$A_{M \times N} : rank(A) + nullspace(A) = N$$

#### 1.2.3 Linear Mappings

矩阵从静态角度可以看可以是坐标，从动态角度看可以是坐标系的转换。

#### 1.2.4 Eignvalues and Eigenvectors 


## 2 Introduction to Linear Algebra ##

### 2.1 The Geometry of Linear Equations

$$2x - y = 0$$
$$-x + 2y =3 $$

2 explain

1. Row Vector: interception of 2 lines $$\begin{bmatrix}2 & -1\\-1 & 2\end{bmatrix} \begin{bmatrix}x \\y \end{bmatrix} = \begin{bmatrix}0 \\3 \end{bmatrix} => \begin{bmatrix}2x - y = 0\\-x + 2y =3\end{bmatrix}$$

2. Column Vector: linear combination of column vector $$\begin{bmatrix}2 & -1\\-1 & 2\end{bmatrix} \begin{bmatrix}x \\y \end{bmatrix} = \begin{bmatrix}0 \\3 \end{bmatrix} => x\begin{bmatrix}2 \\-1 \end{bmatrix} + y\begin{bmatrix}-1\\ 2\end{bmatrix} =   \begin{bmatrix}0 \\3 \end{bmatrix} $$

matrix vector multiplication

$$\begin{bmatrix}a_{11} & a_{12}\\a_{21} & a_{22}\end{bmatrix} \begin{bmatrix}x \\y \end{bmatrix} = x\begin{bmatrix}a_{11} \\a_{21} \end{bmatrix} + y\begin{bmatrix}a_{12}\\ a_{22}\end{bmatrix} vs \begin{bmatrix}a_{11}x+ a_{12}y\\a_{21}x + a_{22}y\end{bmatrix}$$

left is preferred than right

### 2.2 Elimination with Matrix

$$x + 2y + z = 2$$
$$3x + 8y + z = 12$$
$$0x + 4y + z = 2$$

Use elimination to get x, y and z:

1. replace 2nd by multiply -3 of 1st and add to 2nd;
2. replace 3rd by muutiply -2 of 2nd and add to 3rd;

use matrix to represents the elimination step

1. $$\begin{bmatrix}1 & 0 & 0\\-3 & 1 & 0 \\0 & 0 & 1 \end{bmatrix} \begin{bmatrix}1 & 2 &1 \\3 & 8 & 1 \\0 & 4 & 1 \end{bmatrix} =  E_{21}A = \begin{bmatrix}1 & 2 &1 \\0 & 2 & -2 \\0 & 4 & 1 \end{bmatrix} $$

2. $$\begin{bmatrix}1 & 0 & 0\\0 & 1 & 0 \\0 & -2 & 1 \end{bmatrix} \begin{bmatrix}1 & 2 &1 \\0 & 2 & -2 \\0 & 4 & 1 \end{bmatrix} =  E_{32}A = \begin{bmatrix}1 & 2 &1 \\0 & 2 & -2 \\0 & 0 & 5 \end{bmatrix} $$


combine the above two matrix, one can get the final matrix that does step 1 and 2 at one shot.

$$E_{32}(E_{21}A) = (E_{32}E_{21})A =  \begin{bmatrix}1 & 2 &1 \\0 & 2 & -2 \\0 & 0 & 5 \end{bmatrix} = U$$

Note:

1. multiply on right is column linear combination: $$\begin{bmatrix}a & b \\c & d \end{bmatrix} \begin{bmatrix}0 & 1 \\1 & 0 \end{bmatrix} = \begin{bmatrix}b & a \\d & c \end{bmatrix}$$

2. multiply on left is row linear combination: $$\begin{bmatrix}1 & 0 \\0 & 1 \end{bmatrix} \begin{bmatrix}a & b \\c & d \end{bmatrix} = \begin{bmatrix}c & d \\a & b \end{bmatrix}$$




## 3 总结 ##

{: .img_middle_hg}
![gcc & gdb]({{site.url}}/assets/images/posts/2014-06-30-A1 C Tools for Linux/gdb.png)

## 4 Reference ##

- [《Mathematics for Computer Science》](https://courses.csail.mit.edu/6.042/spring17/mcs.pdf);





