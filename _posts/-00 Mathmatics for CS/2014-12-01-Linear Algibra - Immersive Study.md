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

## 1 Proof ##

### 1.1 Vectors 

### 1.2 Dot Product



### 1.2 Vector Product

$$\vec{U} \times \vec{V} = |U||V| sin(\theta)$$, 大小为由uv向量形成的平行四边形的面积，方向为右手法则指向的垂直于uv平面

- Scalar triple product: (v X u) * w, 大小为由u,v,w形成的立方体的体积，为标量。

- Vector triple product: 

### 1.6 Matrix

> Matrix: 2 dimentional scalar array.

### 1.7 Determinants

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


## 2 GDB ##

## 3 总结 ##

{: .img_middle_hg}
![gcc & gdb]({{site.url}}/assets/images/posts/2014-06-30-A1 C Tools for Linux/gdb.png)

## 4 Reference ##

- [《Mathematics for Computer Science》](https://courses.csail.mit.edu/6.042/spring17/mcs.pdf);





