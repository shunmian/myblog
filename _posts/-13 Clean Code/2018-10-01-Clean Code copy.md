---
layout: post
title: Clean Code
categories: [-14 Clean Code]
tags: [Clean Code]
number: [-2.1]
fullview: false
shortinfo: Clean code video in https://cleancoders.com/videos?series=clean-code。
---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1. Clean Code Video ##

### 1.1 Clean Code

####  V0: The Last Programming Language

3 different paradiams:
- structured language: direct control transfer (use if, while, avoid using goto)
- OOP: indirect control transfer, encapulation, inheritance, polymorphism
- funcitonal programming: no mutable data

All make contraints on programming instead of make addition.

The last language Uncle bob recommend is: Closure or Lisp, the boundary between code and data is mixed (code is data, data is code)

#### V1: introduction

The importance of clean code: makes a company success or fail. Dirty code is hard to scale and when code of line increase, the productivity decrease dramatically until a point that it cannot be managed.

#### V2: Names

1. Communicate your intent.

2. Avoid disinformation.

3. Make names pronounceable.

4. Avoid encodings. Don't use prefix or suffix to denote type, such as `m_width` to indicate member varaialbe, or `i` for interface, `c` for class, `s` for string for 匈牙利命名法。The type info is not needed in naming, because IDE will catch type error and unit test will prove the correctness.

6. Choose Parts of Speech well and Code Should be Read as Poems. Use verb for function, such as `getName()`; use `is` for method that return boolean, such as `isSet()`, so when use it,it can be read as `if(isSet())`;

7. Scope vs name length.
 - variable in a very short scope should use short names. 
 - function/class name in a short scope should have long explaintory names; in a long scope should have short names, `open` is better than `openFileAndThrowIfNotFounded` for a `FILE` class. Nice short name for short class and longer name for private names.
 - derived class name should have long names with adjactive appendid regardless of the scope.

8. Whenever you need to go to the implementation detail to figure out what does that name mean, the name is not good.

  
## 2 参考资料 ##

- [JWT](https://jwt.io/);
- [Introduction to JWT (JSON Web Token) - Securing apps & services](https://www.youtube.com/watch?v=oXxbB5kv9OA);


