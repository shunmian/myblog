---
layout: post
title: CPPProject(一)：Build Tool：cmake
categories: [00 CPP]
tags: [CPP]
number: [0.1]
fullview: false
shortinfo: 本文是对cmake的总结。

---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1. cmake介绍

`make`是c/c++**build as code**的工具。但是一旦涉及到的文件太多，手写`Makefile`就变得不那么容易了。`cmake`就是解决这一痛点的。`cmake`通过`CMakeLists.txt`file，产生`Makefile`，可以认为是`Makefile`的工厂。`cmake`可以通过同一`CMakeLists.txt`，在不同平台上动态产生相应的`Makefile`，从而使得`c++`project"Write once, run everywhere"成为可能。

使用`cmake`的流程如下:

1. 编写`CMake`配置文件`CMakeLists.txt`;

2. `mkdir build && cd build`. 这个命令是为了将cmake产生`Makefile`的中间文件都group到`build`文件夹下，使得文件夹干净。

3. `cmake ..`, 去上一个目录将`CMakeLists.txt`通过cmake转成`Makefile`

4. `make`，在本目录下运行`Makefile`文件。

## 1.1 Demo1

{% highlight cpp linenos %}

#include <stdio.h>
#include <stdlib.h>
/**
 * power - Calculate the power of number.
 * @param base: Base value.
 * @param exponent: Exponent value.
 *
 * @return base raised to the power exponent.
 */
double power(double base, int exponent)
{
    int result = base;
    int i;
    
    if (exponent == 0) {
        return 1;
    }
    
    for(i = 1; i < exponent; ++i){
        result = result * base;
    }
    return result;
}
int main(int argc, char *argv[])
{
    if (argc < 3){
        printf("Usage: %s base exponent \n", argv[0]);
        return 1;
    }
    double base = atof(argv[1]);
    int exponent = atoi(argv[2]);
    double result = power(base, exponent);
    printf("%g ^ %d is %g\n", base, exponent, result);
    return 0;

{% endhighlight %}

CMakeLists.txt 的语法比较简单，由命令、注释和空格组成，其中命令是不区分大小写的。符号 # 后面的内容被认为是注释。命令由命令名称、小括号和参数组成，参数之间使用空格进行间隔。

{% highlight cmake linenos %}
# CMake 最低版本号要求
cmake_minimum_required (VERSION 2.8)
# 项目信息
project (Demo1)
# 指定生成目标
add_executable(Demo main.cc)
{% endhighlight %}

### 1.2 同一目录，多个源文件(Demo2)

{% highlight cpp linenos %}
./Demo2
    |
    +--- main.cc
    |
    +--- MathFunctions.cc
    |
    +--- MathFunctions.h
{% endhighlight %}

这个时候，CMakeLists.txt 可以改成如下的形式：

{% highlight cmake linenos %}
# CMake 最低版本号要求
cmake_minimum_required (VERSION 2.8)
# 项目信息
project (Demo2)
# 指定生成目标
add_executable(Demo main.cc MathFunctions.cc)
{% endhighlight %}

唯一的改动只是在 add_executable 命令中增加了一个 MathFunctions.cc 源文件。这样写当然没什么问题，但是如果源文件很多，把所有源文件的名字都加进去将是一件烦人的工作。更省事的方法是使用 aux_source_directory 命令，该命令会查找指定目录下的所有源文件，然后将结果存进指定变量名。其语法如`aux_source_directory(<dir> <variable>)`

{% highlight cpp linenos %}
# CMake 最低版本号要求
cmake_minimum_required (VERSION 2.8)
# 项目信息
project (Demo2)
# 查找当前目录下的所有源文件
# 并将名称保存到 DIR_SRCS 变量
aux_source_directory(. DIR_SRCS)
# 指定生成目标
add_executable(Demo ${DIR_SRCS})
{% endhighlight %}

这样，CMake 会将当前目录所有源文件的文件名赋值给变量 DIR_SRCS ，再指示变量 DIR_SRCS 中的源文件需要编译成一个名称为 Demo 的可执行文件。

### 1.3 多个目录，多个源文件(Demo3)

{% highlight cpp linenos %}
./Demo3
    |
    +--- main.cc
    |
    +--- math/
          |
          +--- MathFunctions.cc
          |
          +--- MathFunctions.h

{% endhighlight %}

对于这种情况，需要分别在项目根目录 Demo3 和 math 目录里各编写一个 CMakeLists.txt 文件。为了方便，我们可以先将 math 目录里的文件编译成静态库再由 main 函数调用。

根目录中的 CMakeLists.txt ：

{% highlight cpp linenos %}
# CMake 最低版本号要求
cmake_minimum_required (VERSION 2.8)
# 项目信息
project (Demo3)
# 查找当前目录下的所有源文件
# 并将名称保存到 DIR_SRCS 变量
aux_source_directory(. DIR_SRCS)
# 添加 math 子目录
add_subdirectory(math)
# 指定生成目标 
add_executable(Demo main.cc)
# 添加链接库
target_link_libraries(Demo MathFunctions)

{% endhighlight %}

该文件添加了下面的内容: 第3行，使用命令 add_subdirectory 指明本项目包含一个子目录 math，这样 math 目录下的 CMakeLists.txt 文件和源代码也会被处理 。第6行，使用命令 target_link_libraries 指明可执行文件 main 需要连接一个名为 MathFunctions 的链接库 。

子目录中的 CMakeLists.txt：

{% highlight cpp linenos %}
# 查找当前目录下的所有源文件
# 并将名称保存到 DIR_LIB_SRCS 变量
aux_source_directory(. DIR_LIB_SRCS)
# 生成链接库
add_library (MathFunctions ${DIR_LIB_SRCS})
{% endhighlight %}

在该文件中使用命令 add_library 将 src 目录中的源文件编译为静态链接库。


## 2. 总结 ##

TBC

## 3. Reference ##

- [cmake](https://www.hahack.com/codes/cmake/);


