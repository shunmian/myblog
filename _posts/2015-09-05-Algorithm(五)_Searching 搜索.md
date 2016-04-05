---
layout: post
title: Algorithm(五)： Searching 搜索
categories: [Algorithm]
tags: [Searching]
number: [-2.2.4]
fullview: false
shortinfo: Searching 搜索是现代计算机和互联网的基础。本文介绍搜索算法的前世今生。
---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1. 搜索介绍 ##

## 2. 搜索算法 ##

{% highlight java linenos %}

{% endhighlight %}
{: .img_middle_lg}
![Sorting Algorithms](/assets/images/posts/2015-09-04/sorting algorithm.png)

### 2.1 顺序搜索(无序链表)实现 ###

{% highlight java linenos %}
public class SequentialSearchST<Key, Value>{}
    private Node first;         // first node in the linked list
    private class Node{
        // linked-list node
        Key key;
        Value val;
        Node next;
    
        public Node(Key key, Value val, Node next){
            this.key  = key;
            this.val  = val;
            this.next = next;
        } 
    }

     public Value get(Key key){  // Search for key, return associated value.
        for (Node x = first; x != null; x = x.next)
           if (key.equals(x.key))
              return x.val;    // search hit
        return null;           // search miss
    }

     public void put(Key key, Value val){  // Search for key. Update value if found; grow table if new.
        for (Node x = first; x != null; x = x.next)
           if (key.equals(x.key)){  
            x.val = val; return;  }      // Search hit: update val.
        first = new Node(key, val, first); // Search miss: add new node.
     }
}
{% endhighlight %}


Inserting N distinct keys into an initially empty linked-list symboltable uses ~N<sup>2</sup>>/2 compares.


### 2.2 二分法搜索(有序数组)实现 ###

{% highlight java linenos %}
public class BinarySearchST<Key extends Comparable<Key>, Value> {
    private int N;
    private Key[] keys;
    private Value[] values;
        
    public BinarySearchST(int capacity){
        this.keys =(Key[]) new Comparable[capacity];
        this.values = (Value[]) new Object[capacity];
    }
    
    public int size(){
        return N;
    }
    
    public boolean isEmpty(){
        return size() == 0;
    }
    
    public int rank(Key key){ //// get the rank of current key in a ordered array using binary search
        int lo = 0;
        int hi = N-1;
        while(lo <= hi){
            int mid = lo + (hi-lo)/2;
            int cmp = key.compareTo(keys[mid]);
            if(cmp < 0) hi = mid-1;
            else if(cmp > 0) lo = mid + 1;
            else return mid;
        }
        return lo;
    }
    
    public Value get(Key key){
        if(isEmpty()) return null;
        int i = rank(key);
        if(i<N && keys[i].compareTo(key) == 0) return values[i];
        else return null;
    }
    
    public void put(Key key, Value value){
        int i = rank(key);
        if(i<N && keys[i].compareTo(key) == 0) {values[i] = value; return;}
        for(int j = N; j > i; j--){
            keys[j] = keys[j-1];
            values[j] = values[j-1];
        }
        values[i] = value;
        keys[i] = key;
        N++;
    }
    
    public Iterable<Key> keys()  {
        Iterable<Key> iterable = Arrays.asList(keys);
        return iterable;
    }
}
{% endhighlight %}

binary search(by ordered array)Inserting a new key into an ordered array of size N uses ~ 2N array accesses in the worst case, so inserting N keys into an initially empty table uses ~ N 2 array accesses in the worst case.

### 2.3 二叉搜索树实现 ###


## 4 总结 ##

本文介绍了6种经典的排序方法: 

1. 基础排序: 选择排序和插入排序；
2. 希尔排序(插入排序基础上);
3. 合并排序和快速排序(分而治之);
4. 二叉堆排序(二叉树结构)。

## 5 参考资料 ##
- [Algorithm](http://algs4.cs.princeton.edu/home/);

- [Visualize Algorithm](http://visualgo.net/);





