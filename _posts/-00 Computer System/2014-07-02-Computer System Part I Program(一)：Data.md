---
layout: post
title: Computer System Part I Program(一)：Data
categories: [-00 Computer System]
tags: [Computer System]
number: [-0.1]
fullview: false
shortinfo: 本系列是对《Computer Systems - A Programmer's Perspective》读书总结，作为计算机科学其他课程的基础。本文是第2篇笔记-Data。

---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

对于Computer System的探索我们开始于Program的生命周期，包括：

1. 如何表示data types(例如integer和real arithmetic)，

2. 如何将.c文件编译为低级机器码和低级机器码如何表示data types；

3. 如何实现Processor来执行机器码；

4. 如何优化c程序来提高编译和机器码执行性能；

5. 如何设计memory系统。

本文介绍第1点：如何表示data types。

## 1 Data ##

2进制bit组合在一起可以表示所有有限的集合。通过不同的encoding可以表示成不同的data：

1. 无符号整数：Unsigned Encoding。

2. 有符号整数：2‘s Complement Encoding。

3. 实数：Floating Point Encoding。

{: .img_middle_mid}
![Integer & Real](/assets/images/posts/2014-07-02-Computer System Part I Program(一)：Data/Integer & Real.png)

了解不同的Encoding的representation可以帮助我们掌握它们的最大最小值以及相关的算术性质，用于分析异常结果。比如
200 * 300 * 400 * 500 为什么会是负数，而对于floating-point无论怎么操作都不会是负数；(3.14+1e20)-1e20为什么接近0等。

### 1.1 Bit###

#### 1.1.1 Byte ####

1个bit存储的信息量只有2个，太小。因此通常将8bit组成1个byte，作为数据的基本单位。每个byte在内存中都有1个ID，是它的地址。在C语言中，pointer(type value)value记录某数据块内存的第1个byte的地址(包括int，structure，array或者fucntion)，pointer的type记录了该数据块的类型(数据块类型有数据块长度的信息，用于比如p+3等pointer算术时决定步长)。

byte的表示用01二进制或者1-9十进制要么太繁琐，要么不利于程序阅读，一个解决的方法是用16进制，即将0000 0000 8位bit表示成FF两位16进制。16进制常数通常以0x开头，表示16进制，即hex。

#### 1.1.2 Word ####

word表示int和float的大小。Virtual Address是以word为单位划分内存的。比如在32bit机器上，int是4个byte，也就是word=4byte*8bit/byte=32bit。

#### 1.1.3 Data Size ####

{: .img_middle_mid}
![Data Size](/assets/images/posts/2014-07-02-Computer System Part I Program(一)：Data/Data Size.png)

#### 1.1.4 Addressing and Byte Ordering ####

对于横跨多个byte的数据类型来说，有两个问题必须解决：

1. **该数据的地址是什么？**换言之是以哪个byte的地址作为该数据的地址？通常多byte的数据被分配在连续地址的内存里，其中地址最小的byte的地址作为该数据的地址。比如int x的地址是0x100，则&x是0x100，且4byte的x被存储在0x100，0x101，0x102和0x103。

2. **byte的顺序是什么？**换言之是将数据位从小到大还是从大到小排列到byte？通常有**高位优先(Big-endian)**和**低位优先(Little-endian)**两种。

{: .img_middle_mid}
![Big-endian vs little endian](/assets/images/posts/2014-07-02-Computer System Part I Program(一)：Data/Big-endian vs little endian.png)

对于大多数程序员来说，byte ordering是隐形的，即他们的日常编程工作不会涉及到byte ordering。但是在下面3个场合byte ordering matters：

1. **Network communication**：不同byte ordering的发送和组装会导致不同结果。解决的方法是指定标准，发送者通过网络发送前必须完成数据byte ordering和网络标准的转换，接收者通过网络接收后也必须完成从网络标准到数据的byte ordering的转换。

2. **Machine level program**：

{% highlight c linenos %}
80483bd： 01 05 64 94 04 08    add  %eax, 0x8049464
{% endhighlight %} 

上面这行代码是disassembler executable program file产生的，左边是二进制，右边是机器码。左边表示执行``80483bd``在``01 05 64 94 04 08``地址上，这是1个表示将1个data加到0x8049464的操作的二进制表示。右边表示将左边解释成的机器码，我们可以看到取``01 05 64 94 04 08``后5byte，然后reverse，就是``0x8049464``。我们将在第3篇笔记[《Computer System Part I Program(二)：Machine-Level Execution》]({{site.baseurl}}/-00%20computer%20system/2014/07/03/Computer-System-Part-I-Program(二)-Machine-Level-Execution.html)详细介绍机器码的解读。

3. **程序绕过了正常的类型系统，如cast**：在C语言里，cast允许以不同的数据类型来引用数据。下面代码显示了int，float和pointer的值。

{% highlight c linenos %}
#include <stdio.h>

typedef unsigned char *byte_pointer;

void show_bytes(byte_pointer start, int len){
	for(int i = 0; i < len; i++){
		printf("%.2x ",start[i]);	//deference pointer use array notation
	}
	printf("\n");
}

void show_int(int x){
	show_bytes((byte_pointer) &x, sizeof(int));
}

void show_float(float x){
	show_bytes((byte_pointer) &x, sizeof(float));
}

void show_pointer(void *x){
	show_bytes((byte_pointer) &x, sizeof(void *));
}

void test_show_bytes(int val){

	int ival = 12345;	//12345 = 0x00003039
	float fval = (float) ival;
	void *pval = (void *) &ival;

	printf("ival: ");
	show_int(ival);

	printf("fval: ");
	show_float(fval);

	printf("pval: ");
	show_pointer(pval);

}

int main(int argc, char *argv[]){
	test_show_bytes(12345);
}

/* Output: little-endian
ival: 39 30 00 00 
fval: 00 e4 40 46 
pval: c8 7a d5 50 ff 7f 00 00 
*/
{% endhighlight %} 

可以看到我的系统是little-endian的系统，同时int是4byte，float是4byte，void *是8byte。不同系统的显示如下图。

{: .img_middle_lg}
![Bytes Representation](/assets/images/posts/2014-07-02-Computer System Part I Program(一)：Data/Bytes Representation.png)

可以看到float的显示``00 e4 40 46 ``和int的显示``39 30 00 00 ``是不一样的，但是将它们展开成bit，可以发现有11位是一样的。这是由于unsigned integer和float-point encoding决定的。

{: .img_middle_mid}
![int & float overlap](/assets/images/posts/2014-07-02-Computer System Part I Program(一)：Data/int & float overlap.png)

#### 1.1.5 Representing String ####

ASCII码和Unicode。

#### 1.1.6 Representing Code ####

通常以ASCII码存储，见[Computer System Overview]({{site.baseurl}}/-00%20computer%20system/2014/07/01/Computer-System-Overview.html)。

#### 1.1.7 Bit-Level, Logical, Shit Operations in C ####

通常比特位操作符有4个，与``&``,或``|``,非``~``，异或``^``。

{: .img_middle_mid}
![int & float overlap](/assets/images/posts/2014-07-02-Computer System Part I Program(一)：Data/Bit Operation.png)

利用异或我们可以完成1个inplace的两个数据的交换而不需要额外的局部变量。该程序利用了``a^a=0``的原理。

{% highlight c linenos %}
void inplace_swap(int *x, int *y){
	if(*x == *y) return;	//当*x和*y相等时，下面3行会让*x=0;当*x和*y不等时，下面代码才成立。
	*y = *x ^ *y;
	*x = *x ^ *y;
	*y = *x ^ *y;
}

void reverse_array(int *a,int cnt){
	int first, last;
	for(first = 0, last = cnt -1; first <= last; first++,last--){
		inplace_swap(&a[first],&a[last]);
	}
}
{% endhighlight %} 

逻辑操作符有3个，与``&&``,或``||``,非``！``。这很容易与比特位操作符``&``,``|``,``~``，``^``混淆。它们的不同点主要有3方面。

1. 逻辑运算符将所有非零值看做True，零看做False。而比特位操作符对象只有0和1，且只将1看做True。

2. 逻辑运算符不会赋值第二个参数如果第一个参数已经决定了整体的值。比如``a&&5/a``不会引起除数是0的错误。

移位操作主要有左移``<<``和右移``>>``。

### 1.2 Encoding ###

#### 1.2.1 Unsigned Integer: Unsigned Encoding ####

$B2U_w(\overrightarrow x) = \sum_{i=0}^{w-1} x_i2^i$

#### 1.2.2 Signed Integer: 2's Complement Encoding ####

$B2U_w(\overrightarrow x) =-2^{w-1}+ \sum_{i=0}^{w-2} x_i2^i$

#### 1.2.3 Real Number: Floating-point Encoding ####


**Floating Point** encodes rational numbers of the form $V = x  \times 2^y$。



##### 1.2.3.1 Factional Binary Number #####


十进制分数可以表示成$d =  \sum_{i=-n}^m 10^i \times d_i \text{, where } d = d_md_{m-1} \ldots d_1d_0.d_{-1}d_{-2} \ldots d_{-n}; $

$
\text{例如 $12.34_{10}$ 表示 $1 \times 10^1 + 2 \times 10^0 + 3 \times 10^{-1} + 4 \times 10^{-2}$。}
$



同理，二进制分数可表示成$b =  \sum_{i=-n}^m 2^i \times b_i \text{, where } b = b_mb_{m-1} \ldots b_1b_0.b_{-1}b_{-2} \ldots b_{-n}; $

$
\text{例如 $101.1_{2}$ 表示 $1 \times 2^2 + 0 \times 2^1 + 1  \times 2^0 + 1 \times 2^{-1} + 1 \times 2^{-2} = 4 + 0 + 1 + \frac 1 2 + \frac 1 4 = 5\frac 3 4$。}
$

但是这个二进制分数表示形式有两个主要缺点：

1. 用fixed point position将小数点前和小数点后分成固定长度的表示不够灵活。比如我们规定对于1byte，前4位表示整数，后4位表示小数，则只能表示15.9375 - 0的范围。

2. 表示很大的数字需要很多位bit。比如$1 \times 2^{100} \text{需要1后面跟$100$个$0$}$。

##### 1.2.3.2 IEEE Floating-Point Encoding #####

IEEE FLoating-Point将实数表示成$V = {(-1)}^s  \times M\times 2^E $，其中：

1. s表示sign，决定了该实数是+还是-。s用1位表示。

2. 尾数M是fraction binary number。M用n-bit表示，$f_{k-1} \cdots f_1f_0$。

3. 指数E表示2的指数。E用k-bit表示，$e_{k-1} \cdots e_1e_0$。


它根据E的范围分为三类：

1. Denormalized Value。当E全0时，表示$\{0\} \cup  [2^{-n-2^{k-1}+2}, (1-2^{-n}) \times 2^{-2^{k-1} + 2}]$。$(1-2^{-n}) \times 2^{-2^{k-1} + 2}$比1小。

2. Normalized Value。当E既不是全0也不是全1时，表示
$[2^{-2^{k-1}+2},1] \cup [1, ({1-2^{-n-1}}) \times 2^{2^{k-1}}]$

3. Special Value。当E时全1时：若M全0，则为$\infty$(当s为1时为$+\infty$，s为0时为$-\infty$)；否则，表示NaN(Not a Number，在计算结果不能用实数表示时比如$\sqrt {-1}$或者为初始化前如matlab)。

它们之间的转换关系见P104。用下图说明。

{: .img_middle_lg}
![Floating Point Encoding](/assets/images/posts/2014-07-02-Computer System Part I Program(一)：Data/Floating Point Encoding for k=4&n=3.png)

##### 1.2.3.3 IEEE Floating-Point Rounding #####

由于Floating-Point只能近似表示实数，因此会涉及到rounding问题，IEEE Floating-Point规定Rounding有4种模式。

{: .img_middle_lg}
![Floating Point Encoding](/assets/images/posts/2014-07-02-Computer System Part I Program(一)：Data/Floating Point Rounding.png)

C语言默认提供第1种，并且后3种并不支持。

##### 1.2.3.3 IEEE Floating-Point 性质 #####

由于Floating-Point只能近似表示实数，它的运算符合1种规定，就是将运算结果也round。这就导致了许多奇怪的问题，我们举例说明。

1. +运算符合交换律，但不符合结合律。$(3.14+1e10)-1e10 = 0.0$，但是$3.14 + (1e10-1e10) = 3.14$，这是由于rounding导致。

2. *运算符合交换律，但不符合结合律和分配律。$(1e20 * 1e20) * {1e-20} = + \infty$
，但是$1e20 * (1e20 * {1e-20}) = 1e20$，这是由于overflow和rounding同时导致。


## 2 总结 ##

{: .img_middle_hg}
![Chapter 2 Summary](/assets/images/posts/2014-07-02-Computer System Part I Program(一)：Data/Chapter 2 Summary.png)


## 3 Reference ##

- [《Computer Systems - A Programmer's Perspective》](https://www.amazon.com/Computer-Systems-Programmers-Perspective-2nd/dp/0136108040);





