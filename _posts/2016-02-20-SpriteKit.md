---
layout: post
title: iOS 2D Game Framework-SpriteKit入门
categories: [Objective-C]
tags: [SpriteKit]
fullview: false
shortinfo: 虽然接触iOS已经8个月了，block作为Objective C中对于回调(callback)的实现，理解起来还是有点模棱两可.在《Pro Multithreading and Memory Management for iOS and OS X》书中，Kazuki Sakamoto 对block的定义. 虽然接触iOS已经8个月了，block 作为Objective C中对于回调(callback)的实现，理解起来还是有点模棱两可.在《Pro Multithreading and Memory Management for iOS and OS X》书中，Kazuki Sakamoto 对block的定义


---

<<<<<<< HEAD
## 2. SKNode, SKPhysicsBody, SKAction理解
### 2.1 SKNode
SKNode 是 SpriteKit 显示 视图的Building Block(基块)。我们一般不直接用它，它下面有几个子类:
- SKEffectNode: 用于缓存，渲染，加滤镜于图片。它的子类SKScene 用于展示所有的SKNode, 是游戏场景。
      SKSpriteNode *Maria = [SKSpriteNode spriteNodeWithImageNamed:@"Maria"];

- SKSpriteNode: 用于展示精灵，如超级马里奥图片；
- SKLabelNode: 用于展示单行文本，如游戏时间;
- SKEmitterNode: 用于展示粒子，例如boss下面滚动的火焰;
=======
##1. SpriteKit 概览##
学习SpriteKit，最权威的资料应该是苹果官方文档-[SpriteKit Programming Guide](href="https://developer.apple.com/library/ios/documentation/GraphicsAnimation/Conceptual/SpriteKit_PG/Introduction/Introduction.html").
>>>>>>> parent of cc7758b... new post_2
