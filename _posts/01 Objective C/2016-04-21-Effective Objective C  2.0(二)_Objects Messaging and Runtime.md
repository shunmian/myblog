---
layout: post
title: EOC(二)：Objects Messaging and Runtime
categories: [01 Objective-C]
tags: [Effective]
number: [01.25.1]
fullview: false
shortinfo: iOS里的UIViewController和UIView的Life Cycle是理解Objective-C event-driven的基础。本文重点介绍autolayout(自动布局)在UIViewController和UIView的Life Cycle里的相关方法细节以及最佳实践。
---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1 constraints & layout ##

iOS autolayout对于视图的布局比autoresizing要灵活很多。但是autolayout的代码里的实现并不是那么用户友好：literal语法之复杂被戏称为“象形文字”；而autolayout API非常冗长。[Masonry](https://github.com/SnapKit/Masonry)框架是对autolayout相关类的封装，使得在code里执行autolayout变得紧凑和更加简洁。在使用过几次Masonry后，笔者碰到一些诸如在哪里写Masonry constraints，以及何时UIView和subviews的frame确定下来等问题。本文通过1个小例子对上述问题进行澄清。

### 1.1 constraints ###

``NSConstraint``是autolayout的基石和前提。开发者写好``NSConstraint``，OC Runtime根据``NSConstraint``来layout视图。这是autolayout名字的由来，即通过更高一级的抽象，在``NSConstraint``层面写好约束关系，由运行时进行**布局**。

那么constraints在哪里写比较好呢。我们可以将UIView分为3个等级:

1. view controller's view，下面称为``L0View``;
2. view controller's view's children subviews，下面称为``L1View``;
3. view controller's view's grandson subviews，下面称为``L2View``;

> **Constraints Hierachy**：一个普遍的原则是，某view自身在其superView里的constraints必须由其superView来实现；而某view的children subviews在该view里的constraints必须由该view来实现。换句话说，你的位置由你的上级决定，但是你可以决定你的直接下级的位置。这样做的好处是constraints的解耦，利于代码复用。如果某view自身在其superView里的constraints必须由该view自身实现，那么换了superView之后，又得重新更新constraints。

在上面的3个等级中，对于``L1View``，其constraint由``L0View``决定；而``L2View``的constraint由``L1View``决定。通常情况下，``L0View``作为view controller的``view``属性，我们一般很少customize；如果需要customize，也可以从``L1View``开始，将``L0View``作为``L1View``的容器。因此对于``L1View``的constraint，我们可以在直接和``L0View``紧密相连的view controller里实现。

{% highlight objc linenos %}
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lcView = [[LCView alloc] initWithFrame:CGRectMake(10, 10, 300, 100)];
    self.lcView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.lcView];
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    [self.lcView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.lcView.superview.mas_centerY).with.multipliedBy(1.0);
        make.left.equalTo(self.lcView.superview.mas_left).with.offset(5.0);
        make.right.equalTo(self.lcView.superview.mas_right).with.offset(-5.0);
        make.height.equalTo(self.lcView.mas_width).with.multipliedBy(0.3);
    }];
}
@end
{% endhighlight %}

``updateViewConstraints``的方法其实更好的命名(当然不够规范)应该是``updateL1ViewsConstraints``，因为根据**Constraints Hierachy**，view controller自身的view的constraints应该由其上一级决定，这里可以是push时的presenting view controller来决定presented view controller的view的constraints。

在添加``L1View``的constraint后，对于``L2View``的constraint是在``L2View``的``updateConstraints``里添加的。


{% highlight objc linenos %}
@implementation L1View
-(void)updateConstraints{
     NSLog(@"%@,%@",self,NSStringFromSelector(_cmd));
    [super updateConstraints];
    
    /* You can update Constraints for self, but it is better to only update constraints for subcell and move the logic to update constraints for self to its superview (controller)
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.superview.mas_centerY).with.multipliedBy(1.0);
        make.left.equalTo(self.superview.mas_left).with.offset(5.0);
        make.right.equalTo(self.superview.mas_right).with.offset(-5.0);
        make.height.equalTo(self.mas_width).with.multipliedBy(0.3);
    }];
     */
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconView.superview.mas_centerY).with.multipliedBy(1.0);
        make.left.equalTo(self.iconView.superview.mas_left).with.offset(5.0);
        make.height.equalTo(self.iconView.superview.mas_height).with.multipliedBy(0.7);
        make.width.equalTo(self.iconView.mas_height).with.multipliedBy(1.5);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_top).with.offset(0);
        make.left.equalTo(self.iconView.mas_right).with.offset(10);
        make.right.equalTo(self.titleLabel.superview.mas_right).with.offset(-10);
        make.height.equalTo(self.iconView.superview.mas_height).with.multipliedBy(0.15);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(5);
        make.bottom.equalTo(self.iconView.mas_bottom).with.offset(0);
        make.left.equalTo(self.iconView.mas_right).with.offset(10);
        make.right.equalTo(self.detailLabel.superview.mas_right).with.offset(-10);
    }];
}
@end
{% endhighlight %}




### 1.2 layout ##




## 3 总结 ##

{: .img_middle_hg}
![NSOperation & NSOperationQueue总结](/assets/images/posts/01 Objectiev C/2016-04-07-OC Concurrency(三)_NSOperation part I_用法详解/NSOperation & NSOperationQueue总结.png)

## 4 Reference ##

- [《iOS 并发编程之 Operation Queues》](http://blog.leichunfeng.com/blog/2015/07/29/ios-concurrency-programming-operation-queues/);

- [《How To Use NSOperations and NSOperationQueues》](http://web.archive.org/web/20150417045614/http://www.raywenderlich.com/19788/how-to-use-nsoperations-and-nsoperationqueues);

