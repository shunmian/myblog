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


{% highlight js linenos %}
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

- comments is the complement to the failure of code expressiveness.

#### 4.2 Use function or variable to replace comment

Example 1

{% highlight js linenos %}
// Check to see if the employee is eligible for full benefits
if ((employee.flags & HOURLY_FLAG) && (employee.age > 65))
{% endhighlight %}


{% highlight js linenos %}
if (employee.isEligibleForFullBenefits())
{% endhighlight %}

Example 2

{% highlight js linenos %}
// does the module from the global list depend on the subsystem we are part of?
if (smodule.getDependSubsystems().contains(subSysMod.getSubSystem()))
{% endhighlight %}

{% highlight js linenos %}
ArrayList moduleDependees = smodule.getDependSubsystems();
String ourSubSystem = subSysMod.getSubSystem();
if (moduleDependees.contains(ourSubSystem))
{% endhighlight %}



#### 4.3 Do not write obvious javadoc


{% highlight js linenos %}
/*
* @param title The title of the CD
* @param author The author of the CD
* @param tracks The number of tracks on the CD
* @param durationInMinutes The duration of the CD in minutes
public void addCD(String title, String author, int tracks,
  int durationInMinutes) {
    CD cd = new CD();
    cd.title = title;
    cd.author = author;
    cd.tracks = tracks;
    cd.duration = duration;
    cdList.add(cd);
}
*/
{% endhighlight %}


#### 4.4 Do not keep commented out code

We have VCS like git, just delete the unused code, it will not be lost.

#### 4.5 Do not write unclear comment

comment is to explain code; do not write unclear comment that needs further comment to explain.

#### 4.6 Do not write Javadoc for private method

only write Javadoc for public method

### CH5 Formatting

#### 5.2 Write code like write a story in newspaper

- abstract -> outline -> detail
- blank line between different group of concepts; no bank line between similar concepts in one group

### CH6 Objects and Data Structures

#### 6.2 Data/Object Anti-Symmetry

- Procedural code (code using data structures) makes it easy to add new functions without changing the existing data structures. OO code, on the other hand, makes it easy to add new classes without changing existing functions.

- Procedural code makes it hard to add new data structures because all the functions must change. OO code makes it hard to add new function sbecause all the classes must change.

- Object hides their dta and expose operations.

### CH7 Error Handling

#### 7.7 Don't return null

{% highlight js linenos %}
List<Employee> employees = getEmployees();
if (employees != null) {
  for (Employee e : employees) {
    totalPay += e.getPay();
  }
}
{% endhighlight %}

{% highlight js linenos %}
public List<Employee> getEmployees() {
  if(... there are no employees...)
    return Collections.emptyList();
}

List<Employee> employees = getEmployees();
for (Employee e : employees) {
  totalPay += e.getPay();
}
{% endhighlight %}

### CH8 Boundaries

TBC

### CH9 Unit Tests

#### 9.1 Unit Test is as important as business code

- 测试代码和生产代码一样重要，它不是二等公民。它必须被思考，设计和照料。它该像生产代码一般保持整洁。

- 测试代码要well organised。 
  - 比如每个测试分三个部分`resetMocks()`, `mockReturnedValue()`, `doTest()`。这样比三个函数的逻辑全都放在一个函数里就清晰很多。
  - 测试与测试之间的关系要清晰明了，比如要测1个函数，它有三个param. 那测试的组织应该是
    - `testParamA(){ resetMocks(); mockReturnedValue(); doTestA();}`
    - `testParamB(){ resetMocks(); mockReturnedValue(); doTestB();}`
    - `testParamC(){ resetMocks(); mockReturnedValue(); doTestC();}`
  - 每个测试的断言概念只有1个。`it('Should return correct date', () => { expect(A.year).toBe(2019); expect(A.month).toBe(9)}; expect(A.day).toBe(11))`
  - 每个测试的断言数量要最小化，最好1个。`it('Should return correct date', () => { expect(A.).toEqual(new Date(2019-09-11))`

- FIRST原则
  - Fast
  - Independent: 每个测试要相互独立，不要有依赖。比如测试`insert`和`query`, `insert`要准备数据->插入->验证->删除数据, `query`要准备数据->插入->验证query->删除数据。`insert`和`query`要有各自插入，删除的操作以保证两个测试时独立的。

- 如果你坐视测试腐坏，那么代码也会跟着腐坏，保持测试整洁吧。

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


