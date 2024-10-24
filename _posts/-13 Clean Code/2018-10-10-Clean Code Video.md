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

### 1.1 Clean Code: Foundamentals

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

### 1.2 Clean Code: SOLID Principles

#### V8: SOLID Principle

TBC

#### V9: Single Responsibility Principle

From a user of class point view, if the user change requirement on class, it shouldn't effect the other users who doesn't care about the new change. Achieving this require decouple design (facade, interface, subclass.)

Case Study Link: `http://dl.dropbox.com/u/4730299/MasterMind.zip`.

#### V10: Open Close Principle 

This principle is at the moral center of system architecture. Polymorphism to replace if else and switch statements.

  {: .img_middle_lg}
  ![JWT]({{site.url}}/assets/images/posts/-13_CleanCode/2018-10-10-CleanCodeVideo/V10-Open-Close-Principle.png)


#### V11: The Liskov Substitution Principle

- type is a bag of methods
- if you use square as a subtype of rectangle, there would be problem when you setWidth of square, the height is changed, which is not expected in rectangle. It is clear square is a subtype of rectangle in concepts, the oop modeling is not suitable to make square class a subtype of rectangle class.
- if S is subtype of T, list of S is not a subtype of list of T

  {: .img_middle_mid}
  ![JWT]({{site.url}}/assets/images/posts/-13_CleanCode/2018-10-10-CleanCodeVideo/V11-Liskov-Substitution-Principle.png)

- solution for a unsuitable subtype is to add an adapter. If Ded Modem subtype of Modem interface, it violates Ded Users,who is not happy to add additional function call of dial and hangup; if Ded Modem doesn't subtype of Modem interface, it violates the File Mover to use the Ded Modem as Modem interface. The solution to balance those two violation is to add Adapter

  {: .img_middle_lg}
  ![JWT]({{site.url}}/assets/images/posts/-13_CleanCode/2018-10-10-CleanCodeVideo/V11-Adapter.png)



Book References

- [The Annotated Turing](https://book.douban.com/subject/2330016/); 
- [Refatcoring](https://book.douban.com/subject/1419359/);
- [Growing Object-Oriented Software, Guided by Tests](https://book.douban.com/subject/4156589/);
- [https://book.douban.com/subject/1547078/](https://book.douban.com/subject/1547078/) 


#### V12: The Interface Segregation Principle

- interface tights more close to its user than its implementor, which indicates the following picture that `Switchable` interface is a good name and should be packaged together with its user `Switch`.


  {: .img_middle_mid}
  ![JWT]({{site.url}}/assets/images/posts/-13_CleanCode/2018-10-10-CleanCodeVideo/V12-Interface-Segregation-Principle-example1.png)

  {: .img_middle_lg}
  ![JWT]({{site.url}}/assets/images/posts/-13_CleanCode/2018-10-10-CleanCodeVideo/V12-Interface-Segregation-Principle-example2.png)

#### V13: The Dependent Inversion Principle

  {: .img_middle_lg}
  ![JWT]({{site.url}}/assets/images/posts/-13_CleanCode/2018-10-10-CleanCodeVideo/V13-Dependency-Inversion-Principle.png)





Dependency:

1. Compiler time dependency. A reference B, compile A needs compile B first if B.class is older than B.java

2. Runtime dependency


### 1.3 Clean Code: Component Design

### 1.4 Clean Code: Advanced TDD

### 1.5 Clean Code: Design Patterns

### 1.6 Clean Code: Behavior Driven Development

### 1.7 Clean Code: The Clean Coder

### 1.8 Clean Code: Agile

### 1.9 Clean Code: Functional Programming




## 2 参考资料 ##

- [The Elements of Programming Style](https://book.douban.com/subject/1470267/); 
