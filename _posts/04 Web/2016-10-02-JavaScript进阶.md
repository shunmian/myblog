---
layout: post
title: JavaScript进阶
categories: [04 Web Development]
tags: [javaScript]
number: [3.7.7]
fullview: false
shortinfo: 本文是Javascript的进阶笔记。
---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1 进阶 ##


### 1.0 Scope(作用域) & Closure(闭包)

#### 1.0.1 Scope(作用域)，关键字(`var`,`let`,`const`)

作用域按作用范围分为3级，小的作用范围会优先于大的作用范围：

1. 全局作用域(global scope)，`var`；

2. 函数作用域(function scope)，`var`；

3. 块级或局部作用域(block scope，`const`(不可变)和`let`关键字(可变))；

##### 1.0.1.1 全局作用域vs函数作用域

{% highlight js linenos %}
var a = 1;
function funcA(){
  var a = 2;
  console.log(a)  //输出2
}
funcA()
console.log(a)    //输出1
{% endhighlight %}


##### 1.0.1.2 全局作用域vs块级作用域

{% highlight js linenos %}
//ES6加入了块级作用域，通过关键字`const`和`let`结合块级符号`{}`实现。
//例子2： 全局作用域vs块级作用域
//var
var a = 1;
{
  var a = 2;
  console.log(a)  //输出2
}
console.log(a)    //输出2

//const
var b = 1;
{
  const b = 2;
  console.log(b)  //输出2
  // b = 3 error, 不可变
}
console.log(b)    //输出1

//let
var c = 1;
{
  let c = 2;
  console.log(c)  //输出2
  // a = 3 可变
}
console.log(c)    //输出1
{% endhighlight %}

##### 1.0.1.3 函数作用域vs块级作用域

函数作用域对于块级作用域，和全局作用域对于块级作用域一样。

{% highlight js linenos %}

//
function funcA(){
  var i = 1
  {
    var i = 3
    console.log(i)    //3
  }
  console.log(i)      //3
}
funcA()

function funcB(){
  var i = 1
  {
    let i = 3       //3
    console.log(i)
  }
  console.log(i)    //1
}
funcB()
{% endhighlight %}

函数作用域对于块级作用域的一个特殊用法是`for loop`。请思考下面问题。
> 在块级作用域出现之前，如何用`for loop`实现第1秒打印1，第2秒打印2，第3秒打印3。

{% highlight js linenos %}

//Step 1
for (var i = 0; i < 3; i++){
  setTimeout(()=>{
    console.log(i)
  },(i+1)*1000)
}
//在setTimout函数调用时，i分别是{}里的0，1，2；在setTimout的回调函数打印时，i已经是3，此i被3个块级作用域共享。
//1秒，输出3
//2秒，输出3
//3秒，输出3

//Step 2 可以用IIFE, which stands for immediately invoked function expression.
for (var i = 0; i < 3; i++){
  (function(j){setTimeout(()=>{
    console.log(j)
  },(j)*1000)
  })(i+1)
}
//1秒，输出1
//2秒，输出2
//3秒，输出3

//Step 3 用块级作用域关键字
for (var i = 0; i < 3; i++){
  let j = i+1
  setTimeout(()=>{
    console.log(j)
  },(j)*1000)
}
//1秒，输出1
//2秒，输出2
//3秒，输出3

//Step 4 ES6可以在for loop条件里直接定义块级作用域变量
for (let i = 0; i < 3; i++){
  setTimeout(()=>{
    console.log(j)
  },(j)*1000)
}
//1秒，输出1
//2秒，输出2
//3秒，输出3

{% endhighlight %}

##### 1.0.1.4 Hoisting(变量提升)

> Hoisting is JavaScript's default behavior of moving declarations to the top.

`var a = 2`表面上是1个statement，其实js engine会把它分解成`var a`(声明)和`a = 2`(赋值)两个statement。

{% highlight js linenos %}

function funA(){
  let a;
  a = 2;
  console.log(a)  //2
}
funA()

function funB(){
  let a;
  console.log(a)  //undefined
  a = 2;
}
funB()

function funC(){
  a = 2
  console.log(a)  //2
  let a;
}
funC()

{% endhighlight %}


#### 1.0.2 Closure(闭包)

> Ckisure is when a function is able to remember and access its lexical scope even when that funciton is executing outside its lexical scope.

{% highlight js linenos %}

function foo(){
  var a = 2
  function bar(){
    console.log(a)
  }
  return bar;
}
var baz = foo()
baz() //bar is referecend by baz, and is executed outside its lexical scope and can still access the varialbe a inside the lexical scope, this is a closure

{% endhighlight %}

### 1.1 Function ###

#### 1.1.1 函数的context：`this`参数 ####

`this`或者`self`是OOP里一个非常重要的隐藏参数，通常会在对象调用实例方法的时候隐式传入，如`Objc C`里调用1个对象的方法，会被runtime转换成如下代码。

{% highlight objc linenos %}

//Dog.h
@interface Dog: NSObject
@property(nonatomic, copy) NSString *name;
-(void)say: (NSString*)words;
@end

//Dog.m
@interface Dog()
-(id)initWithName:(NSString)name{
	if(self=[super init]){
		_name = name;
	}
	return self;
}
-(void)say: (NSString*)words {
	NSLog(@"%@ say %@ to you",self.name, words);
};
@end

//调用方法
Dog *dog = [[Dog alloc] initWithName:@"doggy"];
[dog say: @"hello"]

//被OC runtime 转换成 id objc_msgSend(id self, SEL op, ...)
objc_msgSend(dog, @selector(say:),...)

//也就是说由于对象在调用实例A方法的时候有可能会调用实例的C属性和B方法，为了在A方法能获得实例的C属性和B方法的引用，最便捷的办法是传入该实例的引用。因此所有OOP的实例方法都会隐式传入实例的引用到所有实例方法里。
{% endhighlight %}

在`JS`里，类的实例方法的**原型**是`Function`，`function`关键字定义的函数的**原型**也是`Function`，所有`Function`对象都会有一个`context`上下文。这个`context`理解起来不是那么直接，其实本质就是上面提到的`this`或`self`，即对象的引用。

那么`JS`里`this`到底绑定哪个对象呢？答案是不同的情况不一样，但是遵循下面的优先级规则。

1. **R1, new binding**. Called with new? Use the newly constructed object;

2. **R2, explicit binding**. Called with `call` or `apply` or `bind`? Use the specified object;

3. **R3, implicit binding**. Called with a context object owning the call? Use that context object;

4. **R4, default binding**. Default: undefined in **strict mode**, `global` object otherwise.

上述优先级规则初看有点抽象，我们来看下面代码：

{% highlight js linenos %}

function foo(){
  console.log(this.a)
}

//4
var a = 4
foo()                   //输出: 4. R4: default binding，foo在这里调用，调用现场为gloal

//3
var obj = {
  a:3
};
foo.call(obj)           //输出: 3. R3: implicit binding，foo在这里调用，即调用现场obj

//2
var obj = {
  a: 2,
  foo:foo
}
obj.foo()               //输出2: 2. R2: explicit binding，foo在这里调用，即调用现场obj

//1
function foo1(a){
  this.a=a-1
}
var obj = new foo1(2)   //输出1: 1. R1: new binding，foo在这里调用，即调用现场obj
console.log(bar.a)

{% endhighlight %}

如果用1个通用原则来总结上面的优先级，就是`Function`对象执行时的调用现场，即调用栈里调用该`Function`对象的`Function`对象。例如如果调用栈是`f5<-f4<-f3<-f2-f1`，那么f5的`this`指向`f4`。


当`JS`里的函数或者类的实例方法调用(这里统称为函数)的时候，也会隐式传入`this`。如果你想借用这个函数，可以显式通过`apply`或者`call`来传入某实例的引用，或者用`bind`来绑定该函数里某实例的引用。函数的`apply`，`call`和`bind`会在下面具体介绍。

#### 1.1.2 `arguments` ####

`arguments`对象是所有（非箭头）函数中都可用的局部变量。你可以使用`arguments`对象在函数中引用函数的参数。此对象包含传递给函数的每个参数的条目，第一个条目的索引从0开始。

{% highlight js linenos %}
function myConcat(arg0) { //显示声明了第1个参数
  var restArgs = Array.prototype.slice.call(arguments, 1);  //取第1个参数以后的参数
  console.log(restArgs.join(arg0));
}
// returns "red, orange, blue"
myConcat(", ", "red", "orange", "blue");

// returns "elephant; giraffe; lion; cheetah"
myConcat("; ", "elephant", "giraffe", "lion", "cheetah");

// returns "sage. basil. oregano. pepper. parsley"
myConcat(". ", "sage", "basil", "oregano", "pepper", "parsley");
{% endhighlight %}

#### 1.1.3 `bind`,`call`, `apply` ####

##### 1.1.3.1 函数调用：`call`, `apply`

`call`和`apply`都是为了改变某个函数运行时的 context 即上下文而存在的，换句话说，就是为了改变函数体内部`this` 的指向。因为 JavaScript 的函数存在「定义时上下文」和「运行时上下文」以及「上下文是可以改变的」这样的概念。二者的作用完全一样，只是接受参数的方式不太一样。例如，有一个函数 func1 定义如下：`var func1 = function(arg1, arg2) {};`就可以通过 `func1.call(this, arg1, arg2);` 或者`func1.apply(this, [arg1, arg2]);`来调用。其中`this`是你想指定的上下文，他可以任何一个JavaScript对象(JavaScript 中一切皆对象)，`call`需要把参数按顺序传递进去，而`apply`则是把参数放在数组里。

引用[知乎](https://www.zhihu.com/question/20289071)上的1个便于记忆的小故事。

{% highlight js linenos %}

猫吃鱼，狗吃肉，奥特曼打怪兽(小怪兽和大怪兽)。

有天狗想吃鱼了 

猫.吃鱼.call(狗，鱼)
猫.吃鱼.apply(狗，[鱼])

狗就吃到鱼了

猫成精了，想打怪兽

奥特曼.打怪兽.call(猫，小怪兽，大怪兽)
奥特曼.打怪兽.call(猫，[小怪兽，大怪兽])

{% endhighlight %}

##### 1.1.3.2 函数绑定：`bind`

再借用上面那个小故事。

{% highlight js linenos %}

猫吃鱼，狗吃肉，奥特曼打怪兽(小怪兽和大怪兽)。

有天狗想吃鱼了 

猫.吃鱼.call(狗，鱼)
猫.吃鱼.apply(狗，[鱼])
猫.吃鱼.bind(狗)(鱼) //等价于 狗吃鱼 = 猫.吃鱼.bind(狗)；狗吃鱼(鱼)  

狗就吃到鱼了

猫成精了，想打怪兽

奥特曼.打怪兽.call(猫，小怪兽，大怪兽)
奥特曼.打怪兽.call(猫，[小怪兽，大怪兽])
奥特曼.打怪兽.bind(猫)(小怪兽，大怪兽) //等价于 猫打怪兽 = 奥特曼.打怪兽.bind(猫)；猫打怪兽(小怪兽，大怪兽)

{% endhighlight %}

因此bind还用于部分函数参数绑定的作用

{% highlight js linenos %}
奥特曼.打怪兽.bind(猫，小怪兽)(大怪兽) //等价于 猫打怪兽 = 奥特曼.打怪兽.bind(猫，小怪兽)；猫打怪兽(大怪兽)
{% endhighlight %}


### 1.2 Object 原型链 ###

TODO。


### 1.3 Aynchronoous ###

#### 1.3.1 Eventloop

It's important to note `setTimeout(...)` doesn't put your callback on the eventloop queue. Instead, it sets up a timer, when the timer expires, the environment places your callback into the event loop, such that some future tick will pick it up and execute it. So you are guaranteed that your callback won't fire before the itme interval you specify, but it can happen at or after that time, depending on the state of the event queue.

because of JS's single-threading nature, which leads to **function level atomic**, the code inside of `foo()` (and `bar()`) function is atomic, which means once `foo()` starts running, the entirety of its code will finish before any of the code in `bar()` can run. This is called "run-to-completion" behavior.

{% highlight js linenos %}
var a = 1;
var b = 2;

function foo(){
	a++;
	b = b * a;
	a = b + 3
}

function bar(){
	b--;
	a = 8 * b;
	b = a * 2;
}

ajax("http://some.url.1", foo);
ajax("http://some.url.2", foo);

{% endhighlight %}

Becase `foo()` can't be interrupted by `bar()` and `bar()` can't be interrupted by `foo()`, this program only has two possible outcomes depending on which starts running first -- if threading were present, and the individual statements in `foo()` and `bar()` could be interleaved, the number of possible outcomes would be greatly increased!

#### 1.3.2 Callback

callback hell, deep nesting inside multiple callback

{% highlight js linenos %}
listen("click", function handler(evt)){
	setTimeout( function request(){
		ajax("http://some.url.1", function response(text){
		if (text == "hello") {
			hander();
		} else if (text == "world") {
			request();
		}
	});
	},500);
});

{% endhighlight %}

如何避免 callback hell. 一种方法是Promise。                                                                                                                                                                                                                                                       
#### 1.3.3 `Promise` ####

##### 1.3.3.1 Promise API：

{% highlight js linenos %}
//1. Promise构造函数,3阶函数，resolve和rejct是1阶；它们作为函数的输入参数，该函数是2阶级；而new Promise将该2阶函数作为输入函数，因此new Promise是3阶函数。
const getData1 = () => new Promise((resolve,reject)=>{
  console.log('getData1 promise started')
  const a = Math.floor(Math.random() * 20);
  if(a%2==0){
    console.log('getData1: before resolve')
    resolve(a)
    console.log('getData1: after resolve')
  }else{
    console.log('getData1: before reject')
    reject(new Error('Odd'))
    console.log('getData1: after reject')
  }
})

//2.1 Promise.resolve()。是一个语法糖，快速产生1个Promise实例，resovle的结果是Promise.resolve()的输入。因此Promise.resolve(1)等价于

Promise.resolve(1);
(() => new Promise((resolve,reject)=>{
  resolve(1)
}))();

//2.2 Promise.reject()同理等价于
Promise.reject(new Error('error'));
(() => new Promise((resolve,reject)=>{
  reject(new Error('error'));
}))();

//3.1 Promise.all()，输入是Promise实例的数组，当数组里所有Promise实例resolve或者有一个reject的时候，就执行下面的then或者reject

Promise.all([
	Promise.resolve(1),
	Promise.resolve(2),
])
.then(([data1, data2]) => {
	console.log('data1: ', data1, 'data2: ',data2)
})

//3.2 Promise.race()，输入是Promise实例的数组，当数组里有一个Promise实例resolve或者有一个reject的时候，就执行下面的then或者reject

Promise.race([
	Promise.resolve(1),
	Promise.resolve(2),
])
.then((data) => {
	console.log('data: ', data)
})


//4.1 Promise.prototype.then() 是Promise最confuse的函数，会在下面细讲 

//4.2 Promise.prototype.catch() 是对reject的实现，这里不细说，需要注意的是，当then()或者catch()之后，还可以进行then()，这个then()类似于Python里的try, catch之后的finally。

const getData1 = () => new Promise((resolve,reject)=>{
  console.log('getData1 promise started')
  const a = Math.floor(Math.random() * 20);
  if(a%2==0){
    console.log('getData1: before resolve')
    resolve(a)
    console.log('getData1: after resolve')
  }else{
    console.log('getData1: before reject')
    reject(new Error('Odd'))
    console.log('getData1: after reject')
  }
})

getData1()                  
.then(a=>{
  console.log('last then: ', a)
})
.catch(err=>{                 
  console.log(err)
})
.then(()=>{                       //类似python的finally  
  console.log('getData1 finished')
})

{% endhighlight %}






##### 1.3.3.2 Promise 3阶段：creator，instantiation，

`Promise`的consufion主要来自对于其三阶段的不熟悉。三阶段在代码中的位置并不总是显示分离，有时候会混合。

###### 1.3.3.2.1 3阶段分离：基本`Promise`用法

首先来看最简单的分离的三阶段的实现.

{% highlight js linenos %}
//Promise creator
const getData1 = () => new Promise((resolve,reject)=>{
  console.log('getData1 promise started')
  const a = Math.floor(Math.random() * 20);
  if(a%2==0){
    console.log('getData1: before resolve')
    resolve(a)
    console.log('getData1: after resolve')
  }else{
    console.log('getData1: before reject')
    reject(new Error('Odd'))
    console.log('getData1: after reject')
  }
})

getData1()                    //Promise instantiation
.then((a)=>{                  //Promise consumption
  console.log('Even: ',a)
})
.catch(err=>{                 //Promise consumption
  console.log(err)
})
{% endhighlight %}

上述代码中：

1. `getData1`是1个Promise工厂，我们称之为`creator`，返回1个`Promise`实例。

2. 当`getData1()`时，产生1个`Promise`实例，我们称之为`instantiation`。

3. 对该`Promise`实例的`then`和`catch`是对其产生结果的`consumption`。


###### 1.3.3.2.1 3阶段混合：`Promise Chain`用法

我们再来看mix的三阶段，在`Promise Chain`的时候。

{% highlight js linenos %}
//Promise creator
const getData1 = () => new Promise((resolve,reject)=>{
  console.log('getData1 promise started')
  const a = Math.floor(Math.random() * 20);
  if(a%2==0){
    console.log('getData1: before resolve')
    resolve(a)
    console.log('getData1: after resolve')
  }else{
    console.log('getData1: before reject')
    reject(new Error('Odd'))
    console.log('getData1: after reject')
  }
})

const getData2 = ()=> new Promise((resolve,reject)=>{
  const a = Math.floor(Math.random() * 20);
  if(a%2==0){
    console.log('getData2: before resolve')
    resolve(a)
    console.log('getData2: after resolve')
  }else{
    console.log('getData2: before resolve')
    resolve(new Error('Odd'))
    console.log('getData2: after resolve')
  }

})

getData1()                    //Promise instantiation
.then(getData2)               // getData2 is a promise creator, after getData1()'s promise resolved, it start to execute getData2() to instantiate a new promise, here, the creator and instantiation is mixed
.then(a=>{
  console.log(a)
})
.catch(err=>{                 //Promise consumption
  console.log(err)
})

/*Output
getData1 promise started
getData1: before resolve
getData1: after resolve
getData2 promise started
getData2: before resolve
getData2: after resolve
18
*/
{% endhighlight %}

在`line 31`的时候，getData2产生的Promise结束时，才会执行`line 32`或`line 35`的consumption，并且consumption的data或者error来自于`line 31`。那么问题来了，如果将`line 31`改成`then(()=>{ getData2() })`会有什么结果呢。为了更清楚的显示不同，我们给getData2增加了timeout。

{% highlight js linenos %}
//Promise creator
const getData1 = () => new Promise((resolve,reject)=>{
  console.log('getData1 promise started')
  const a = Math.floor(Math.random() * 20);
  if(a%2==0){
    console.log('getData1: before resolve')
    resolve(a)
    console.log('getData1: after resolve')
  }else{
    console.log('getData1: before reject')
    reject(new Error('Odd'))
    console.log('getData1: after reject')
  }
})

const getData2 = ()=> new Promise((resolve,reject)=>{
  console.log('getData2 promise started')
  setTimeout(()=>{
      const a = Math.floor(Math.random() * 20);
  if(a%2==0){
    console.log('getData2: before resolve')
    resolve(a)
    console.log('getData2: after resolve')
  }else{
    console.log('getData2: before resolve')
    resolve(new Error('Odd'))
    console.log('getData2: after resolve')
  }
  }, 3000)
})

getData1()                    //Promise instantiation
.then(()=>{										// instead of put getData2, which is a promise creator function, we exectue the promise creator function inside then and return nothing.
  getData2()
  })               
.then(a=>{
  console.log('last then: ', a)
})
.catch(err=>{                 //Promise consumption
  console.log(err)
})

/*
getData1 promise started
getData1: before resolve
getData1: after resolve
getData2 promise started
last then:  undefined
//3 seconds later
getData2: before resolve
getData2: after resolve
*/

{% endhighlight %}

可以清楚的看到，当只执行Promise creator `getData2()`而不将其产生的`Promise`实例返回的话，原来的promise chain不会等待`getData2()`产生的Promise`resolve`或`reject`，而是直接继续下个`then`(`line 36`)。若将`line 34`改成`return getData2()`，则输出结果和上一个例子一样(除了3秒后)，即`then`里如果是Promise creator function的函数名，则该函数产生的Promise实例会自动返回给`then`。

这个例子清楚的显示了`then`函数的**承上启下**的本质：

1. **承上**，即对前一个Promise实例resolve的时候的结果的运用，**consumption**；

2. **启下**，即自己对于之后的`then`的角色，**creator，instantiation(not return)**还是**creator, instantiation(return)**。

理清了`then`函数的本质，Promise看起来也不是那么难以驾驭了。


##### 1.3.3.3 Native `Promise`####

##### 1.3.3.4 ThirdParty `Promise`: `bluebird`####

#### 1.3.4 `Generator` + `Promise`

##### 1.3.4.1 `Generator`

阅读`Generator`的代码时，`yield`关键字有时候并不是那么直观，一方面是由于写generator太少，另一方面是yield并不像`return`那么直接。解决的方法一是多写generator；二是可认为`yield`是`short return`(短返回，即可以resume的返回)，这样一来就很直观，yield的值是后面的值，和return一样，但是可以resume。

**Generator函数**: 格式是`function* () { yield ...}`，返回`Generator`

**Generator**: 一种特殊的`Iterator`

**Iterator**: 一种协议，有`next`方法，该方法返回`{value,done}`。

**Iterable**: 一种协议，即有方法返回1个`Iterator`。


所以以上4个概念的核心是`Iterator`，其拥有2种特性：

1. 产生无限序列

2. 便于遍历

而Generator是特殊的`Iterator`，除了拥有以上两个特性之外，还有1个特性：

3. 可以暂停(`yield`)/恢复(`next`)函数执行，因此也被称为协程(`coroutine`)。

下面用一张图表示上面4个概念以及相关概念的关系。

{: .img_middle_lg}
![Generator vs Iterator](/assets/images/posts/04 Web/JS/2016-10-02-JavaScript进阶/Generator vs Iterator.png)

##### 1.3.4.1 `Generator yield Promise` 

`Callback`有hell, `Promise` at least one level nest, can we write async function like sync style? Yes, use `Generator` + `Promise`。

{% highlight js linenos %}
function foo(){
  return fetch('https://jsonplaceholder.typicode.com/posts')
          .then(res=>res.json())
}

function *main(){
  try{
    res = yield foo()
    console.log(res)
  }catch(err){ 
    console.log(err)
  }
}

//utility to make *main work
const it = main()
p = it.next().value
p
.then(res=>it.next(res))
.catch(err=>it.throw(err))
{% endhighlight %}

对于上述utility，可以写一个函数(`coroutine`)来封装它

{% highlight js linenos %}
function run(gen){
  var args = [].slice.call(arguments, 1), it;
  
  //initialize the generator in the current context
  it = gen.apply(this, args);
  
  //return a promise for the generator completing
  return Promise.resolve()
  .then(function handleNext(value){
    // run to the next yielded value
    var next = it.next(value)
    return (function handleResult(next){
      //generator has completed running?
      if(next.done){
        return next.value
      }
      // otherwise keep going
      else{
        return Promise.resolve(next.value)
        .then(
          // resume the async loop on success, sending the resolved value back into the generator
          handleNext,
          // if 'value' is a rejected promise, propagate error back into the generator for its own error handling
          function handleErr(err){
          return Promise.resolve(it.throw(err))
            .then(handleResult)
        })
      }
    })(next)
  })
}

run(main)
{% endhighlight %}

#### 1.3.5 `async`,`await` ####

ES7 将 `Generator` + `Promise` 封装成了关键字`aysnc`和`await`。因此上述main函数只要写成如下即可，无需utility函数`run`。

{% highlight js linenos %}
async function main(){
  try{
    res = await foo()
    console.log(res)
  }catch(err){ 
    console.log(err)
  }
}

main()
{% endhighlight %}

因此可以认为`aysnc`和`await`比`Generator`+`Promise`+`coroutine`更为正式，是JS ES7 内置的关键字。但是上述两种方法都可以以sync方式code async函数。 

### 1.4 ES6

#### 1.4.1 Syntax

#### 1.4.2 Organization

#### 1.4.3 Async Flow Control

#### 1.4.4 Collections

#### 1.4.5 API Addictions

#### 1.4.6 Meta Programming

#### 1.4.7 Beyond ES6

### 1.5 Types & Grammer

#### 1.5.1 Types

#### 1.5.2 Values

#### 1.5.3 Natives

#### 1.5.4 Coercion

#### 1.5.5 Grammar


## 2 参考资料 ##
- [《You Don't Know JS Series》](https://www.amazon.com/You-Dont-Know-Js-Book/dp/B01AY9P0P6);
- [《JavaScript: The Good Parts》](https://www.amazon.com/JavaScript-Good-Parts-Douglas-Crockford/dp/0596517742/ref=sr_1_2?s=books&ie=UTF8&qid=1512881319&sr=1-2&keywords=javascript+the+good+part);
