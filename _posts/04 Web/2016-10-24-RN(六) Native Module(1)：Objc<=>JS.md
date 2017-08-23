---
layout: post
title: RN(六) Native Module(1)：Objc<=>JS
categories: [04 Web Development]
tags: [Redux]
number: [3.7.7]
fullview: false
shortinfo: 本文是对Facebook的React框架的introduction。
---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1  Objc和JS的通信##

### 1.1 Code Example ###

#### 1.1.1 JS => ObjC ####

> 如何导出一个ObjC Native Module使得在JS侧可以调用？

**ObjC侧**
1. 遵循`RCTBridgeModule`协议；
2. 实现协议的两个方法。`RCT_EXPORT_MODULE()`，表示暴露给JS侧的Module名，参数为空时和ObjC侧一样(这里是`RNOC2JSTester`)；`RCT_EXPORT_METHOD(method)`，省略返回值，若要传回JS返回值，必须以回调(`RCTResponseSenderBlock`)的方式，回调参数遵循JS习惯，第一个是`error`，第二个是`data`。

{% highlight objc linenos %}
//RNOC2JSTester.h
#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
@interface RNOC2JSTester : NSObject<RCTBridgeModule> 
@end

//RNOC2JSTester.m
#import "RNOC2JSTester.h"
@implementation RNOC2JSTester

RCT_EXPORT_MODULE()
RCT_EXPORT_METHOD(sayHi:(NSString *)text complete:(RCTResponseSenderBlock)callback)
{
  NSString *greeting = [NSString stringWithFormat:@"Hello,Hi, %@",text];
  callback(@[[NSNull null],greeting]);
}
{% endhighlight %}

**JS侧：**

1. 调用Module：`NativeModules.RNOC2JSTester`；
2. 调用Module里的方法：`NativeModules.RNOC2JSTester.sayHi(name,callback)`。

{% highlight js linenos %}

import { NativeModules} from 'react-native';

const RNOC2JSTester = NativeModules.RNOC2JSTester;

RNOC2JSTester.sayHi(name, (error,data)=>{
	if(!error){
		console.log(data)
	}else{
		console.log(error)
	}
});

{% endhighlight %}

#### 1.1.2 JS <= ObjC ####

> 如何让Objc侧发送消息给JS侧？

**ObjC侧：**
1. Objc侧需要继承`RCTEventEmitter`：实现`-(NSArray<NSString *> *)supportedEvents`方法，返回暴露给JS侧的event数组，这里是`eventFromSayHi`event；并且在某个方法里实现`-(void)sendEventWithName:(NSString *)name body:(id)body`，以供ObjC某一时刻调用。

{% highlight objc linenos %}
//RNOC2JSTester.h
#import <Foundation/Foundation.h>
#import <React/RCTEventEmitter.h>
#import <React/RCTBridgeModule.h>
@interface RNOC2JSTester : RCTEventEmitter<RCTBridgeModule>
@end

//RNOC2JSTester.m
#import "RNOC2JSTester.h"
@implementation RNOC2JSTester

RCT_EXPORT_MODULE()
-(void)greeting:(NSString *)text{
  [self sendEventWithName:@"eventFromSayHi" body:@{@"text":text}];
}

- (NSArray<NSString *> *)supportedEvents{
  return @[@"eventFromSayHi"];//有几个就写几个
}

{% endhighlight %}

**JS侧：**

1. 调用模块，并生成`NativeEventEmitter`实例；
2. `NativeEventEmitter`实例添加监听者(当`Objc`侧有事件到达时，监听的callback就会触发)，移除监听者。

{% highlight js linenos %}
import { NativeModules, NativeEventEmitter } from 'react-native';

const RNOC2JSTester = NativeModules.RNOC2JSTester;
const eventEmitter = new NativeEventEmitter(RNOC2JSTester)
const listner = eventEmitter.addListener("eventFromSayHi", (response) => {
           console.log("event from Say Hi: " + response.text);
 })
listner.remove()
{% endhighlight %}

#### 1.1.3 JS <=> ObjC ####

>如何使得JS侧和ObjC侧相互通信。

这里我们将上面两者结合起来，用JS调用ObjC的方法，触发event，使得JS侧的监听回调被调用。更近一步，封装成JS的class，便于JS侧的使用。

**ObjC侧：**

{% highlight objc linenos %}
//RNOC2JSTester.h
#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RNOC2JSTester : RCTEventEmitter<RCTBridgeModule>
@end

//RNOC2JSTester.m
#import "RNOC2JSTester.h"
@implementation RNOC2JSTester
RCT_EXPORT_MODULE()
RCT_EXPORT_METHOD(sayHi:(NSString *)text complete:(RCTResponseSenderBlock)callback){
  NSString *greeting = [NSString stringWithFormat:@"Hello,Hi, %@",text];
  callback(@[[NSNull null],greeting]);
}

RCT_EXPORT_METHOD(eventFromSayHi:(NSString *)text){
  [self sendEventWithName:@"eventFromSayHi" body:@{@"text":text}];
}

- (NSArray<NSString *> *)supportedEvents{
  return @[@"eventFromSayHi"];//有几个就写几个
}
@end
{% endhighlight %}

**JS侧：**

{% highlight js linenos %}
import { NativeModules, NativeEventEmitter } from 'react-native';
const RNOC2JSTester = NativeModules.RNOC2JSTester;
const eventEmitter = new NativeEventEmitter(RNOC2JSTester)

class OC2JSTester {
   constructor() {
       this.addSayHiEventListener()
   }

   sayHi(name, handler) {
       RNOC2JSTester.sayHi(name, handler);
   }
   eventFromSayHi(name){
       RNOC2JSTester.eventFromSayHi(name);
   }

   addSayHiEventListener() {
       eventEmitter.addListener("eventFromSayHi", (response) => {
           console.log("event from Say Hi: " + response.text);
       })
   }
}

export { OC2JSTester }

//在RN中通过Button触发。
import React, { Component } from 'react'
import {
   View,
   Button,
   NativeModules,
} from 'react-native'
import { OC2JSTester } from '../lib/OC2JSTester'

export default class Balance extends Component {
   constructor(props){
       super(props)
       this.tester = new OC2JSTester()
   }

   handleBTNPresses() {
       this.tester.greeting("Jack!")
   }
   render() {
       return (
           <View>
               <Button title="call test" onPress={()=>{
                   this.handleBTNPresses()
                   }}></Button>
           </View>
       )
   }
}
//输出：event from Say Hi: Jack!
{% endhighlight %}

最后留下一个问题，**JS<=>ObjC**和第一种**JS=>ObjC**的回调有什么区别和联系，是否回调只是**JS<=>ObjC**的语法糖？

### 1.2 源码分析 ###

## 2 参考资料 ##
- [React](https://facebook.github.io/react/);
- [Learning React](https://www.amazon.com/Learning-React-Kirupa-Chinnathambi/dp/0134546318);
