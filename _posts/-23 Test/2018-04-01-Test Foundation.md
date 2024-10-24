---
layout: post
title: Test Foundation
categories: [-23 Test]
tags: [Vim]
number: [-20.1]
fullview: false
shortinfo: Test Foundation 介绍
---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1. Test 基础 ##

"测试不受重视"到"测试和开发同等重要"。
Googele等一线互联网巨头主导"去QE(Quality Engineer)， 开发自己测试"的全新模式。

趋势:

1. "自动化测试为辅"到"自动化测试为主";

2. 产品发布从"月"为单位到现在"天"甚至"小时"， 留给测试的时间不多。因此要掌握设计开发测试基础架构的关键技术，特别是**高并发测试执行基础架构**。

3. 系统性思考如何将数据的准备工具化，服务化，最终实现平台化。

测试方式(用户登录为例):

1. 等价类划分(已注册用户，用户名密码对； 已注册用户，用户名对，密码错； 已注册用户，用户名错，密码对)；

2. 边界值分析；

3. 显示功能性测试(已注册用户, 用户名密码对是否可正确登录)；

4. 隐式功能性测试(用户名密码是否在后台加密， 登录网络请求是否加密)；

什么是好的测试用例？ ”好的“测试用例是一个玩呗的几何，它能够覆盖所有等价类以及各种边界值，而更能否发现缺陷无关。如果把测试软件看做一个池塘，软件缺陷就是池塘中的鱼，建立测试用例集的过程就是在编织一张渔网。”好的“测试用例集就是一张能够覆盖整个池塘的大渔网，只要池塘里有鱼，就一定能捞上来。如果渔网本身是完整且合格的，那么捞不到鱼，就证明池塘中没有鱼，而渔网的好坏与池塘中是否有鱼无关。所以好的测试用例必须是完备的等价类的集合(可通过**等价类划分**，**边界值分析**和**错误推测**三种方法实现)。

以考试成绩(0 - 100 int)输入项为例(60分及格)

等价类：
- 有效等价类 1: 0~59之间的任意整数;
- 有效等价类 2: 60~100之间的任意整数;
- 无效等价类 1: 小于0的负数;
- 无效等价类 2: 大于100的整数;
- 无效等价类 3: 0~100之间的任何浮点数;
- 无效等价类 4: 其他任意非数字字符。

边界值: -1, 0, 1, 59, 60, 61, 99, 100, 101 



### 1.1 自动化测试

> 自动化测试： 把人堆软件的测试工作，转化为由代码执行测试。其本质是写一段代码去测试另一段代码，所以实现自动化测试用例本身不属于开发工作，需要投入大量的时间和精力，并且已经开发完成的用例还必须随着被测对象的改变而不断更新，你还需要为此付出维护测试用例的成本。当你发现自动化测试用例的维护成本高于其节省的测试成本时，自动化测试就失去了价值与意义，你也就需要在是否使用自动化测试上权衡取舍了。

优势

劣势
1 自动化测试远比手动测试脆弱，无法应对被测系统的变化，业界一直有句玩笑话"开发手一抖，自动化测试忙一宿"，这也从侧面反映了自动化测试用例的维护成本居高不下的事实。其根本原因在于自动化测试用例是hard coded，不具备任何"智能"应对变化。

2 自动化测试用例的开发工作量远大于单次的手工测试。


### 1.2 Test Coverage

统计代码覆盖率的根本目的是找出潜在的遗漏测试用例，并有针对性的进行补充，同时还可以识别出代码中那些由于需求变更等原因造成的不可达的废弃代码。

高的代码覆盖率不一定能保证软件的质量，但是低的代码覆盖率一定不能保证软件的质量。

实现代码覆盖率的统计，最基本的方法就是注入(Instrumentation)。简单地说，注入就是在被测代码中自动插入用于覆盖率统计的探针(Probe)代码，并保证插入的探针代码不会给原代码带来任何影响。

### 1.3 Software Defect Report(软件缺陷报告)


### 1.4 TDD

TDD：先根据需求写测试用例，然后开发。TDD优点:

1. 保证开发功能一定是符合实际需求的； 
2. 测试用例即文档, 可以将测试用例直接输出为文档，例如JavaDoc.


## 2. GUI自动化测试


1. 传统Web浏览器的GUI测试，业内主流的开源方案采用Selenium, 商业方案采用Micro Focus的UFT(前身是HP的QTP); 前端网站性能测试WebPagetes；

2. 对于移动端的原生应用，通常采用主流的Appium, 它对iOS环境集成了XCUITest, 对Android环境集成了UIAutomator和Espresso.

### 2.1 Web

#### 2.1.1 脚本与数据的解耦 + Page Object模型

#### 2.1.2 GUI自动化过程中的测试数据

#### 2.1.3 Page Code Gen + Data Gen + Headless

#### 2.1.4 GUI测试稳定性

#### 2.1.5 GUI测试报告

#### 2.1.6 GUI自动化测试策略

### 2.2 移动端

#### 2.2.1 移动应用测试方法与思路

#### 2.2.2 Appium

## 3. API自动化测试

### 3.1 常用API测试工具简介

cURL 和 Postman

### 3.2 微服务模式下API测试


1. 测试脚手架代码的自动化生成；

2. 部分测试输入数据的自动生成；

3. Response 验证的自动化;

4. 基于SoapUI或者Postman的自动化脚本生成


## 4. 代码级测试

### 4.1 代码级测试的基本理念与方法

静态方法指不运行代码(通常是linter)，动态方法指运行代码。

1. 人工静态方法，本质上通过开发人员代码走查(Code Review)、结对编程(Pair Programming)、同行评审(Peer Review)来完成的，理论上可以发现所有的代码错误，但也因为其对“测试人员”的过渡依赖，局限性非常大；
2. 自动静态方法(linter)，主要的手段是代码静态扫描，可以发现语法特征错误、边界行为特征错误和经验特征错误这三类“有特征”的错误；
3. 人工动态方法，就是传统意义上的单元测试，是发现算法错误和部分算法错误的最佳方式；
4. 自动动态方法，其实就是自动化的边界测试，主要覆盖边界行为特征错误。

### 4.2 静态方法
linter

### 4.3 动态方法
#### 4.3.1 Unit Test

驱动代码 -> 被测试函数 --> 桩代码/Mock代码(两者区别请见[《Mock 代码不是桩代码》（Mocks Aren’t Stubs)](https://martinfowler.com/articles/mocksArentStubs.html).

1. 脚手架代码生成的自动化;

2. 部分测试输入数据的自动化生成;

3. 自动桩代码的生成;

4. 被测代码的自动化静态分析;

5. 测试覆盖率的自动统计与分析。

#### 4.3.2 Integrated Test

从测试用例设计和测试代码结构来看，代码级集成测试和单元测试非常相似，它们都是对被测试函数以不同的输入参数组合进行调用并验证结果，只不过代码级集成测试的关注点，更多的是软件模块之间的接口调用和数据传递。

**集成测试与单元测试的最大区别只是，集成测试中被测试函数的内部调用的其他函数必须是真实的，不允许使用桩代码代替，而单元测试中允许使用桩代码来模拟内部调用的其他函数**。


## 5. 性能测试


### 5.1 测试的基本方法与应用领域

根据在实际项目中的实践经验，我把常用的性能测试方法分为七大类：后端性能测试（Back-end Performance Test）、前端性能测试（Front-end Performance Test）、代码级性能测试（Code-level Performance Test）、压力测试（Load/Stress Test）、配置测试（Configuration Test）、并发测试（Concurrence Test），以及可靠性测试（Reliability Test）。接下来，我将详细为你介绍每一种测试方法。


### 5.2 前端性能测试工具原理与行业常用工具简介

WebPagetest

极客时间版权所有: https://time.geekbang.org/column/article/17935

### 5.3 后端性能测试工具原理与行业常用工具简介


api性能测试(LoadRunner JMeter).

{: .img_middle_hg}
![regular expression]({{site.url}}/assets/images/posts/-23_Test/2018-04-01-Test Foundation/性能测试.png)

## 6. 测试数据准备

### 6.1 Build Pattern

{% highlight go linenos %}
// old way of prepare settings as test data
const settings = {
  shouldReceiveNotification: true
  shouldDisplayTransactionAmount: true
}

Class Settings {
  constructor(){

  }
  static Build(){
    this.shouldReceiveNotification = true
    this.shouldDisplayTransactionAmount = true
    return this
  }
  withShouldReceiveNotification(shoudlReceive) {
    this.shouldReceiveNotification = shoudlReceive
    return this 
  }
  withShouldDisplayTransactionAmount(shouldDisplay) {
    this.shouldDisplayTransactionAmount = shouldDisplay
    return this
  }
}

const settings = Settings.Build() // use default value
const settings = Settings.Build().withShouldReceiveNotification(false) // just customized this field, all the rest are using default values.
{% endhighlight %}

### 6.2 统一测试数据平台

## 7. 测试基础架构

### 7.1 Selenium Grid for GUI
GUI测试架构(Selenium Grid): 从本质上讲，Selenium Grid 是一种可以并发执行 GUI 测试用例的测试执行机的集群环境，采用的是 HUB 和 Node 模式。目前 Selenium Grid 已经有 Docker 的版本了，你有没有考虑过可以在云端，比如 PCF、GCP、AWS 上搭建 Selenium Grid 呢？在我看来，这将是未来的主流方案。


### 7.2 测试执行环境的架构设计
从广义上讲，测试执行环境除了包括测试执行机以外，还包括测试执行机的维护、集群的容量规划、测试发起的控制、测试用例的组织以及测试用例的版本控制等等。这也就是我要和你的测试基础架构的定义。

### 7.3 大型全球化电商的测试基础架构设计

{: .img_middle_hg}
![regular expression]({{site.url}}/assets/images/posts/-23_Test/2018-04-01-Test Foundation/完整的测试架构.png)

## 8. 测试新技术

### 8.1 探索式测试

### 8.2 精准测试

### 8.3 渗透测试

### 8.4 基于模型的测试


## 9. 深入浅出大型网站的架构设计

### 9.1 高性能架构设计

### 9.2 高可用架构设计

### 9.3 伸缩性架构设计

## 10 参考资料 ##

- [《软件测试52讲》](https://time.geekbang.org/column/103)
- [《Jest Documentation》](https://facebook.github.io/jest/docs/en/getting-started.html).




