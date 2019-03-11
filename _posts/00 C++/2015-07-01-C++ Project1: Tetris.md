---
layout: post
title: C++ Project1：Tetris
categories: [00 CPP]
tags: [CPP]
number: [0.1]
fullview: false
shortinfo: 本文是对实验楼《C++ Project1：Tetris》的总结。

---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1. 书内容

### 1.1 What is `ncurses` ##

> ncurses: It is a library of functions that manage an application's display on character-cell terminals.

#### 1.1.1 install ncurses in Mac

{% highlight cpp linenos %}
$ curl -O ftp://ftp.gnu.org/gnu/ncurses/ncurses-5.9.tar.gz
$ tar -xzvf ncurses-5.9.tar.gz
$ cd ./ncurses-5.9
$ ./configure --prefix=/usr/local \
  --without-cxx --without-cxx-binding --without-ada --without-progs --without-curses-h \
  --with-shared --without-debug \
  --enable-widec --enable-const --enable-ext-colors --enable-sigwinch --enable-wgetch-events \
&& make
$ sudo make install
{% endhighlight %}





## 2. 总结 ##

{% highlight cpp linenos %}
{% endhighlight %}

{: .img_middle_hg}
![Network overview](/assets/images/posts/2014-06-01-C Review/Chapter 14 The Preprocessor.png)


## 3. Reference ##

- [《C++Primer》](https://book.douban.com/subject/24089577/);
- [《Effective C++》](https://book.douban.com/subject/1842426/);
- [《More Effective C++》](https://book.douban.com/subject/1457891/);


