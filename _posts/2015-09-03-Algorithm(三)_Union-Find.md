---
layout: post
title: Algorithm(三)： Union-Find 并查集
categories: [Algorithm]
tags: [Union-Find]
number: [-2.2.3]
fullview: false
shortinfo: Union-Find并查集用于检查元素是否属于同一个集合。本文介绍其实现及用其解决一个具体的Percolation问题。
---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1. Union-Find(并查集)介绍 ##
我们先来看下面一个问题:

{: .img_middle_lg}
![Percolation](/assets/images/posts/2015-09-03/percolation.png)
![Percolation](/assets/images/posts/2015-09-03/thresh.png)

上图是一个n*n的网格，起初每个网格都是关闭的（显示黑色）。我们开启一个个网格(白色)。求开启多少个网格后，上面才会和下面联通,即想象网格上面是水流，网格是一个管道，开启的格子可以流水，得平均开启多少个网格后水流才能通过网格流下来。求这个开启网格占总网格的比例。

这里先列出答案，可能会让你惊讶。当n足够大时开启的比例大于0.593时，上下联通; 小于0.593时，上下不联通。这个问题叫渗透(Percolation)问题，可以用于导体和绝缘体的混合比例，社交网络的节点等现实问题。

如何才能求解这样一个具体的问题呢。我们首先介绍Union-Find(并查集)数据结构。


## 2. 并查集 三种实现 ##

那么什么是Union-Find 数据结构呢，它的定义如下:

{% highlight java linenos %}
public abstract class UF {
    protected int[] id;
    protected int count;
    
    public UF(int n){                           //初始化，用数组存储每个节点
        id = new int[n];
        count = n;
        for(int i = 0; i < n; i++){
            id[i] = i;
        }
    }
    public int count(){return count;}           //返回set个数


    public abstract int find(int p);            //返回每个节点的ID
    public boolean connected(int p, int q){     //返回两个节点是否属于一个set，即ID是否相同
        return find(p) == find(q);
    }
    public abstract void union(int p, int q);   //合并两个节点，即两个节点的ID相同
}

{% endhighlight %}

UF有两个实例变量,int[]数组用来存储每个节点(数组的index)和其ID信息(数组的值); count 表示当前有多少个独立的set。
UF主要有三个public方法，`int find(int p)`返回p节点的ID;`boolean connected(int p, int q)`判断两个节点的ID是否一样,一样表示属于同一个set;`void union(int p, int q)`用来合并两个节点，令他们属于一个set。

我们来看看下面三种具体实现。

### 2.1 快查 ###

{% highlight java linenos %}

public class UF_QuickFind extends UF{

    public UF_QuickFind(int n) {
        super(n);
    }

    public int find(int p){                     //p的ID是id[p]
        return id[p];
    }

    public void union(int p, int q){            //将数组里每一个id和pID相同的节点改成qID。
        if(this.connected(p, q)) return;
        int pID = find(p);
        int qID = find(q);
        for(int i = 0; i < id.length; i++){
            if(id[i] == pID) id[i] = qID; 
        }
        count--;
    }
}
{% endhighlight %}

UF_QuickFind的`find`时间复杂度是o(1),`union`也是o(N)。如果我们要合并N个节点使其成为一个set，时间复杂度是o(N<sup>2</sup>)。其空间复杂度是o(N)。

### 2.2 快并 ###
快查的缺点是每一次`union`都要改每一个id和pID相同的节点，我们完全可以用一个tree data structure来代替它，

{% highlight java linenos %}
public class UF_QuickUnion extends UF{

    public UF_QuickUnion(int n) {
        super(n);
    }

    public int find(int p)              //p的id是其根节点，id[p]存储器父节点
    {  
         while (p != id[p]) p = id[p];
         return p; 
    }
    
    public void union(int p, int q)     //合并p和q节点，只需将p的根节点设为q的根节点的子节点
    {
         int i = find(p);
         int j = find(q);
         if (i == j) return;
         id[i] = j;
         count--; 
    }
}
{% endhighlight %}

利用tree，数组id[]存储的信息量更大了。只有自己的父节点是自己的节点才是跟节点。
UF_QuickUnion的`find`时间复杂度是o(N),`union`也是o(N)。如果我们要合并N个节点使其成为一个set，时间复杂度是o(N<sup>2</sup>)。其空间复杂度是o(N)。UF_QuickUnion只在有些情况下`union`比UF_QuickFind快；在最坏的情况下，还是o(N)。合并N个节点使其成为一个set，时间复杂度是o(N<sup>2</sup>)。

### 2.3 快并+权重+路径压缩 ###
虽然UF_QuickUnion并没有比UF_QuickFind在最坏的情况下提高，但是也是一个improvement。在此基础上，我们加入权重，即当union发生时，Descendant少的tree作为Descendant个数多的tree的Child。这样可以保证tree的height(有些地方也叫rank)总是小于log<sub>2</sub>N。我们首先来看下tree的定义：

1. node分三种: root node, inner node, leaf node;
2. depth of node: number of edges from the node to the tree's root node. A root node will have a depth of 0；
3. height of node: number of edges on the longest path from the node to a leaf. A leaf node will have a height of 0；
4. Root: The top node in a tree.
5. Child: A node directly connected to another node when moving away from the Root.
6. Parent: The converse notion of a child.
7. Siblings: Nodes with the same parent.
8. Descendant: A node reachable by repeated proceeding from parent to child.
9. Ancestor: A node reachable by repeated proceeding from child to parent.

{: .img_middle_lg}
![Percolation](/assets/images/posts/2015-09-01/tree.png)

然后我们来看下`UF_WieghtedQuickUnion`的实现:

{% highlight objc linenos %}

public class UF_WieghtedQuickUnion extends UF{

    private int[] sz;                           //extra int[] sz存储每个节点的子孙个数(包括自己)

    public UF_WieghtedQuickUnion(int N){
        super(N);
        sz = new int[N];
        for (int i = 0; i < N; i++) sz[i] = 1;
    }

    public int find(int p){                     //和快查一样，查跟节点.
       while (p != id[p]) p = id[p];
       return p; 
    }
    
    public void union(int p, int q){            //让sz小的tree作为sz大的tree的children，而不是反过来
       int i = find(p);
       int j = find(q);
       if (i == j) return;
       // Make smaller root point to larger one.
       if   (sz[i] < sz[j]) { id[i] = j; sz[j] += sz[i]; }
       else count--; 
       }
}

{% endhighlight %}

权重的好处是包含n个节点的树的高度 < log<sub>2</sub>N。使得`find`的时间复杂度从o(N)降到o(log<sub>2</sub>N); `union`也从o(N)降到o(log<sub>2</sub>N);合并N个节点使其成为一个set，时间复杂度是o(log<sub>2</sub>N)。

可以再improve加上路径压缩: 每一次`find`,就将其设为Root的Child。只需添加一行code

{% highlight objc linenos %}
...
    public int find(int p){                     
       while (p != id[p]) {
        id[p] = id[id[p]];              //将pnode的Parent's Parent不断往上移，直到移到root。
        p = id[p];
        
       }
       return p; 
    }
...
{% endhighlight %}

### 2.4 三种时间空间复杂度比较 ###


{: .img_middle_lg}
![Percolation](/assets/images/posts/2015-09-01/Union_Find_complexity.png)

## 3 Percolation 问题解答 ##

下面我们回过头来看Percolation的问题,它给定公共API如下：

{% highlight objc linenos %}
public class Percolation {
   public Percolation(int N)               // create N-by-N grid, with all sites blocked
   public void open(int i, int j)          // open site (row i, column j) if it is not open already
   public boolean isOpen(int i, int j)     // is site (row i, column j) open?
   public boolean isFull(int i, int j)     // is site (row i, column j) full?
   public boolean percolates()             // does the system percolate?

   public static void main(String[] args)  // test client (optional)
}
{% endhighlight %}

解题思路: 我们将int[N][N]2维数组映射到一个一维int[N<sup>2</sup>+2]数组(WQUUF(N<sup>2</sup>+2)里的数组表示)。一维多出来的两个分别是virtual top和 virtual bottom。open函数里，如果该网格在第一排，则union(0,xyTo1D(i,j));第N排，则union(N<sup>2</sup>+1,xyTo1D(i,j));其他情况若neighbour开启，则union。这里有一个倒流的情况，因此得额外加一个WQUUF(N<sup>2</sup>+1)，少了virtual bottom，来实现isFull。还得用一个二维布尔数组boolean[][]来存储开启关闭情况。具体code如下。





{% highlight objc linenos %}
import edu.princeton.cs.algs4.WeightedQuickUnionUF;

public class Percolation {
    
    private boolean[][] open;               //存储开启关闭
    private int dimension;                  //N
    private WeightedQuickUnionUF uf;        //virtual top & virtual bottom
    private WeightedQuickUnionUF uf_back;   //virtual top only
    private int top;                        //top index
    private int bottom;                     //bottom index

    public Percolation(int N){          // create N-by-N grid, with all sites blocked
        if(N < 0) throw new IllegalArgumentException("N must be bigger than 0");
        dimension = N;
        open = new boolean[N][N];
        uf = new WeightedQuickUnionUF(N*N + 1);     //virtual top 
        uf_back = new WeightedQuickUnionUF(N*N+2);  //virtual top and bottom;
        top = 0;
        bottom = N*N+1;                                 //0 1, 2, ...10
                                                        //  11,12,...20;
                                                        //  91,92,...100; 101
    }  
    
    public void open(int i, int j){     // open site (row i, column j) if it is not open already
        this.validateInput(i, j);
        if(isOpen(i,j)) return;
        open[i-1][j-1] = true;

        if(i == 1){
            uf.union(top, this.xyTo1D(i, j));
            uf_back.union(top, this.xyTo1D(i, j));

        }
        if(i == dimension){
            uf_back.union(bottom, this.xyTo1D(i, j));
        }
        
        if(validateNeighbour(i-1,j) && isOpen(i-1,j)){//up
            uf.union(this.xyTo1D(i-1, j), this.xyTo1D(i, j));
            uf_back.union(this.xyTo1D(i-1, j), this.xyTo1D(i, j));

        }
        
        if(validateNeighbour(i+1,j) && isOpen(i+1,j)){//down
            uf.union(this.xyTo1D(i+1, j), this.xyTo1D(i, j));
            uf_back.union(this.xyTo1D(i+1, j), this.xyTo1D(i, j));

        }
        
        if(validateNeighbour(i,j-1) && isOpen(i,j-1)){//left
            uf.union(this.xyTo1D(i, j-1), this.xyTo1D(i, j));
            uf_back.union(this.xyTo1D(i, j-1), this.xyTo1D(i, j));

        }
        
        if(validateNeighbour(i,j+1) && isOpen(i,j+1)){//right
            uf.union(this.xyTo1D(i, j+1), this.xyTo1D(i, j));
            uf_back.union(this.xyTo1D(i, j+1), this.xyTo1D(i, j));
        }
    }   
    
    public boolean isOpen(int i, int j){ // is site (row i, column j) open?
        return open[i-1][j-1];
    }     
    
    public boolean isFull(int i, int j){ // is site (row i, column j) full?
           return uf.connected(this.xyTo1D(i, j), top);
    }    
    
    public boolean percolates(){            // does the system percolate?
           return uf_back.connected(top, bottom);
    }              
    
    //helper
    public boolean validateNeighbour(int i, int j){
        boolean val = true;
        if(i < 1 || i > dimension || j < 1 || j > dimension){
            val = false;
        }
        return val;
    }
    
    public void validateInput(int i, int j){

        if(i < 1 || i > dimension || j < 1 || j > dimension){
            throw new IllegalArgumentException("The input i,j must be between 1 and N!");
        }
    }
    
    public int xyTo1D(int i, int j){
        validateInput(i,j);
        return (i-1) * dimension + j;
    }
    
    public static void main(String[] args){
        Percolation percolation = new Percolation(5);
        percolation.open(1,2);
        percolation.open(2,2);
        percolation.open(3,2);
        percolation.open(4,2);
        percolation.open(5,2);
        System.out.println("percolates " + percolation.percolates());
    }  
}

{% endhighlight %}


测试程序：
{% highlight objc linenos %}


import edu.princeton.cs.algs4.WeightedQuickUnionUF;
import edu.princeton.cs.algs4.StdRandom;
import edu.princeton.cs.algs4.StdStats;
import edu.princeton.cs.algs4.Stopwatch;
import java.math.*;

public class PercolationStats {
    
    private double[] probabilityResult; //存储一次percolates的概率p
    private int time;
    private int dimension;
    
    public PercolationStats(int N, int T){ //Perform T independent experiments on an N-by-N grid
        this.probabilityResult = new double[T];
        this.dimension = N;
        this.time = T;
        
        for(int i = 0; i < T; i++){
            this.probabilityResult[i] = this.performOnePercolation(N);
        }
    }
    
    public double mean(){                   //sample mean of percolation threshold
        return StdStats.mean(this.probabilityResult);
    }
    
    public double stddev(){                 //sample standard deviation of percolation threshold
        return StdStats.stddev(this.probabilityResult);
    }
    
    public double confidenceLo(){           //low endpoint of 95% confidence interval
        double mean = this.mean();
        double stddev = this.stddev();
        return mean-1.96*stddev/Math.sqrt((double)this.time);
    }
    
    public double confidenceHi(){           //high endpoint of 95% confidence interval
        double mean = this.mean();
        double stddev = this.stddev();
        return mean+1.96*stddev/Math.sqrt((double)this.time);
    }
    
    public double performOnePercolation(int N){
        Percolation percolation = new Percolation(N);
        int randomX;
        int randomY;
        int totalOpen = 0;
        while(!percolation.percolates()){
            randomX = StdRandom.uniform(1, N+1);
            randomY = StdRandom.uniform(1, N+1);
            if(!percolation.isOpen(randomX,randomY)){
                totalOpen++;
                percolation.open(randomX, randomY);
            }
        }

        double probability =  (double)((double)totalOpen/(N*N));
        return probability;
    }
    
    public static void main(String[] args){
        int T = 10000;
        int N = 512;
        for(int n = 2; n <=N; n = n*2 ){
            Stopwatch stopwatch = new Stopwatch();
            PercolationStats percolationsStats = new PercolationStats(n,T);
            String str = String.format("%04d", n);
            System.out.printf("case: n_%s, t_%d。Elapse time: %09.4f---",str,T, stopwatch.elapsedTime());
            System.out.printf("mean: %.4f; ", percolationsStats.mean());
            System.out.printf("stddev: %.4f; ", percolationsStats.stddev());
            System.out.printf("confidential range: <%.4f,%.4f>; \n", percolationsStats.confidenceLo(),percolationsStats.confidenceHi());
        }
    }  
    
}



{% endhighlight %}

输出：
{% highlight objc linenos %}

//case: n_0002, t_10000。Elapse time: 0000.0900---mean: 0.6659; stddev: 0.1181; confidential range: <0.6635,0.6682>; 
//case: n_0004, t_10000。Elapse time: 0000.0340---mean: 0.5994; stddev: 0.1100; confidential range: <0.5972,0.6015>; 
//case: n_0008, t_10000。Elapse time: 0000.0750---mean: 0.5903; stddev: 0.0825; confidential range: <0.5887,0.5919>; 
//case: n_0016, t_10000。Elapse time: 0000.1920---mean: 0.5909; stddev: 0.0565; confidential range: <0.5898,0.5920>; 
//case: n_0032, t_10000。Elapse time: 0000.6610---mean: 0.5923; stddev: 0.0352; confidential range: <0.5916,0.5930>; 
//case: n_0064, t_10000。Elapse time: 0002.5170---mean: 0.5923; stddev: 0.0219; confidential range: <0.5919,0.5928>; 
//case: n_0128, t_10000。Elapse time: 0010.8520---mean: 0.5925; stddev: 0.0137; confidential range: <0.5922,0.5928>; 
//case: n_0256, t_10000。Elapse time: 0048.5120---mean: 0.5929; stddev: 0.0081; confidential range: <0.5927,0.5930>; 
//case: n_0512, t_10000。Elapse time: 0385.7060---mean: 0.5927; stddev: 0.0048; confidential range: <0.5926,0.5928>;
//

{% endhighlight %}



## 4 总结 ##
本文用我们用Union-Find 并查集实现了Percolation threshhold p = 0.593的计算。Good Code = Algorithm + Data Structure 这句话我们有了更深入的认识。好的数据结构和算法可以降低程序的时间复杂度，使不可能的计算任务变为可能; 单单增加计算机运算速度是不能解决问题，因为同时你可以处理的数据大小也增加了。现对Week 1总结如下:

1. Union-Find利用quick union + weighted + path compression 可以将Union和Find的时间复杂度从O(N)降为log<sub>2</sub>N;
2. 我们用这个WQUUF数据结构处理了Percolation问题，并得到了概率阈值 p = 0.593;


## 5 参考资料 ##
- [Algorithm](http://algs4.cs.princeton.edu/home/);

- [Visualize Algorithm](http://visualgo.net/);





