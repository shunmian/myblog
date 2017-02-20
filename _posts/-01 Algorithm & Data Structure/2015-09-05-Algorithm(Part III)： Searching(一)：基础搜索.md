---
layout: post
title: Algorithm(Part III)： Searching(一)：基础搜索 
categories: [-01 Algorithm]
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
![Sorting Algorithms](/assets/images/posts/2015-09-05/searching performance0.png)

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

小结: 2.1顺序搜索(无序链表)实现和2.2二分法搜索(有序数组)实现的peformance总结如下表:



我们能否可以实现某种算法使得insert和search都是O(logN)的时间复杂度？ 答案是YES！这要用到下面介绍的二叉树(binary search tree) by using array(O(logN)) search advantage and linked list quick insertion advantage.

### 2.3 二叉搜索树实现 ###

binary search tree combines the flexibility of insertion in a linked list with the efficiency of search in an ordered array. Use two links per node(instead of the one link per node found in linked lists).

> <b>Binary Search Tree(BST)</b>: a binary tree where each node has a Comparabe key (and an associated value) and satisfies the restriction that the key in any node is larger than the keys in all nodes in that node's left subtree and smaller than the keys in all nodes in that node's right subtree.

{: .img_middle_mid}
![Binary Tree](/assets/images/posts/2015-09-05/binary tree.png)
![Binary Search Tree](/assets/images/posts/2015-09-05/binary search tree.png)




{% highlight java linenos %}
public class BST<Key extends Comparable<Key>,Value>  {
    
    Node root = null;
    
    class Node{
        Key key;
        Value val;
        int N;
        Node left;
        Node right;

        public Node(Key key, Value value, int N){
            this.key = key;
            this.val = value;
            this.N = N;
        }
    }
    
    public Value get(Key key){
        return get(root, key);
    }
    
    private Value get(Node x, Key key){
        if(x == null) return null;
        int cmp = x.key.compareTo(key);
        if(cmp < 0) return get(x.right, key);
        else if(cmp > 0) return get(x.left, key);
        else return x.val;
    }
    
    
    public void put(Key key, Value value){
        put(root, key, value);
    }
    
    private Node put(Node x, Key key, Value val){
        if (x == null) return new Node(key, val, 1);
        int cmp = key.compareTo(x.key);
        if      (cmp < 0) x.left  = put(x.left,  key, val);
        else if (cmp > 0) x.right = put(x.right, key, val);
        else x.val = val;
        x.N = size(x.left) + size(x.right) + 1;
        return x;
    }
}
{% endhighlight %}

Search hits in a BST built from N random keys require ~ 2lnN compares on the average, correspondence to QuickSort partitioning. But the worst case is that it is not balanced which requires N compares。

{: .img_middle_mid}
![Binary Tree](/assets/images/posts/2015-09-05/binary search tree situation.png)



### 2.4 平衡二叉搜索树(红黑树)实现###

2.3二叉搜索树在average case下insert/search 时间复杂度是O(logN)，但是在worst-case下是O(N)。如何保证在任何情况下insert/search 都是O(logN)呢。这就是我们要介绍的平衡二叉搜索树。理想情况下，我们想要保持我们的binary search tree perfectly balanced使得所有的search 时间复杂度都是O(logN)。但是不幸的是，保持perfectly blanaced 需要通过昂贵的insertion操作。因此我们变通一下，下面介绍 2-3 search tree。 

<blockquote><b>2-3 search tree (2-3搜索树)</b>: is either
<ul>
<li>a tree that is empty; </li>
<li>a 2-node with one key (and associated value) and two links, a left link to a 2-3 search treee with smaller keys, and a right link to a 2-3 search tree with larger keys; </li>
<li>a 3-node, with two keys (and associated values) and three links, a left link to a 2-3 search tree with smaller keys, a middle link to a 2-3 search tree with keys between the node's keys, and a right link to a 2-3 search tree with larger keys。</li>
</ul>
</blockquote>

{: .img_middle_mid}
![Binary Tree](/assets/images/posts/2015-09-05/2-3 search tree2.png)

2-3 search tree 的实现并不困难，但是有一种更为易懂的实现叫做Red-black BST。

<blockquote><b>Red-black BST(红黑二叉搜索树)</b>: 
<ul>
<li>represent 2-3 tree as a BST; </li>
<li>use "internal" left-leaning links as "glue" for 3-nodes;</li>
<li>every path from root to null link has the same number of black links(perfect black balance).</li>
</ul>
</blockquote>

2-3 tree 有一个极好的特性是: every path from root to null link has same length.

{: .img_middle_mid}
![Binary Tree](/assets/images/posts/2015-09-05/red-black BST.png)
![Binary Tree](/assets/images/posts/2015-09-05/red-black BST2.png)


我们先定义三种基本操作，

{: .img_middle_lg}
![Binary Tree](/assets/images/posts/2015-09-05/red-black BST 3 basic operatoin.png)




{% highlight java linenos %}
public class RedBlackBST<Key extends Comparable<Key>, Value>{
    private Node root;
    private class Node // BST node with color bit (see page 433)
    private boolean isRed(Node h)    
    private Node rotateLeft(Node h)  
    private Node rotateRight(Node h) 
    private void flipColors(Node h)  
    private int size()               

    public void put(Key key, Value val){  // Search for key. Update value if found; grow table if new.
        root = put(root, key, val);
        root.color = BLACK;
    }

    // get remain untouched.
    public Value get(Key key) {
        return get(root, key);
    }

   
    private Value get(Node x, Key key) {
        while (x != null) {
            int cmp = key.compareTo(x.key);
            if      (cmp < 0) x = x.left;
            else if (cmp > 0) x = x.right;
            else              return x.val;
        }
        return null;
    }

    private Node put(Node h, Key key, Value val){
    if (h == null)return new Node(key, val, 1, RED);  // Do standard insert, with red link to parent.
    int cmp = key.compareTo(h.key);
    if      (cmp < 0) h.left  = put(h.left,  key, val);
    else if (cmp > 0) h.right = put(h.right, key, val);
    else h.val = val;

    if (isRed(h.right) && !isRed(h.left))    h = rotateLeft(h);
    if (isRed(h.left) && isRed(h.left.left)) h = rotateRight(h);
    if (isRed(h.left) && isRed(h.right))     flipColors(h);
    h.N = size(h.left) + size(h.right) + 1;
    return h; 
    }
}
{% endhighlight %}

下图是几种操作例子。

{: .img_middle_mid}
![Binary Tree](/assets/images/posts/2015-09-05/red-black BST example.png)



红黑二叉搜索树的height is no more than 2lgN, N is the number of total nodes. In worst case & average case, search/insert O(lgN).

### 2.5 哈希表实现 ###

> Hash Function: computing array index(Hash Code) based on key.

哈希函数:

1. all class in java implements a method hashCode(), which retunrs 32-bit int. 
2. Default implementation is the memeory address.
3. Java customized some typical class such as Integer, Double, String, URL, Date...

{: .img_middle_lg}
![Binary Tree](/assets/images/posts/2015-09-05/hashCode implementation.png)

实现哈希表需要注意一下几点：
1. Collision Resolution, 当两个key产生同一个Hash Code时;
2. Equality Test, checking whether two keys are equal.

对于Collision Resolution, 通常两种方法, Separate Chaining和Linear Probing.

#### 2.5.1 单独链表法 ####

{: .img_middle_mid}
![Binary Tree](/assets/images/posts/2015-09-05/hash separate chaining.png)

{% highlight java linenos %}

public class SeparateChainingHashST<Key,Value>  {
    private int M = 97;                         // number of chains
    private Node[] st = (Node[]) new Object[M]; // array of chains
    
    class Node{
        private Object key;
        private Object value;
        private Node next;
        
        public Node(Key key, Value value, Node x){
            this.key = key;
            this.value = value;
            Node old = x;
            x = this;
            this.next = old;
        }
    }
    
    private int hash(Key key){
        return (key.hashCode() & 0x7fffffff) % M; //omit sign bit, and convert into array index
    }
    
    private Value get(Key key){
        int i = hash(key);
        for (Node x = st[i]; x!= null; x = x.next)
            if(key.equals(x.key)) return (Value)x.value;
        return null;
    }
    
    public void put(Key key, Value value){
        int i = hash(key);
        for (Node x = st[i]; x!=null; x= x.next)
            if(key.equals(x.key)) {
                x.value = value; return;
            }
        st[i] = new Node(key, value, st[i]);
    }
}
{% endhighlight %}


#### 2.5.2 线性探查法 ####



{: .img_middle_mid}
![Binary Tree](/assets/images/posts/2015-09-05/hash linear probing.png)



{% highlight java linenos %}
public class SeparateChainingHashST<Key,Value>  {
    
    private int M = 30000;                          
    private Value[]  vals = (Value[]) new Object[M];
    private Key[]    keys = (Key[])   new Object[M]; 
    
    private int hash(Key key){
        return (key.hashCode() & 0x7fffffff) % M; //omit sign bit, and convert into array index
    }
    
    private Value get(Key key){
        for (int i = hash(key); keys[i] != null; i = (i+1) % M)
            if(keys[i].equals(key))
                return vals[i];
        return null;
    }
    
    
    public void put(Key key, Value value){
        int i;
        for (i = hash(key); keys[i] != null; i = (i+1) % M)
            if(keys[i].equals(key)) break;
        keys[i] = key;
        vals[i] = value;
    }
}
{% endhighlight %}


## 3 application ##

搜索算法有着广泛的应用，除了搜索想要的key所对应的value，还能用于图形搜索。例如

1. 1d range search;
2. line segment intersection;
3. kd-tree;
4. interval search trees。


{: .img_middle_lg}
![Binary Tree](/assets/images/posts/2015-09-05/search application.png)




## 4 总结 ##

本文介绍了6种经典的搜索方法来实现Symbol Table: 

1. 顺序搜索(无序链表)实现
2. 二分法搜索(有序数组)实现
3. 二叉搜索树实现
4. 平衡二叉搜索树(红黑树)实现
5. 哈希表实现(单独链表法 & 线性探查法)

其中哈希表的搜索在最坏的情况下是~lg(N)，在最好的情况下是~O(1)，是5个算法中最优的算法。但是需要注意hashCode冲突的情况。



## 5 参考资料 ##
- [Algorithm](http://algs4.cs.princeton.edu/home/);

- [Visualize Algorithm](http://visualgo.net/);





