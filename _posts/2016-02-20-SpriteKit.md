---
layout: post
title: iOS 2D Game Framework-SpriteKit入门
categories: [Objective-C]
tags: [SpriteKit]
fullview: false
shortinfo: 虽然接触iOS已经8个月了，block作为Objective C中对于回调(callback)的实现，理解起来还是有点模棱两可.在《Pro Multithreading and Memory Management for iOS and OS X》书中，Kazuki Sakamoto 对block的定义. 虽然接触iOS已经8个月了，block 作为Objective C中对于回调(callback)的实现，理解起来还是有点模棱两可.在《Pro Multithreading and Memory Management for iOS and OS X》书中，Kazuki Sakamoto 对block的定义


---

## 1. SpriteKit 概览##

SpriteKit是Apple官方的2D游戏框架，让开发者在iOS 和OS 平台上更高效的开发2D游戏。

学习SpriteKit，最权威的资料应该是苹果官方文档-SpriteKit Programming Guide。该文档很全面但是不适合初学者。对于初学者，理解SpriteKit背后的设计rationale才能更好的应用它。那么SpriteKit的设计rationale是什么呢？

对于一个2D游戏来说，设计应该分为三个部分（以超级马里奥为例）：

1. View: 即视图显示，用于展示各个Sprite(精灵)，例如马里奥图片和子弹图片；
Physics
2. Model：即物理模型，包括质量，体积（2D游戏是面积），密度，碰撞，地球引力等，例如超级马里奥碰到水管会弹回来，往上跳会下落。
3. Action：即 物理模型受到的外部作用力。例如超级马里奥里的空中台阶自己来回移动（开发者给其施加一个永恒的来回运动的作用力）。

这三个方面分别对应SpriteKit里面的SKNode, SKPhysicsBody, SKAction.


## 2. SKNode, SKPhysicsBody, SKAction理解##
### 2.1 SKNode###

SKNode 是 SpriteKit 显示 视图的Building Block。它能提供一个游戏视图的基本属性和方法，例如


    SKNode Class

    属性：
      .zPosition       //视图的z方向的距离，用于标定重叠视图的显示顺序；
      .xScale           //x方向的视图放大倍数；
      .yScale           //y方向的视图放大倍数；
      .alpha             //视图的alpha值；
      .hidden           //视图是否隐藏。

     方法：
      -addChild:                    //增加子SKNode，与UIView 的 -addSubView: 类似
      -removeFromParent:    //从父SKNode移除，与 UIView的removeFromSuperview 类似
      -runAction:                   //运行一个SKAction


我们一般不直接用它，它下面有几个子类, 其中最常见的是以下4个:

- SKEffectNode: 用于缓存，渲染，加滤镜于图片。它的子类SKScene 用于展示所有的SKNode, 是游戏场景。
- SKSpriteNode: 用于展示精灵，如超级马里奥图片；
- SKLabelNode: 用于展示单行文本，如游戏时间;
- SKEmitterNode: 用于展示粒子，例如喷射火焰的岩浆。

下面我们就这四个类做一个简单的介绍。

#### 2.1.1 SKScene###
SKScene 是游戏关口(level)，游戏中的一个场景，例如马里奥的第一关和第二关分别是两个SKCene实例。在这个场景中，包含了次关口的所有其他SKNode(或者其子类)，比如马里奥(SKSpriteNode), 游戏时间(SKLabelNode), 喷射火焰的岩浆(SKEmitterNode)。它的主要属性和方法有

    SKScene Class

    属性：
    .view       //关口的父视图，是一个SKView, 用来展示各个SKScene关口；
    .physicsWorld //世界的物理模型, 是一个SKPhysicsWorld实例，这个后面会介绍；

    方法：
    -initWithSize:        // 初始化方法;
    +SceneWithSize:   // 初始化类工厂方法；
    -didMoveToView: // 当SKScene实例被SKView展示时调用，类似UIView的-didMoveToSuperview；
    -addChild:              // 增加子SKNode, 如马里奥(SKSpriteNode)；

#### 2.1.2 SKSpriteNode###
SKSpriteNode是用来展示sprite，那么何为sprite呢，sprite有什么作用呢? Wiki中是这样定义的。

>sprite: two-dimensional image or animation that is integrated into a larger scene.Initially including just graphical objects handled **separately** from the memory bitmap of a video display, this now includes various manners of graphical overlays.

sprite是从整个display独立出来渲染的2D图片。如何理解这句话呢，在sprite出现之前，2D游戏要渲染一帧图片(比如马里奥在一个蓝天白云的背景前)，需要把整个图片(马里奥+背景)计算完后再渲染，其中背景的渲染在每一帧中都重复。sprite的出现正是为了避免这一重复。马里奥是一个sprite，他在一个固定的背景前跳跃，只需要将马里奥的每一帧渲染出来叠在背景(背景不需要重复计算渲染)即可，这就是为什么sprite被称为从整个display独立出来渲染的2D图片。sprite的思想在几十年前就已经有了，SpriteKit只是沿袭了2D游戏设计中运用sprite这一思想，用SKSpriteNode来表示sprite类。我们来看下SKSpriteNode的属性和方法

    SKSpriteNode Class

    属性：
    .size            // 大小；
    .physicsBody // 物体的物理模型，是一个SKPhysicsBody实例，这个后面会介绍；

    方法:
    + spriteNodeWithImageNamed:     // 类工厂方法，用图片创建sprite

#### 2.1.3 SKLabelNode###
SKLabelNode是SpriteKit用来展示text，它的方法和属性如下。有一点需要注意的是它只能显示单行文本。

    SKLabelNode Class

    属性：
    .fontSize             // 字体大小；
    .color                  // 字体颜色；
    .fontName          // 字体名字；

    方法:
     - initWithFontNamed:    // 通过字体名字初始化方法；

#### 2.1.3 SKLabelNode###
SKEmitterNode是SpriteKit用来展示粒子系统的，下面介绍下它的常见使用方法。
1. subclass一个SK：
![](2016-02-20/SKEmitterNode_2.png) 
![](2016-02-20/SKEmitterNode_1.png)
