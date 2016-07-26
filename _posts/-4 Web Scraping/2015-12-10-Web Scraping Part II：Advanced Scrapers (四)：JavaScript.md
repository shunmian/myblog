---
layout: post
title: Web Scraping Part II：Advanced Scrapers (四)：JavaScript
categories: [Web Scraping]
tags: [Web Scraping, BeaufitulSoup]
number: [-4.1.10]
fullview: false
shortinfo: 本文是基于Ryan Mitchell的《Web Scraping With Pyhton》书本的第二部分Advanced Scraper的第1篇笔记，。

---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}


在《Web Scraping With Python》第一部分，Basic Srapers，我们覆盖了Web Scraping的基础部分，即如何获取数据，解析数据和存储数据。之所以说它是基础，是因为获取的数据都是整理好存储在既定格式(如html，xml，json，doc，txt，pdf，csv等)里的；并且我们没有涉及到反爬虫程序(antiscraping measures)，JavaScript，登录表格，流数据等话题。第二部分，Advanced Scraper，我们就来关注这些Advanced的话题。

首先，本文作为第二部分Advanced Scraper的第1篇笔记，我们来了解下如何从将**原始数据**清理，规范化以成为我们需要的数据，即**数据清理**。



客户端脚本语言是运行在浏览器而不是服务器的语言。因此客户端脚本的成功运行基于浏览器解析和执行该脚本的正确性。这就是为什么你可以如此轻松的在浏览器关闭JavaScript。

由于各个浏览器厂商的差异性，所以客户端脚本语言的数量比服务端脚本语言的数量少很多。对于Web Scraping来说，这是好事，更少种类的语言意味着更好处理。

在把部分情况下，你主要会遇到两种客户端脚本语言，**ActionScript**和**JavaScript**。其中
 **ActionScript**(Flash application)，常被用于stream multimedia files作为online game的平台。现在**ActionScript**的使用相比于十年前已经大大减少。

 由于需要Web Scrape **ActionScript**的场景比较少，本文重点关注Web Scrape **JavaScript**


> **JavaScript**，是当今最为广泛应用的客户端脚本语言，可用于手机用户信息，不重载来提交表单，内嵌多媒体甚至是驱动整个oneline game。

即使最简单的网页也可能包括**Javascript**，它常常嵌在``<script>``标签里，如：


{% highlight js linenos %}
<script>
   alert("This creates a pop-up using JavaScript");
</script>
{% endhighlight %}

## 1 A Brief Introduction to JavaScript ##

JavaScript是一门弱类型语言(weakly typed language)

{: .img_middle_hg}
![web scraping](/assets/images/posts/2015-12-10/static vs dynamic and strong vs weak.png)

下面是一个JavaScript的对Fibonacci数列的实现，里面包括了函数声明，变量声明，匿名函数，函数调用等实例。

{% highlight js linenos %}

<script>
var fibonacci = function() {
	vara=1; varb=1;
	return function () {
		var temp = b; 
		b=a+b;
		a = temp; 
		return b;
	} 
}

var fibInstance = fibonacci();
console.log(fibInstance()+" is in the Fibonacci sequence"); 
console.log(fibInstance()+" is in the Fibonacci sequence"); 
console.log(fibInstance()+" is in the Fibonacci sequence"); 
</script>

{% endhighlight %}




### 1.1 Common JavaScript Libraries ###

> **jQuery**： a cross-platform JavaScript library designed to simplify the client-side scripting of HTML。

> **Google Analytics**： freemium web analytics service offered by Google that tracks and reports website traffic。

> **Google Map**：a web mapping service developed by Google。

用Python来执行包括这些JavaScript Libararies的代码非常消耗时间和CPU。

## 2 Ajax and Dynamic HTML ##

到目前为止，我们与服务器发收数据的唯一方式是通过HTTP请求来获得响应。如果你遇到一个网页在更新数据却没有重载页面(reload page)，那这个网页很大可能在用**Ajax**。

> **Ajax**：short for asynchronous JavaScript and XML)，is a set of web development techniques using many web technologies on the **client-side** to create **asynchronous** Web applications by decoupling the **data interchange layer** from the **presentation layer**，which means updating diplay content without reload the entire page。

> **DHTML**：an umbrella term for a collection of technologies used together to create interactive and animated web sites by using a combination of a static markup language (such as **HTML**)，a client-side scripting language (such as **JavaScript**)，a presentation definition language (such as **CSS**), and the **Document Object Model**。

如果你scrape一个网站发现它的显示和source code不一样；或者网页有一个重载页面将你redirect到另一个页面，但是你的网址却没有变。

任何上述两种情况都是由于你的Web Scraper程序不能成功执行相应的**JavaScript**。解决这两种情况只有两种方法：

1. 直接scrape JavaScript；

2. 使用能**执行JavaScript**的Python module然后从网页中scrape就像你正常浏览一个网站一样。

### 2.1 Executing Javascript in Python  with Selenium ###

> **Selenium**：a powerful **web scraping tool** developed originally for website testing by **automating browsers** to load the website, retrieve the required data, and even take screenshots or assert that certain actions happen on the website。

[Selenium](http://www.seleniumhq.org/)是一个Python Module，可以用``pip3 install selenium``下载安装。**Selenium**没有自己的浏览器，必须和第三方浏览器结合使用。你在使用的时候会发现有一个浏览器弹出，按照你写好的程序运行。但是你可以用一个**PhantomJS**的**headless browser**是你的程序安静运行在后台而不会弹出浏览器。

> **PhantomJS**：a **headless** WebKit scriptable with a **JavaScript API**。It has fast and native support for various web standards: DOM handling，CSS selector，JSON，Canvas，and SVG。**PhantomJS** makes it a similar browsing environment to **Safari** and Google **Chrome**。

[PhantomJS](http://phantomjs.org/)不是一个Python Module，所以需要你手动下载到程序

## 3 Handling Redirects ##

## 4 总结 ##

[Cleaning in code]({{ site.baseurl}}/web%20scraping/2015/12/07/Web-Scraping-Part-II-Advanced-Scrapers-(一)-数据清理.html#cleaining-in-code)

{: .img_middle_mid}
![web scraping](/assets/images/posts/2015-12-07/Data Cleaning Summary.png)

{% highlight python linenos %}

{% endhighlight %}

## 5 参考资料 ##

- [《BeautifulSoup Documentation》](https://www.crummy.com/software/BeautifulSoup/bs4/doc/);
- [《Python 3 Documentation》](https://docs.python.org/3/);
- [《OpenRefine》](http://openrefine.org/);



