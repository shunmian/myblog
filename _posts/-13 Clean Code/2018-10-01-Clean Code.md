---
layout: post
title: Clean Code
categories: [-14 Clean Code]
tags: [Clean Code]
number: [-2.1]
fullview: false
shortinfo: JWT介绍。
---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1. Clean Code ##

### CH1 Clean Code

#### 1.1 Use intention revealing names

`a[STATUS_VALUE] === FLAGGED` is better than `a[0]==4`.

#### 1.2 Avoid Disinformation

`accounts` is better than `accountList`, list has special meaning of `array` in programming.

#### 1.3 Make Meaningful Distinguish

`int copy(char source[], char destination[])` is better than `int copy(char a1[], char a2[])`

`ProductData` and `ProductInfo`里data和info就像a, an和the一样的废话。
`moneyAmount`和`money`没区别
`customerInfo`和`customer`没区别
`theMessage`和`message`没区别

#### 1.4 Use Pronounceable Names

`genymdhms`生成日期，年月日时分秒，但是不好发音， `generationTimestamp` is better

#### 1.5 Use Searchable Names

`MAX_CLASSES_PER_STUDENT` is better than `7`.

单字母名称仅用于短方法中的本地变量



### CH2 Meaningful name

### CH3 Functions

#### 3.3 One Level Abstraction Per Function

要确保函数只做一件事情，且函数中的语句都要在同一抽象层级上。比如`service`里调用`serviceA`, `serviceB`, `serviceC`; `serviceC`调用`daoA`, `daoB`, `daoC`。
换一种说法，我们想要这样读程序，程序就像一系列TO起头的段落，每一段都描述当前抽象层级，并引用位于下一抽象层级的后续TO起头段落。

- To include the setups and teardowns, we include setups, then we include the test page content, and then we include the teardowns.

- To include the setup if this is a suite, then we include the regular setup.

- To include the suite setup, we search the parent hierarchy for the "SuiteSetup" page and add an include statewment with the path of that page.

- To search the parent ...

#### 3.6 Function arguments

参数个数0>1>2,不要多于3个

#### 3.7 No side effect


{% highlight js linenos %}

function findItem(list, key, pool) {
  const found = _.find(pool, i => i.key == key)
  if (found) list.push(found)
}
{% endhighlight %}

{% highlight python linenos %}
function findItem(key, pool) {
  const found = _.find(pool, i => i.key == key)
  return found
}

function findAndInsertItem(list, key, pool) {
  const found = findItem(key, pool)
  list.push(found)
}

{% endhighlight %}

#### 3.9 Prefer exception over error code

{% highlight js linenos %}

if(deletePage(page) == E_OK) {
  if(registry.deleteReference(page.name) == E_OK) {
    if(configKeys.deleteKey(page.name.makeKey()) == E_OK) {
      logger.log("page deleted");
    } else {
      logger.log("configKey not deleted");
    }
  } else {
    logger.log("deleteReference from Registry failed");
  }
} else {
  logger.log("delete failed")
  return E_ERROR
}

{% endhighlight %}

{% highlight js linenos %}

try {
  deletePage(page);
  registry.deleteReference(page.name);
  configKeys.deleteKey(page.name.makeKey());
} catch (Exception e) {
  logger.log(e.getMessage());
}

{% endhighlight %}
// extract try block from try catch.
public void delete(Page page) {
  try {
    deletePageAndAllReferences(page)
  } catch(Exception e) {
    logError(e);
  }
}

public void deletePageAndAllReferences(Page page) {
  deletePage(page);
  registry.deleteReference(page.name);
  configKeys.deleteKey(page.name.makeKey());
}

{% endhighlight %}

#### 3.12 How to write functions like this

- Master programmer think of system as stories to be told rather than code to be written;
- You start with a draft, and gradually refine it to DRY, separate different level of logic into its own logic.

### CH4 Commnets

### CH5 Formatting

### CH6 Objects and Data Structures

### CH7 Error Handling

### CH8 Boundaries

### CH9 Unit Tests

### CH10 Classes

### CH11 Systems

### CH12 Emergence

### CH13 Concurrency

### CH14 Successive Refinement

### CH15 JUnit Internals

### CH16 Refactoring `SerialDate`

### CH17 Smells and Heuristics





{: .img_middle_hg}
![JWT]({{site.url}}/assets/images/posts/-14_Backend/2015-10-08-Backend：JWT/JWT.png)

## 2 参考资料 ##

- [JWT](https://jwt.io/);
- [Introduction to JWT (JSON Web Token) - Securing apps & services](https://www.youtube.com/watch?v=oXxbB5kv9OA);


