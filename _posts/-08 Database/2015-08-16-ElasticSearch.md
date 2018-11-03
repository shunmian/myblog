---
layout: post
title: ElasticSearch
categories: [-08 Database]
tags: [Database,ElasticSearch]
number: [-6.1.1]
fullview: false
shortinfo: ElasticSearch

---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1 MongDO介绍 ##

1. scalable than mysql

2. 

### 1. Quick start

#### 1.1 Install

`brew install mongodb`

#### 1.2 Start server

`mongod`

#### 1.3 Connect to server

`mongo --host 127.0.0.1:27017`

基本操作

0. **DB**: 查所有`show dbs`, 查当前`db`; 增`use mynewdbname`

1. **User**: 查所有`show users`， 增```db.createUser({
  user: "brad",
  pwd: "1234",
  roles: ["readWrite", "dbAdmin"]
});```

2. **Collection (Table)**: 查所有`show collections`, 增`db.createCollection('customer')`,

3. **Document (Row)**: 增`db.customers.insert({first_name: "John", last_name: "Doe"});`

## 2 总结

{: .img_middle_lg}
![regular expression](/assets/images/posts/2015-06-01/MySQL overview.png)

{% highlight mysql linenos %}

{% endhighlight %}



## 3 参考资料 ##
- [《MongoDB》](https://www.mongodb.com/cn);






