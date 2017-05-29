---
layout: post
title: EOC(四)：Protocols and Categories
categories: [01 Objective-C]
tags: [Effective]
number: [01.25.1]
fullview: false
shortinfo: 本文是《Effective Objective-C》的系列笔记的第四篇《IProtocols and Categories》，对应书本的第四章。
---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1 Protocols and Categories ##

### Item 23：Use Delegate and Data Source Protocols for Interobject Communication ###

1. Use `Data Source` to provide data to client object;
2. Use `Delegate` to responds to client object's event;
3. Including `client object` parameter in protocol methods so that one `Data Source` or `Delegate` can responds to multiple `client object`

{% highlight objc linenos %}
-(void)networkFecher:(EOCNetworkFecther *)fecher
      didReceiveData:(NSData*)data{
    if(fetcher == self.myFetcherA){
        //Handle data
    }else{
        //Handle data
    }
}

{% endhighlight %}

### Item 24: Use Categories to Break Class Implementations into Manageable Segments ###

### Item 25: Always Prefix Category Names on Third-Party Classes ###

### Item 26: Avoid Properties in Categories ###

### Item 27: User the Class-Continuation Category to Hide Implementation Detail ###

### Item 28: Use a Protocol to Provide Anonymous Objects ###






{: .img_middle_hg}
![NSOperation & NSOperationQueue总结](/assets/images/posts/01 Objectiev C/2016-04-07-OC Concurrency(三)_NSOperation part I_用法详解/NSOperation & NSOperationQueue总结.png)


## 2 Reference ##

- [《Effective Objective-C 2.0: 52 Specific Ways to Improve Your iOS and OS X Programs (Effective Software Development Series)》](https://www.amazon.com/Effective-Objective-C-2-0-Specific-Development/dp/0321917014);


