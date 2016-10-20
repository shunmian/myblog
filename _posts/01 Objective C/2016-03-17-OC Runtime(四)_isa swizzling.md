---
layout: post
title: OC Runtime(四)： isa Swizziling
categories: [01 Objective-C]
tags: [isa Swizzling]
number: [0.14.1.2]
fullview: false
shortinfo: 在Objective C中, Key Value Observing 是用来对Observing Pattern的Apple官方实现。 它的实现原理用的是isa Swizzling。但是apple对其细节没有多讲。本文用三种方式来实现Oberving Pattern：普通设计模式, isa Swizzling和Method Swizzling。希望通过本文能让您对Observing Pattern有一个全面的认识。
---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1. Observing Pattern 介绍 ##

Obeserving Pattern 是Gang Of Four里面提到的24种面向对象设计模式之一。使得subject(被观察者)的iVar改变的时候，observer(观察者)能够得到提醒。这里有一个tricky的地方是beginner刚开始思考这个问题的时候，observer如果一直主动观察着subject iVar的变化，那observer就干不了其他事情了，或者另开一个线程。而问题的解决方法其实是observer被动接受subject发出的iVar的变化， 即subject拥有observer的引用，在iVar的setter里提醒observer。

{: .img_middle_lg}
![SendingMessage](/assets/images/posts/2016-03-17/Observer Pattern.png)

上图是Observing Pattern的UML。Subject是一个接口，声明了三个方法：

1. addObserver(Observer), 注册observer(即将observer加入到observers数组)；
2. notify(), 通知observers(observers数组里的每个observer都调用其update()方法)；
3. removeObserver(Observer), 注销observer(即observers数组里删除observer)。

Observer也是一个接口，声明了一个方法：update(),用来Subject iVar改变时响应。 

ConcreteSubjectA实现了Subject接口，在iVar的setter里加了notify(), 因此在每一次iVar值改变时，都会提醒observers里的每一个observer相应update()。ConcreteObserver实现了Observer接口。这个UML理解起来比较清晰。

## 2. 三种实现 ##

我们知道Objective C对 Observer Pattern的实现是用Key Value Observeing。我们下面用三种方法在Objective C中实现Observer Pattern：普通实现(即按照上面UML图来实现)， isa Swizzling实现KVO， method Swizzling实现KVO。

### 2.1 普通实现 ###

普通实现比较简单，代码如下

{% highlight objc linenos %}

@implementation ConcreteSubjectA

-(NSMutableArray *)Observers{
    if(!_Observers){
        _Observers = [NSMutableArray array];
    }
    return _Observers;
}

-(void)LAL_addObserver:(id<LAL_Observer>)observer WithBlock:(LALObservingBlock)block{
    [observer setObservingBlock:block];
    [self.Observers addObject:observer];

}

-(void)LAL_notify{
    for (id<LAL_Observer> observer in self.Observers) {
        [observer LAL_update];
    }
}

-(void)LAL_removeObserver:(id<LAL_Observer>)observer{
    [self.Observers removeObject:observer];
}

-(void)setAge:(NSNumber *)age{
    _age = age;
    [self LAL_notify];//iVar age 改变后通知Observers.
}
@end

{% endhighlight %}

在这里，重写age的setter，加入通知Observers是关键。

### 2.2 KVO实现: isa Swizzling ###
对于熟悉Key Value Observing API的同学来说，“订阅”-“响应”-“取消订阅” 也对应着上述`addObserver(Observer)`,`notify()`和`removeObserver(Observer)`这三个步骤，具体请参考[Key Value Observing]({{site.baseurl}}/objective-c/2016/02/18/Key-Value-Observing.html){:target="_blank"}。


1. 订阅：`- (void)addObserver:forKeyPath:options:context:`


2. 响应：`- (void)observeValueForKeyPath: ofObject:change:context:`

3. 取消订阅：`- (void)removeObserver:forKeyPath:`


令人疑惑的是KVO缺少改写Subject iVar setter这一步，而这一步正是Observing Pattern的关键。Apple是如何做到这一步的呢，我们来看下[Introduction to Key-Value Observing Programming Guide](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/KeyValueObserving/Articles/KVOImplementation.html#//apple_ref/doc/uid/20002307-BAJEAIEE){:target="_blank"}对于KVO实现原理的介绍：

><b>Key-Value Observing Implementation Details</b>: Automatic key-value observing is implemented using a technique called isa-swizzling.The isa pointer, as the name suggests, points to the object's class which maintains a dispatch table. This dispatch table essentially contains pointers to the methods the class implements, among other data.When an observer is registered for an attribute of an object the isa pointer of the observed object is modified, pointing to an intermediate class rather than at the true class. As a result the value of the isa pointer does not necessarily reflect the actual class of the instance.You should never rely on the isa pointer to determine class membership. Instead, you should use the class method to determine the class of an object instance.

Apple用了一种isa Swizzling的方法，创建了一个中间类，使得原来的类变成中间类的父类，原来的实例变成中间类的实例;并改写了其class方法，返回依然是原来的类用来欺骗开发者。这样的做法有两个好处：

1. 开发者专注于“订阅”-“响应”-“取消订阅”API,而无需关注重写iVar setter， 重写由KVO自己完成；
2. isa Swizzling创建了中间类，因此原来的类的实现细节不会由于KVO而改变, KVO的改变体现在中间类里。这体现了封装和扩展的思想。

下面我们就来自行实现以下KVO用isa Swizzling的方法。我们给NSObject创建一个KVO匿名类，里面有两个方法，订阅和取消订阅,并且声明了一个LALKVOBlock类型，用来响应(官方KVO没有支持block或者selector,所有响应逻辑都在`-(void)observeValueForKeyPath:ofObject:change:context:`里执行，这也是官方KVO广为诟病的一个原因)：

{% highlight objc linenos %}
#import <Foundation/Foundation.h>
typedef void (^LALKVOBlock)(id obsever, id subject, NSString *keyPath, id oldValue, id newValue);

@interface NSObject (LALKVO)

-(void)LALKVO_addObserver:(id)observer ForKeyPath:(NSString *)keyPath withBlock:(LALKVOBlock)block;

-(void)LALKVO_removeObserver:(id)observer ForKeyPath:(NSString *)keyPath;

@end
{% endhighlight %}


`-(void)LALKVO_addObserver:ForKeyPath:withBlock:`主要逻辑如下:

1. keyPath是否有效;
2. 若有效则看中间类是否存在,若不存在则创建(实例isa指向中间类，中间类的super_class指向原类，并改写实例的class方法，使其指向原类)；
3. keyPath对应的setter中间类是否已经重写，若没有则重写；
4. 增加observer到observers数组。

{% highlight objc linenos %}
-(void)LALKVO_addObserver:(id)observer ForKeyPath:(NSString *)keyPath withBlock:(__autoreleasing LALKVOBlock)block{
    //assume the original class is Person
    Class originalClass = [self class];
    
    //step1: keyPath is valid or not.
    SEL keyPathSetter = NSSelectorFromString(setterForGetter(keyPath));
    Method keyPathSetterMethod = class_getInstanceMethod(originalClass, keyPathSetter);
    if(!keyPathSetterMethod){
        NSLog(@"the keyPath is not valid!");
        return;
    }
    
    //step2: intermediate Class exist or not, if not create it LALKVO_Person as the intermediate Class.
    const char *originalClassName = class_getName(originalClass);
    const char *intermediateClassName = getIntermediateClassName(originalClassName);
    if(!objc_getClass(intermediateClassName)){
        createIntermediateClass(self, originalClassName, intermediateClassName);
    }
    
    //step3: override the setter in LALKVO_Person.
        //LALKVO_Person 是否有setter
    Class intermediateClass = object_getClass(self);

    if(!hasSelector(self, keyPathSetter)){
        //没有则创建.
        Method originalKeyPathSetterMethod = class_getInstanceMethod(originalClass, keyPathSetter);
        const char* types = method_getTypeEncoding(originalKeyPathSetterMethod);
        class_addMethod(intermediateClass, keyPathSetter, (IMP)kvo_setter, types);
    }
    //setp4: add the observer to the subject.
    NSMutableArray *observeInfoArray = objc_getAssociatedObject(self, kLALKVOObserverInfoArray);
    if(!observeInfoArray){
        observeInfoArray = [[NSMutableArray alloc] init];
        objc_setAssociatedObject(self, kLALKVOObserverInfoArray, observeInfoArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    ObserveInfo *observeInfo = [[ObserveInfo alloc] initWithSubject:self keyPath:keyPath observer:observer block:block];
    if(!observeInfoArrayContainsObserveInfo(observeInfoArray, observeInfo)){
        [observeInfoArray addObject:observeInfo];
    }
}
{% endhighlight %}

其中最关键的是第三步，获取原类的setter IMP,执行它，代码如下:
{% highlight objc linenos %}
void kvo_setter(id obj, SEL _cmd, id newValue){
    
    NSString *setterName = NSStringFromSelector(_cmd);
    NSString *getterName = getterForSetter(setterName);
    
    //get the originalClass getter IMP and implement it.
    Method getterMethodFromOriginalClass = class_getInstanceMethod(class_getSuperclass(object_getClass(obj)), NSSelectorFromString(getterName));
    IMP getterIMPFromOriginalClass = method_getImplementation(getterMethodFromOriginalClass);
    id (*getterIMPFromOriginalClassCasted)(id,SEL) = (void *)getterIMPFromOriginalClass;
    id oldValue = getterIMPFromOriginalClassCasted(obj,NSSelectorFromString(getterName));
    
    
    //get the originalClass setter IMP, and implement it.
    Method setterMethodFromOriginalClass = class_getInstanceMethod(class_getSuperclass(object_getClass(obj)), _cmd);
    IMP setterIMPFromOriginalClass = method_getImplementation(setterMethodFromOriginalClass);
    void (*setterIMPFromOriginalClassCasted)(id, SEL, id) = (void *)setterIMPFromOriginalClass;
    setterIMPFromOriginalClassCasted(obj, _cmd, newValue);
    
    //call the block for each observer.
    NSMutableArray *observerInfoArray = objc_getAssociatedObject(obj, kLALKVOObserverInfoArray);
    for (ObserveInfo *observeInfo in observerInfoArray){
        if([observeInfo.keyPath isEqualToString:getterName]){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                observeInfo.block(observeInfo.observer, observeInfo.subject, observeInfo.keyPath, oldValue, newValue);
            });
        }
    }
}
{% endhighlight %}

源码在这里。

### 2.3 KVO实现: Method Swizzling ###

不知道同学们注意到没有，其实isa Swizzling实现KVO的本质是创建中间类，然后在中间类的setter里用Method Swizzling重写。Method Swizzling的介绍请见传送门[OC Runtime(三)： Method Swizziling]({{site.baseurl}}/objective-c/2016/03/16/OC-Runtime(三)_method-swizzling.html){:target="_blank"}。创建中间类的好处是使得原类的实现不被KVO改变。实际上我们完全可以不用isa Swizlling而只用Method Swizzling来实现KVO, 代码如下:


{% highlight objc linenos %}
#import <Foundation/Foundation.h>
typedef void (^LALKVOBlock)(id obsever, id subject, NSString *keyPath, id oldValue, id newValue);
static NSNumber *LALKVO_overrideKeyPathSetterFlag;
static void (*originalSetterIMP)(id, SEL,id);

@interface NSObject (LALKVO)

-(void)LALKVO_addObserver:(id)observer ForKeyPath:(NSString *)keyPath withBlock:(LALKVOBlock)block;
-(void)LALKVO_removeObserver:(id)observer ForKeyPath:(NSString *)keyPath;

+(NSNumber *)overrideFlag;
+(void)setOverrideFlag:(NSNumber *)flag;
@end

{% endhighlight %}

我们增加了一个静态类变量来标志setter是否被重写，并且实现了该类变量的setter和getter。同时我们设置了一个静态函数指针用来存储原来的setter的实现。

{% highlight objc linenos %}
-(void)LALKVO_addObserver:(id)observer ForKeyPath:(NSString *)keyPath withBlock:(__autoreleasing LALKVOBlock)block{
    
    Class originalClass = object_getClass(self);
    //step1: keyPath is valid or not
    SEL keyPathSetter = NSSelectorFromString(setterForGetter(keyPath));
    Method keyPathSetterMethod = class_getInstanceMethod(originalClass, keyPathSetter);
    if(!keyPathSetterMethod){
        NSLog(@"the keyPath is not valid!");
        return;
    }
    //step2: override the setter class, 查看overrideFlag
        //self 是否已经改写setter
    if(![[object_getClass(self) overrideFlag] boolValue]){
        //获取original Setter Method and IMP
        Method originalKeyPathSetterMethod = class_getInstanceMethod(originalClass, keyPathSetter);
        originalSetterIMP =(void *) method_getImplementation(originalKeyPathSetterMethod);

        method_setImplementation(originalKeyPathSetterMethod, (IMP)kvo_setter);
    }
    
    // setp3: add the observer to the subject.
    NSMutableArray *observeInfoArray = objc_getAssociatedObject(self, kLALKVOObserverInfoArray);
    if(!observeInfoArray){
        observeInfoArray = [[NSMutableArray alloc] init];
        objc_setAssociatedObject(self, kLALKVOObserverInfoArray, observeInfoArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    ObserveInfo *observeInfo = [[ObserveInfo alloc] initWithSubject:self keyPath:keyPath observer:observer block:block];
    if(!observeInfoArrayContainsObserveInfo(observeInfoArray, observeInfo)){
        [observeInfoArray addObject:observeInfo];
    }
}
{% endhighlight %}

kvo_setter的code如下:

{% highlight objc linenos %}
void kvo_setter(id obj, SEL _cmd, id newValue){
    
    NSString *setterName = NSStringFromSelector(_cmd);
    NSString *getterName = getterForSetter(setterName);
    
    //get the class getter IMP, and implement it.
    Method getterMethodFromOriginalClass = class_getInstanceMethod(object_getClass(obj), NSSelectorFromString(getterName));
    IMP getterIMPFromOriginalClass = method_getImplementation(getterMethodFromOriginalClass);
    id (*getterIMPFromOriginalClassCasted)(id,SEL) = (void *)getterIMPFromOriginalClass;
    id oldValue = getterIMPFromOriginalClassCasted(obj,NSSelectorFromString(getterName));
    
    //get the class setter IMP, and implement it.
    originalSetterIMP(obj, _cmd, newValue);
    
    NSMutableArray *observerInfoArray = objc_getAssociatedObject(obj, kLALKVOObserverInfoArray);
    for (ObserveInfo *observeInfo in observerInfoArray){
        if([observeInfo.keyPath isEqualToString:getterName]){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                observeInfo.block(observeInfo.observer, observeInfo.subject, observeInfo.keyPath, oldValue, newValue);
            });
        }
    }
    LALKVO_overrideKeyPathSetterFlag = [NSNumber numberWithBool:YES];
}

{% endhighlight %}
源码在这里。


## 3 总结 ##
本文用三种方法在Objective-C里实现了Observing Pattern, 包括普通实现，KVO isa Swizlling实现和KVO Method Swizzling实现。后两种需要读者对Objective-C的runtime有一定的熟悉。通过自己实现KVO的主要功能，相信定会让你更能体会代码的乐趣和增加自己coding的信心。

## 4 参考资料 ##
- [Key-Value Observing Programming Guide](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/KeyValueObserving/KeyValueObserving.html);

- [如何自己动手实现 KVO](http://tech.glowing.com/cn/implement-kvo/);

- [如何自己动手实现 KVO](http://tech.glowing.com/cn/implement-kvo/);



