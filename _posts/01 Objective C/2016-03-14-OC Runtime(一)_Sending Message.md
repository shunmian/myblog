---
layout: post
title: OC Runtime(一)： Sending Message
categories: [01 Objective-C]
tags: [Sending Message]
number: [0.14.1.2]
fullview: false
shortinfo: Objective-C中的消息发送和C中的函数调用有着本质的区别。后者在编译阶段已经确定了函数的具体实现, 而前者在运行时还可以更改消息发送的具体实现，这给Objective-C注入了崭新的动态活力。而这都得益于Objective-C的Runtime系统。可以说Objective-C的Runtime是其语言区别与其他语言的基石。而Runtime里的sending message(消息发送)又是其最主要的特性。本文将带您感受下Runtime的sending message机制。
---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1. iVar VS Property ##

Obective C 的类，本质是`struct objc_class`结构体，它的定义如下：

{% highlight c linenos %}
typedef struct objc_class *Class; 
struct objc_class { 
   Class isa; 
   Class super_class; 
   long version ; 
   long info ; 
   long instance_size ; 
   struct objc_ivar_list *ivars ; 
   struct objc_method_list **methodLists ; 
   struct objc_cache *cache ; 
   struct objc_protocol_list *protocols ; 
} ;
{% endhighlight %}

`objc_ivar_list *ivars`是一个存储了`objc_ivar`的list。在Objective C中我们知道`@property`是声明了setter和getter的语法糖,
 `@synthesis` 是实现了setter和getter的语法糖(Xcode 4.4及之后的版本可以省略)。在类中声明的每一个property都被一个`iVar` backup（property 名字前加_）。`objc_method_list **methodLists`是一个指针的指针。通过修改该指针指向的指针的值，就可以实现动态地为某一个类增加成员方法。这也是Category实现的原理。同时也说明了为什么Category只可为对象增加成员方法，却不能增加成员变量。

 关于`objc_ivar_list`, 我们看下面代码。

{% highlight objc linenos %}
Person.h

@interface Person : NSObject{
    NSString *ivarName;
}
@property (nonatomic, strong) NSString *propertyName;
@end


Person.m

@implementation Person
@synthesize propertyName = _propertyName;//可省略
-(instancetype)init{
    if(self = [super init]){
        ivarName = @"ivar";
        _propertyName = @"property";
    }
    return self;
}
@end
{% endhighlight %}

我们创建了一个`Person`类，其有一个iVar为NSString *类型的`ivarName`，一个property为NSString *类型的`propertyName`。我们打印Person类的`objc_ivar_list *ivars`:

{% highlight objc linenos %}

Person *person = [[Person alloc] init];
    
id personClass = [person class];
unsigned int ivarNumber = 0;
printf("Person objc_ivar_list: ");
Ivar *ivarArray = class_copyIvarList(personClass, &ivarNumber);
for(int i = 0; i < ivarNumber; i++){
    Ivar ivar = ivarArray[i];
    printf("%s, ",ivar_getName(ivar) );
}

//输出为:
//Person objc_ivar_list: ivarName, _propertyName, 
//
{% endhighlight %}

可见在一个类的本身定义中, iVar和Property都被加在`objc_ivar_list`中。

## 2 Associated Objects增加属性  ##

### 2.1在匿名类中增加属性  ###

我们知道`Category`可以用来扩展方法，但扩展不了类的iVar。Associated Objects 的出现就是为了解决这一问题。它让`Category`增加属性，就好像类本身定义中的属性一样可以用dot notation进行存取。但是它不加入类的`objc_ivar_list`中，而是存储在一个哈希表中。我们来看下面代码，给`Person+AssociatedObjects`增加一个属性类型为NSString *`的associatedObjctName`:


{% highlight objc linenos %}

Person+AssociatedObjects.h

#import "Person.h"
#import <objc/runtime.h>

@interface Person (AssociatedObjects)
@property (nonatomic, copy) NSString *associatedObjcName;
@end


Person+AssociatedObjects.m

@implementation Person (AssociatedObjects)

-(NSString *)associatedObjcName{
    return objc_getAssociatedObject(self, @selector(associatedObjcName));
}

-(void)setAssociatedObjcName:(NSString *)associatedObjcName{
    objc_setAssociatedObject(self, @selector(associatedObjcName), associatedObjcName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end

{% endhighlight %}

我们在`Person(AssociatedObjects)`中增加了属性类型为NSString *的`associatedObjctName`,并用runtime的API实现了其setter和getter方法。我们再来运行下面代码:


{% highlight objc linenos %}
Person *person = [[Person alloc] init];
person.associatedObjcName = @"associated objects";
NSLog(@"associatedObjcName: %@", person.associatedObjcName);
    
id personClass = [person class];
unsigned int ivarNumber = 0;
Ivar *ivarArray = class_copyIvarList(personClass, &ivarNumber);
printf("Person objc_ivar_list: ");
for(int i = 0; i < ivarNumber; i++){
    Ivar ivar = ivarArray[i];
    printf("%s, ",ivar_getName(ivar) );
}

//输出为:
//associatedObjcName: associated objects
//Person objc_ivar_list: ivarName, _propertyName, 
//
{% endhighlight %}

我们可以看见`objc_ivar_list`并没有新加入的associated objects。

### 2.2 在Runtime API中动态增加属性  ###
当用runtime API 动态创建类，添加方法和实例变量过程中，当类创建完毕后（调用`objc_registerClassPair`后）再用`class_addIvar(...)`添加的iVar不会出现在类的`objc_ivar_list`中，见如下代码。

{% highlight objc linenos %}
 //dynamically create a Peron Class
 Class person = objc_allocateClassPair([NSObject class], "Person", 0);
     // add a instance method
 Method description = class_getInstanceMethod([NSObject class], @selector(description));
 const char *methodType = method_getTypeEncoding(description);
 class_addMethod([person class], NSSelectorFromString(@"greeting"), (IMP)greeting, methodType);
        // add a instance variable before register
 const char *nameBeforeRegister = "nameBeforeRegister";
 class_addIvar(person, nameBeforeRegister, sizeof(id), rint(log2(sizeof(id))), @encode(id));
    
  //register Person Class
 objc_registerClassPair(person);
    
     // add a instance variable after register
 const char *nameAfterRegister = "nameAfterRegister";
 class_addIvar(person, nameAfterRegister, sizeof(id), rint(log2(sizeof(id))), @encode(id));
    
 //create a instance
 id personInstance = [[person alloc] init];
     //call the method
 NSLog(@"%@", ((id (*)(id, SEL))objc_msgSend)(personInstance, NSSelectorFromString(@"greeting")));
     //dynamically add a variable(an associated object) to the personInstance and get it
 NSString *firstname = @"Johnson";
 objc_setAssociatedObject(personInstance, nameBeforeRegister, firstname, OBJC_ASSOCIATION_COPY_NONATOMIC);
 NSLog(@"%@", objc_getAssociatedObject(personInstance,nameBeforeRegister));
    
 NSString *lastname = @"Lu";
 objc_setAssociatedObject(personInstance, nameAfterRegister, lastname, OBJC_ASSOCIATION_COPY_NONATOMIC);
 NSLog(@"%@", objc_getAssociatedObject(personInstance,nameAfterRegister));
    

    
 int ivarNum = 0;
 Ivar *ivars = class_copyIvarList([person class], &ivarNum);
 for(int i = 0; i < ivarNum; i++){
     Ivar ivar = ivars[i];
     printf("%s ",ivar_getName(ivar));
 }
 printf("\n");

//输出为:
//Hello World!
//Johnson
//Lu
//nameBeforeRegister 
//
{% endhighlight %}

可见当用runtime API动态创建类时，当创建完毕后，添加的iVar就不加入到`objc_ivar_list`.

### 2.3. Runtime API介绍  ###

以上介绍了Associated Objects的实现，我们现在来看看其runtime API,包括以下3个方法：

1. `objc_setAssociatedObject` 用于给对象添加关联对象，传入 nil 则可以移除已有的关联对象；
2. `objc_getAssociatedObject` 用于获取关联对象；
3. `objc_removeAssociatedObjects` 用于移除一个对象的所有关联对象。



关于前两个函数中的 key 值是我们需要重点关注的一个点，一般来说，有以下三种推荐的 key 值：

1. 声明 static char kAssociatedObjectKey; ，使用 &kAssociatedObjectKey 作为 key 值;
2. 声明 static void *kAssociatedObjectKey = &kAssociatedObjectKey; ，使用 kAssociatedObjectKey 作为 key 值；
3. 用 selector ，使用 getter 方法的名称作为 key 值。

由于第3种方式最为优雅和简洁，在上面的例子中我们用的就是selector。


## 3 总结 ##
Associated Objects用于扩展类的属性，使得外部在用dot notation存取属性时分不出两者的区别，这解决了Objective C属性扩展的问题。但是在内部实现中，Associated Objects和类本身的iVar和Property还是有区别的：

1. 类的定义结束后(无论是Objective-C还是runtime API动态创建类)`objc_ivar_list`是不能变得。
2. 关联类和被关联类在内存中是分开存储的。被关联类的`objc_ivar_list`只存储其本身的iVar和Property。
3. 这同样体现在用runtime动态创建类中，`class_addIvar(...)`在`objc_registerClassPair`前和后调用时的情况。当`class_addIvar(...)`在`objc_registerClassPair`前调用时，加入的iVar是在类本身的定义中，存储在其`objc_ivar_list`；在`objc_registerClassPair`后调用，`class_addIvar(...)`，增加的iVar和本身的类分开存储。
