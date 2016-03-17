---
layout: post
title: OC Runtime(三)： Method Swizziling
categories: [Objective-C]
tags: [Associated Objects]
number: [0.14.1.2]
fullview: false
shortinfo: Objective-C 的runtime给这门语言添加了许多dynamic特性, 包括sending message, dynamic bundle loading, introspection等。其中以sending message的dynamic特性最为突出，通过isa查找类，再在 vtable查找相应selector的IMP来最终执行消息。这个过程提供了许多"黑魔法", 替换isa(isa Swizzling)和替换IMP(Method Swizzling)。本文就Method Swzzling做一个简单的介绍。
---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1. Method Swizzling 介绍 ##

首先回顾一下Objective-C 消息发送过程:

{: .img_middle_lg}

![SendingMessage](/assets/images/posts/2016-03-16/sending message.png)

简单来看下这张图，当`[foo doSomething:@"param1" and @"param2"]`执行时，会转换成`objc_msgSend(id foo, SEL @selector(doSomething:and:),@"param1",@"param2")`, 而这个函数的执行过程就是这张图的流程:

- 1 调用 `IMP lookUpImpOrNil(Class cls, SEL name)`
    + 1.1 查找`foo`的`isa`，通过`@selector(doSomething:and:)`查找`cache`，若找不到则下一步;
    + 1.2 查找vtable，最终找到函数的实现, 类型为IMP的函数指针,若找不到则调到2;
- 2 消息转发，
    + 2.1 `+ (BOOL) resolveInstanceMethod:(SEL)sel`, 如找不到则2.2;
    + 2.2 `-(id)forwardingTargetForSelector:(SEL)sel`, 如找不到则2.3;
    + 2.3 `-(void)forwardInvocation:(NSInvocation *)inv`, 如找不到则2.4;
    + 2.4 `-(void)doesNotRecognizeSelector:(SEL)sel`。

这个过程中，swizzling可以发生在:

- 1.1 调换isa(isa Swizzling)来达到查找IMP的目的(如Objective-C对KVO的实现,原类没有改写setter，如何实现KVO，关键在于isa swizzling创建了一个中间类，重写了setter，这个我们以后的文章再详细讲);
- 1.2 调换@selector和IMP在vtable上的对应关系(Method Swizzling)来动态实现selector和IMP的绑定。

介绍了消息发送之后，我们来具体看看Method Swizzling。 既然是Method Swizziling，那什么是`Method`呢，在`/usr/include/objc`中的我们可以找到这样的定义:

{% highlight objc linenos %}
typedef objc_method *Method
struct objc_method {
    SEL method_name       OBJC2_UNAVAILABLE; //method 的 selector，SEL
    char *method_types    OBJC2_UNAVAILABLE; //method 的 输入输出参数类型, signature
    IMP method_imp        OBJC2_UNAVAILABLE; //method 的 实现，IMP
} 
{% endhighlight %}

一个Method是一个指向objc_method结构体的指针，这个结构体包含三个变量，分别是SEL，signature和IMP。一个vtalbe的entry既是Method, 第一列是SEL,第二列是IMP。一个SEL对应一个IMP，如下图。

{: .img_middle}
![vtable1](/assets/images/posts/2016-03-16/vtable1.png)
![vtable2](/assets/images/posts/2016-03-16/vtable2.png)

因此，如果你可以更改SEL和IMP的动态对应关系，则可以做出一些奇妙的事情。

## 2. Method Swizzling code##

### 2.1 API ###
我们来建一个Swzizzle类，代码如下:
{% highlight objc linenos %}

Swizzle.h

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
@interface Swizzle : NSObject
+(void)swizzleClass:(id)objecClass fromSelector:(SEL)sel1 toSelector:(SEL)sel2;
@end


Swizzle.m

@implementation Swizzle


+(void)swizzleClass:(id)objecClass fromSelector:(SEL)sel1 toSelector:(SEL)sel2{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalMethod = class_getInstanceMethod(objecClass, sel1);
        Method destinationMethod = class_getInstanceMethod(objecClass, sel2);
        
        IMP originIMP = method_getImplementation(originalMethod);
        IMP destinationIMP = method_getImplementation(destinationMethod);
        
        BOOL isAdded = class_addMethod(objecClass, sel1, destinationIMP, method_getTypeEncoding(destinationMethod));
        
        if(isAdded){
            class_replaceMethod(objecClass, sel2, originIMP, method_getTypeEncoding(originalMethod));
        }else{
            method_exchangeImplementations(originalMethod, destinationMethod);
        }
    });
}
@end
{% endhighlight %}

Swizzle类只有一个类方法`+(void)swizzleClass:(id)objecClass fromSelector:(SEL)sel1 toSelector:(SEL)sel2`,返回void, 输入第一参数是要执行method swizzle的类名，第二个和第三个参数是要交换的selector。

首先我们获取两个selector对应的method(`class_getInstanceMethod)`, 然后通过method获取其IMP(`method_getImplementation`)。
然后我们在原本的类里尝试添加新的方法，该方法的selector是sel1，IMP是destinationIMP，返回一个bool值表示是否添加成功。如果添加成功，则将原来的method2替换掉(`class_replaceMethod`), 令其sel2指向IMP2。若果失败，则表示类里面已经存在method1，那么就简单将method1和method2的IMP交换既可。这样就防止了一种情况：该类继承于父类，却没有重写父类的方法，如果简单用`  method_exchangeImplementations(originalMethod, destinationMethod)`,则会将父类的originalMethod的IMP和该类的destinationMethod的IMP交换，这不是我们想要的。
用GCD的`dispatch_once`方法是为了保证线程安全且交换只执行一次。

### 2.2 应用1: NSString lowerCase upperCase方法的交换 ###
好了我们来看看如何用这个Swizzle,

{% highlight objc linenos %}
NSString *originalString = @"hello,WORLD!";
NSLog(@"original string  : %@",originalString);
    
NSLog(@"before Method Swizzle---------");
NSLog(@"lower case String: %@", [originalString lowercaseString]);
NSLog(@"upper case string: %@", [originalString uppercaseString]);
    
NSLog(@"after  Method Swizzle---------");
[Swizzle swizzleClass:[originalString class]
         fromSelector:@selector(lowercaseString)
           toSelector:@selector(uppercaseString)];
    
NSLog(@"lower case String: %@", [originalString lowercaseString]);
NSLog(@"upper case string: %@", [originalString uppercaseString]);

//输出：
//original string  : hello,WORLD!
//before Method Swizzle---------
//lower case String: hello,world!
//upper case string: HELLO,WORLD!
//after  Method Swizzle---------
//lower case String: HELLO,WORLD!
//upper case string: hello,world!
//
{% endhighlight %}

可以看到在Method Swizzle后，同样是`lowercaseString`和`uppercaseString`的结果交换了，有没有一个感觉自己是个黑客了呢。

### 2.3 应用2: 打印当前UIViewController的名字 ###
下面这个场景对于应用Method Swizzle来说再合适不过了

>Method Swizzle 应用场景: 给你一个Xcode project修改代码。在修改前你想要了解出现在手机上的当前UIView对应得UIViewController到底是什么类, 比如在`ViewDidAppear`加入`NSLog(@"%@: [self class]")`让其自行打印。由于custmozied的各种视图控制器继承自如UITableViewController, UITabViewController, UINavigationViewController,而它们都继承自UIViewController。因此最笨的方法是你需要重写customized每一个视图控制器中的`ViewDidAppear`，聪明一点就是重写其父类(那也有好多个)。再聪明一点是重写UIViewController。问题是UIViewController我们没有其源码！这个时候我们就可以用Method Swizzle.

代码如下。

{% highlight objc linenos %}
UIViewController + Swizzle.h

#import <UIKit/UIKit.h>
#import "Swizzle.h"

@interface UIViewController (Swizzle)
-(void)swizzle_viewDidAppear:(BOOL)animated;
@end


UIViewController + Swizzle.m

@implementation UIViewController (Swizzle)

+(void)load{
    [Swizzle swizzleClass:[self class] fromSelector:@selector(viewDidAppear:) toSelector:@selector(swizzle_viewDidAppear:)];
}

-(void)swizzle_viewDidAppear:(BOOL)animated{
    [self swizzle_viewDidAppear:animated];
    NSLog(@"the current appeared ViewController: %@",[self class]);
}


@end
{% endhighlight %}

我们在声明了一个`-(void)swizzle_viewDidAppear:(BOOL)animated;`方法，在它的实现里调用了`[self swizzle_viewDidAppear:animated]`，然后加入一句打印自身类的语句。在`+(void)load`里我们Method Swizlle两者的实现。
首先category的`+(void)load`保证其在尽可能很早的时候已经执行Method Swizzle（`+(id)initialize`不行，因为其只会在第一次调用方法时才执行，因此有可能太迟，有可能永不执行。）然后当你的各个视图控制器的`-(void)viewDidAppear:(BOOL)animated`执行时，其IMP是line20-21。而line20调用`[self swizzle_viewDidAppear:animated]`时，其IMP又是UIViewController`-(void)viewDidAppear:(BOOL)animated`的IMP。不会有循环。

当你在各种视图控制器中切换时，他们的类就自行打印出来了，Cool！

{% highlight objc linenos %}
//输出：
//the current appeared ViewController: UITabBarController
//the current appeared ViewController: UINavigationController
//the current appeared ViewController: PBBibleBookViewController
//the current appeared ViewController: UIInputWindowController
//the current appeared ViewController: PBBibleVolumeViewController
//the current appeared ViewController: PBBibleChapterViewController
//
{% endhighlight %}

### 2.4 注意点 ###

在用Method Swizzling的时候，有一些坑需要注意：
1. 要尽可能早的执行swizzle，因此在`+(void)load`而不是在`+(id)initialize`里;
2. 用GCD的d`ispatch_once`保证其线程安全且执行一次;
3. 要注意方法命名冲突，用swizzle_前缀比较合适，表示Method Swizzle的方法。



## 3 总结 ##
Method Swizzle在sending message的过程中寻找IMP这一步动态注入代码，这使得当你没有源码时依然可以重写其方法。这比子类化重写和category重写要有更多优势。比如你没有实例化控制权，子类化重写则无济于事; category重写会覆盖掉原方法，而通常我们需要的是扩展功能同时保留原有功能。Method Swizzle提供了另一种优雅的解决方案，其中的细节需要读者细细品味。

