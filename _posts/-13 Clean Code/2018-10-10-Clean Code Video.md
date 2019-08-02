---
layout: post
title: Clean Code
categories: [-13 Clean Code]
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


##∂## V3: Functions

1. Function should be small <= 20 loc
2. Function in small scope should have long descriptive names
3. Work with legacy code. Write test first, then refactor should not violate the test, which guard your change.
4. refactor large function to a class with several small functions
5. Focus on readability instead of function call overhead.

#### V4: Function Structure

1. function parameter number should be <= 3; none of them should be boolean
2. No output arguments //TBC appendFooter(s), whether s as an input and appends it somewhere, or appends to s.
3. Step down rule


  {: .img_middle_mid}
  ![JWT]({{site.url}}/assets/images/posts/-13_CleanCode/2018-10-10-CleanCodeVideo/V4-Function-Structure_step_down_rule.png)


{:start="4"}
4. minimize switch usage

  {: .img_middle_mid}
  ![JWT]({{site.url}}/assets/images/posts/-13_CleanCode/2018-10-10-CleanCodeVideo/V4-Function-Structure_switch.png)

{:start="5"}
5. Dependency injection. Main should be a plugin for application.

6. Paradiagms
  - Functional Program: no assignment statement；
  - Structured Program: sequence, selection, iteration

7. Command Query Separation: function change state doesn't return state; function query state doesn't change state.

8. Error Handling

#### V5: Form

1. Coding standard is important.
2. Every comment you wrote is the failure to express in code.
3. Use 2 spaces instead of a tab
4. instance variable is invisible to the user of the class. So from outside, an object of class has no observable state.i
5. Difference between class and data structures. The former has private instance method and public method; the later have public variable and no public method;
6. ORM is transform data structure(not object) in DB to data structure (not object) in  momery

#### V6: TDD

TDD advantages:

1. Quality guarantee for refactoring (clean code). Changed code must pass the exist test


TDD 3 rules:

1. Writing no production code until you first writing a failing unit test;

2. Writing only enough of test to demonstrating a failure; not compiling is a failure;

3. Writing only enough production code to pass the test.

Example:

1. Balling TTD

#### V7: Architecture, Use Cases and High Level Design

Good Architecture:

0. Focus on **Use Cases**, rather on software environment

1. Allow you to defer the decision about framework and tools. For example, `Fitness`, a wiki page project, delayed the mysql database implementation by using a flat file storage. The flat file storage is used for writing test and it turns out good enough for real usage. In this case, the mysql database is not needed anymore. 

TBC


##∂ 2 参考资料 ##

- [The Elements of Programming Style](https://book.douban.com/subject/1470267/); 
