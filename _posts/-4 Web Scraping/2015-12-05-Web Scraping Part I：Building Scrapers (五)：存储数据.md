---
layout: post
title: Web Scraping Part I：Building Scrapers (五)：存储数据
categories: [Web Scraping]
tags: [Web Scraping, BeaufitulSoup]
number: [-4.1.3]
fullview: false
shortinfo: 本文是基于Ryan Mitchell的《Web Scraping With Pyhton》书本的第3篇笔记，通过前2篇笔记，您已经掌握了BeautifulSoup的基本用法。本文将用几个实战的例子，带您用BeautifulSoup在真实的互联网上获取数据。

---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

本系列1-4篇笔记集中讲解如何获取数据，包括**BeautifulSoup**和**API**的单独使用以及混合使用。对于如何使用数据，仅限于在终端打印。但是如果缺少了数据的存储和分析，**Web Scraping**的实用性就大打折扣。本文我们来介绍三种自动数据存储(Automated Data Storage)的方法，即**Media Files**，**CSV**，**MySQL**，以及如何用**Email**实现自动通知。


## 1 Media Files ##

> **多媒体文件(Media Files)**：主要包括音频，视频，图片。

通常有两种方法存储多媒体文件：

1. **By reference**：仅需要存储**Medial File**的**URL**。优点是Scraper运行更快，不需要下载文件；程序更简单；服务端压力更小。缺点是受制于人，任何URL源的改变，都会影响**Scraper**的运行；且实际上真实的Browser浏览网页时会下载所有的需要的**assets**。因此下载**Media File**会让**Scraper**运行时更像一个真实的人在用Browser浏览网页。

2. **By downloading the file iteself**：下载**Media File**到本地。优缺点和**By Reference**相反。

那么问题来了，多媒体存储哪家强？如果需要多次访问**Media File**，则用后者(大部分实际情况)；如果只需要单次获取表面信息。


### 2.1 Download a Single Internal File ###

{% highlight python linenos %}

from urllib.request import urlretrieve
from urllib.request import urlopen
from bs4 import BeautifulSoup

htmlHandler = urlopen("http://www.pythonscraping.com")
bsObj = BeautifulSoup(htmlHandler.read(),"html.parser")
imageUrl = bsObj.find("a",{"id": "logo"}).find("img").attrs["src"]

urlretrieve(imageUrl, "logo.jpg")   #a URL, filename in the same directory that the script is running from

{% endhighlight %}

### 2.2 Download All Internal Files ###

上述代码对于已知file的扩展名有效。但是大部分情况是你不知道。以下代码将会下载某一页面all internal files(with src attribute)。

{% highlight python linenos %}

import os
from urllib.request import urlretrieve
from urllib.request import urlopen
from bs4 import BeautifulSoup

downloadDirectory = "downloaded"
baseUrl = "http://pythonscraping.com"

def getAbsoluteURL(baseUrl,source):
  '''
  :param baseUrl: 
  :param source: http://www.pythonscraping.com/misc/jquery.once.js?v=1.2
  :return:       http://pythonscraping.com/misc/jquery.once.js?v=1.2
  '''
    if source.startswith("http://www."):    #去掉www
        url = "http://"+source[11:]
    elif source.startswith("http://"):      #已经去掉www,则不变
        url = source
    elif source.startswith("www."):         #若www.开头,则加http://并去掉www
        url =  "http://"+source[4:]
    else:
        url = baseUrl + "/" + source        #若部分url,则补全
    if baseUrl not in url:                  #去掉外部链接
        return  None
    return  url

def getDownloadPath(baseUrl,absoluteUrl,downloadDirectory):  #dwonloadDirectory是script目录下的文件夹,
  '''
  :param baseUrl: 
  :param absoluteUrl: http://pythonscraping.com/misc/jquery.once.js?v=1.2
  :return:            downloaded/misc/jquery.once.js?v=1.2     
  '''
    path = absoluteUrl.replace("www.","")
    path = path.replace(baseUrl,"")
    path = downloadDirectory+path
    directory = os.path.dirname(path)

    if not os.path.exists(directory):
        os.makedirs(directory)

    return path

htmlHandler = urlopen("http://www.pythonscraping.com")
bsObj = BeautifulSoup(htmlHandler.read(),"html.parser")
downloadList = bsObj.findAll(src=True)  #this is a lambda expression to select all tag with src attribute.

for download in downloadList:
    fileUrl = getAbsoluteURL(baseUrl,download.attrs["src"])
    if fileUrl is not None:
        print(fileUrl)
        urlretrieve(fileUrl, getDownloadPath(baseUrl,fileUrl,downloadDirectory))

{% endhighlight %}

我们来分析下代码。
上述代码不需要知道具体src文件对应的扩展名，只需要将src作为filename的一部分统一处理成文件目录，然后循环下载即可。其中``bsObj.findAll(src=True)``是一个lambda expression用来筛选所有有src属性的Tag；``getAbsoluteURL(baseUrl,source)``normalize the source url as absolute url；``getDownloadPath``将absolute url换成script下的文件目录(若不存在则创建)；``os``module属于Python的core library，作为**Python**和**operating system**的**interface**。


## 2 CSV ##

> **CSV(comma-sparated values)**：是用来存储 spreadsheet data最流行的文件格式。由于其简单性，被诸如Microsoft Excel等许多应用程序所使用。一个简单的CSV例子如下：<br/>
fruit,cost 	<br/>
apple,1.00 	<br/>
banana,0.30	<br/>
pear,1.25	<br/>
每一row都被newline字符界定。在任意row里，columns被commas(``,``)分开。有一些其他格式的**CSV**使用tabs或者其他字符来代替``,``，但是使用比较少。

如果你只需要下载一个**现成**的**CSV**文件，只需要和第一部分的代码一样即可。我们这里来看看如何修改或者生成一个CSV文件。

{% highlight python linenos %}

import os
import csv

def getCSVPath(directory,filename):
    if not os.path.exists(directory):
        os.makedirs(directory)
    return os.getcwd()+"/"+directory+"/" + filename

path = getCSVPath("CSV","test.cv")
try:
    csvFileHandler = open(path,'w+')    #file handler
    writer=csv.writer(csvFileHandler)
    writer.writerow(('number', 'number puls 2', 'number times 2'))
    for i in range(10):
        writer.writerow((i,i+2,i*2))
finally:
    csvFileHandler.close()

#Output:
# number,number puls 2,number times 2
# 0,2,0
# 1,3,2
# 2,4,4
# 3,5,6
# 4,6,8
# 5,7,10
# 6,8,12
# 7,9,14
# 8,10,16
# 9,11,18

{% endhighlight %}

关于directory，filename,path(absolute,relative)的区别请见下图。

{: .img_middle_mid}
![web scraping](/assets/images/posts/2015-12-05/文件系统术语.png)

Python文件的打开模式有主要9种，w+表示可读写，先清除原来内容。

{: .img_middle_lg}
![web scraping](/assets/images/posts/2015-12-05/Python file open mode.png)



一个常见的**Web Scraping**任务是获得HTML table里的数据，然后写进CSV文件。[Wikipedia Comparsion of Text Editors](https://en.wikipedia.org/wiki/Comparison_of_text_editors)提供了一个相当复杂的table，我们尝试用BeautifulSoup和csv module将其写入csv文件。



{% highlight python linenos %}

import os
import csv
from bs4 import BeautifulSoup

from urllib.request import urlopen

def getCSVPath(directory,filename):
    if not os.path.exists(directory):
        os.makedirs(directory)
    return os.getcwd()+"/"+directory+"/" + filename

htmlFileHandler = urlopen("https://en.wikipedia.org/wiki/Comparison_of_text_editors")
bsObj = BeautifulSoup(htmlFileHandler.read(),"html.parser")
tableTag = bsObj.findAll("table",{"class":"wikitable"})[0]
rowTags = tableTag.findAll("tr")

path = getCSVPath("CSV","test.cv")
try:
    csvFile = open(path,'w+')
    writer=csv.writer(csvFile)

    for rowTag in rowTags:
        csvRow=[]
        for cell in rowTag.findAll(('td','th')): #输出所有的td或者th Tag
            csvRow.append(cell.string)
        writer.writerow(csvRow)
finally:
    csvFile.close()


{% endhighlight %}




本部分总结成一张小图。

{: .img_middle_mid}
![web scraping](/assets/images/posts/2015-12-05/csv module.png)

## 3 MySQL ##


> **MySQL**：开放源代码的关系数据库管理系统(relational database management system)。关系数据库(relational database)指比如user A goes to place B，则user A可以在users table里找到，place B可以在places table里找到。**MySQL**是一个非常适合Web Scraping的数据库，我们会在本系列中用到它！

### 3.1 Installing MySQL ###

安装MySQL过程比较简单，有两种。

1. 注册一个oracle账号；

2. 下载 [the installation package](http://dev.mysql.com/downloads/mysql/)(.dmg package)；

3. 双击下载文件安装。

或者terminal输入: ``brew install mysql``。

### 3.2 Some Basic Commands ###

安装完mysql后，在terminal输入: ``mysql -u root -p`` 其中-u表示username，默认是root;-p表示password，默认是root。然后输入密码。MySQL就启动了。

{% highlight python linenos %}

LALdeMacBook-Pro:~ LAL$ mysql -u root -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 9
Server version: 5.7.11 Homebrew

Copyright (c) 2000, 2016, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>

{% endhighlight %}

MySQL的模型总结和基本的增删改查命令总结在下图，如果同学们对深入了解MySQL感兴趣

### 3.3 Integrating with Python ###

### 3.4 Database Techniques and Good Practice ###

### 3.5 "Six Degrees" in MySQL ###

## 4. Email Notification ##

## 5. 总结 ##


{: .img_middle_hg}
![web scraping](/assets/images/posts/2015-12-02/BeautifulSoup进阶.png)

[这里]({{ site.baseurl}}/functional%20programming/2015/10/01/Functional-Programming-in-Scala(一)_λ-演算-Part-I-表达式-函数和赋值.html#calculus)

{% highlight python linenos %}
{% endhighlight %}

## 8 参考资料 ##

- [《BeautifulSoup Documentation》](https://www.crummy.com/software/BeautifulSoup/bs4/doc/);
- [《Python 3 Documentation》](https://docs.python.org/3/);




