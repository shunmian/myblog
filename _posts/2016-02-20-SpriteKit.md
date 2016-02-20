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

学习SpriteKit，最权威的资料应该是苹果官方文档-[SpriteKit Programming Guide](https://developer.apple.com/library/ios/documentation/GraphicsAnimation/Conceptual/SpriteKit_PG/Introduction/Introduction.html)。该文档很全面但是不适合初学者。对于初学者，理解SpriteKit背后的设计思想之后才能体会文档中的细节和趣味。那么SpriteKit的设计思想是什么呢?

对于一个2D游戏来说，设计应该分为三个部分（以超级马里奥为例）：

1. View: 即视图显示，用于展示各个Sprite(精灵)，例如马里奥图片和子弹图片；
2. Physics Model：即物理模型，包括质量，体积（2D游戏是面积），密度，碰撞，地球引力等，例如超级马里奥碰到水管会弹回来，往上跳会下落。
4. Action：即 物理模型受到的外部作用力。例如超级马里奥里的空中台阶自己来回移动（开发者给其施加一个永恒的来回运动的作用力）。

这三个方面分别对应SpriteKit里面的SKNode, SKPhysicsBody, SKAction.

## 2. SKNode, SKPhysicsBody, SKAction理解##
### 2.1 SKNode###
SKNode 是 SpriteKit 显示 视图的Building Block(基块)。我们一般不直接用它，它下面有几个子类:
- SKEffectNode: 用于缓存，渲染，加滤镜于图片。它的子类SKScene 用于展示所有的SKNode, 是游戏场景。
- SKSpriteNode: 用于展示精灵，如超级马里奥图片；
- SKLabelNode: 用于展示单行文本，如游戏时间;
- SKEmitterNode: 用于展示粒子，例如boss下面滚动的火焰;
