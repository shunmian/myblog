---
layout: post
title: Redux-Saga Part I：Basics
categories: [04 Web Development]
tags: [Redux]
number: [3.7.7]
fullview: false
shortinfo: 本文是对Redux-saga，一个用于network, atomic的框架的介绍。
---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1 Basic ##

> **A Saga** is a Long Lived Transaction that can be written as a sequence of sub-transactions T1,T2,Tn. The sub-transactions has a compensating Transaction C1,C2,Cn. Ci semantically undoes Ti. Saga Gurantee either T1,T2,..Tn or T1,T2 ... Tj, Cj, ... C2, C1. Saga is a failure management pattern.

> **Generator**: 函数声明和执行。函数声明两个关键字，`function*`表示返回值是`generator`, yield表示该地方分段执行；函数执行1个关键字，`next`，表示执行到声明时yield的地方。生成器对象是由一个`Generator Function`(迭代器工厂) 返回的,并且它符合**可迭代协议**(继承链上有1个对象必须实现迭代器协议)和**迭代器协议(实现`next`函数，该函数返回`value`和`done`属性)**。

> **Iterator(迭代器)**： 1个符合**迭代器协议**的对象，即有`next()`方法，该方法返回两个属性`done`和`value`。

{% highlight js linenos %}
function makeIterator(array){
    var nextIndex = 0;

    return {
       next: function(){
           return nextIndex < array.length ?
               {value: array[nextIndex++], done: false} :
               {done: true};
       }
    };
}

var it = makeIterator(['yo', 'ya']);
console.log(it.next().value); // 'yo'
console.log(it.next().value); // 'ya'
console.log(it.next().done);  // true
{% endhighlight %}


### 1.1 Using Saga Helpers

### 1.2 Declarative Effects

### 1.3 Dispatching Actions

### 1.4 Error Handling

### 1.5 A Common Abstraction: Effect

Effect vs Promise

Effect creation (description) vs Effect execution

put({type: 'INCREMENT'}) // => { PUT: {type: 'INCREMENT'} }			creation(description)
call(delay, 1000)        // => { CALL: {fn: delay, args: [1000]}}  creation(description)

saga-middleware

the above effect execution

Effect creation (description, command object) makes effect testable





## 2 Advanced

### 2.1 Pulling future actions

takeEvery vs take

takeEvery, action is pushed into saga. takeEvery can only allow you to write the handler when certain action is happen

{% highlight js linenos %}
import { select, takeEvery } from 'redux-saga/effects'

function* watchAndLog() {
  yield takeEvery('*', function* logger(action) {
    const state = yield select()

    console.log('action', action)
    console.log('state after', state)
  })
}
{% endhighlight %}

take action is pulled by saga. take allow you to write when the action is happen and also handler.

{% highlight js linenos %}
import { select, take } from 'redux-saga/effects'

function* watchAndLog() {
  while (true) {
    const action = yield take('*')
    const state = yield select()

    console.log('action', action)
    console.log('state after', state)
  }
}
{% endhighlight %}

### 2.2 Non-blocking calls

### 2.3 Running tasks in parallel

### 2.4 Starting a race between multiple Effects

### 2.5 Sequencing Sagas using yield*

### 2.6 Composing Sagas

### 2.7 Task cancellation

### 2.8 Redux-saga's fork model

### 2.9 Common Concurrency Patterns

### 2.10 Examples of Testing Sagas

### 2.11 Connecting Sagas to external Input/Output

### 2.12 Using Channels



{: .img_middle_hg}
![JS React Summary]({{site.url}}/assets/images/posts/04 Web/JS/2016-10-03-React入门/JS React Summary.png)


## 2 参考资料 ##
- [Redux-Saga](https://redux-saga.js.org/);
- [Applying the Saga Pattern](https://www.youtube.com/watch?v=xDuwrtwYHu8);
- [Original Paper](http://www.cs.cornell.edu/andru/cs711/2002fa/reading/sagas.pdf);
- [A Saga on Sagas](https://msdn.microsoft.com/en-us/library/jj591569.aspx)

- [可迭代对象 vs 迭代器 vs 生成器](http://python.jobbole.com/86258/)
