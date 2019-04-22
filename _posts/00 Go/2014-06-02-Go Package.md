---
layout: post
title: Go Package Review
categories: [00 Go]
tags: [C]
number: [0.1]
fullview: false
shortinfo: 本文是对Go Package的总结。

---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1 Go ##

### IO ##

#### ioutil

##### func ReadFile(filename string) ([]byte, error)

ReadFile reads the file named by filename and returns the contents. A successful call returns err == nil, not err == EOF. Because ReadFile reads the whole file, it does not treat an EOF from Read as an error to be reported.


{% highlight go linenos %}

{% endhighlight %} 

## 4 总结 ##

{: .img_middle_hg}
![Network overview]({{site.url}}/assets/images/posts/2014-06-01-C Review/Chapter 14 The Preprocessor.png)


## 5 Reference ##

- [《The Go Programming Language》](https://www.amazon.com/Programming-Language-Addison-Wesley-Professional-Computing/dp/0134190440);

- [《Go Documenation》](https://golang.org/doc/)

- [《Go Package](https://golang.org/pkg/)

- [《Effective Go](https://golang.org/doc/effective_go.html)



