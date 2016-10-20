---
layout: post
title: Algorithm(三)： Sorting 排序 part I
categories: [-01 Algorithm]
tags: [Sorting]
number: [-1.3]
fullview: false
shortinfo: 排序是computer science 一个基础而有富有挑战的课题。排序算法是人类智慧的体现，不同的排序算法时间复杂度可以从N<sup>2</sup>>到NlogN。本文介绍6种排序算法，从基础到复杂，让我们体会一下排序算法的魅力。
---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1. 排序介绍 ##

在以前的程序里，排序程序占用的时间大约是总程序时间的30%。可以看到排序是基础而又被广泛应用的算法。现在排序算法的时间比重比30%小，这并不意味着排序算法的重要性在降低，相反这是更有效的排序算法的功劳。本文带我们从基础到复杂，领略6种排序算法的思想，实现，时间空间复杂度和稳定性。

**基于比较的排序(Comparison Sort)**是算法中不可绕过的重要内容，核心地位不必赘述，如果从信息论的角度看，Comparison Sort就是找到一种恰当的策略，使得每次做完比较之后，能够获取的信息量最大。下面举一个栗子。

> 猜数字游戏，请用最少的次数猜出一个在1-100中的数字。

为了让获取的信息量最大，容易知道必须让一次比较确定下来的东西尽可能多，要达到合格目的最好的办法就是让比较后可能产生的两种结果的概率均等。在上面的栗子中，如果问这个数字**是否大于50？**这样的话一旦结果确定，就砍去了一半的可能性，获取的信息量最大。

类似的道理，对于12个球的**称重问题**：

> 有12个外观一模一样的球，其中有一个的质量和其余12个不一样，记为X，请用一个天平以最少的比较次数找出球X。

之所以不用6-6的比较方式，是因为这么做产生的结构是确定的可预测的，肯定是不平衡；相比之下如果用4-4的比较方法，产生的三种结果左倾，右倾，平衡的概率是完全相等的，这样就充分利用了这次试探的机会，获取了最大的信息量。
进一步的阅读请参照[这里](http://mindhacks.cn/2008/06/13/why-is-quicksort-so-quick/)和[这里](http://users.aims.ac.za/~mackay/sorting/sorting.html)。

接下来将要介绍若干种基本的排序算法，如下表所示。

{: .img_middle_lg}
![Sorting Algorithms](/assets/images/posts/2015-09-03/sorting algorithm.png)



### 1.1 Total Order & Partial Order ###
在介绍具体的算法之前，首先需要介绍一些基本的概念和Java的实现。
既然是排序，首先要明确**顺序**的确切含义。我们常说的**顺序**是一种**二元关系**，其中**全序关系(Total Order)**和**偏序关系(Partial Order)**是较为常见的两种。先盗一张wiki上的图。

{: .img_middle_mid}
![Order](/assets/images/posts/2015-09-03/order.png)


如上所示就是一个按包含排序的偏序关系，我们发现虽然集合x,y和集合y,z都包含集合y，但是他们之间并不存在包含关系，也就是说，偏序其实并**不要求**所有的元素都**可互相比较**，其强调的只是一种继承关系，一般来说可以与**有向无环图(DAG)**一一对应起来。数学上形式化定义的**非严格偏序**如下所示：

+ a ≤ a (自反性 reflexivity)
+ if a ≤ b and b ≤ a then a = b (反对称性 antisymmetry)
+ if a ≤ b and b ≤ c then a ≤ c (传递性 transitivity)

传递性这个比较有意思，我们小时候常玩的**石头剪刀布**，仔细想想，其实就是intransitivity的，对应于上图就是出现了**环**，因此不是DAG图。

而全序关系与偏序关系比较起来，少了自反省，多了**完全性**

+ either a ≤ b or b ≤ a or both (完全性 totality)

这么一对比就看出了全序和偏序的区别了，值得注意的是，全序关系也是一种偏序关系。对于排列问题，由于要确定每个元素的大小关系，因此要求设计的Comparator满足全序关系。另外在本文介绍的排序如果不作特别说明都是按照**从小到大**的顺序。

对于一个排序算法而言，必须要有几个指标来考量算法的优劣：

+ **inplace?** 直观上说，就是算法是否需要开辟额外的空间，这里的额外有严格的数学定义，即**more than clogN space**。由此可见，即使需要开辟额外的空间为linear(如mergesort)，算法也不能称为inplace。
+ **stable?** 对于相同的元素，排序后其相对应位置是否和排序前一致，如果一致则陈伟stable。
+ **worst, average, best cases。**顾名思义，就是分别就三种情况讨论算法的时间复杂度。


### 1.2 Java Implementation ###
在Java中涉及元素的比较一般使用**Comparable**和**Comparator**接口，前者的定义非常简单，只需要实现**compareTo**函数即可，如下所示：

{% highlight java linenos %}
public interface Comparable<Key>{
    public int compareTo(Key that);
}
{% endhighlight %}
在使用过程中直接调用即可
{% highlight java linenos %}
item1.compareTo(Item2);
{% endhighlight %}

与Comparable只传入一个参数不同，**Comparator**更像一个操作符，要求传入两个对象，然后比较这两个对象的大小，如下所示：

{% highlight java linenos %}
public interface Comparator<Key>{
    public int compare(Key o1, Key o2);
    public boolean equals(Object obj);      //可以不实现
}
{% endhighlight %}

下面总结一下Comparable和Comparator的区别和联系:

1. **Comparable**是排序接口，如果该类实现了**Comparable**接口，就意味着**“该类支持排序”**，相当于**内部比较器**;
2. **Comparator**是比较器，若我们需要比较某个类的次序，可以建立一个**“该类的比较器”**进行排序，相当于**外部比较器**。

如果一个类实现了上述的两个接口之一，就可以方便的利用Java框架的**java.util.Arrays**进行数组排序了。

+ **Array.sort(Comparable[] a)**，这个时候的a元素，需要实现Comparable接口；
+ **Array.sort(Object[] a，Comparator comparator)**，这个时候需要实现一个Comparator来定义如何比较a中的元素。



有了这两种比较方法，编程就变得非常方便，因为对于某一类型的数组，可以通过传入不同的Comparator来得到不同定义下的相对大小关系。值得注意的是，在调用上述两个函数过程中，对于Object对象，Java会用Merge Sort，对于Primitive原始类型，Java会使用Quick Sort。算法细节及原因将会在后文介绍。


## 2. 排序算法 ##

{% highlight java linenos %}
public class Example{
        
    public static void sort(Comparable[] a){
     /* see 2.1, 2.2, 2.3, 2.4, 2.5, 2.6*/
    }
    
    public static boolean isSorted(Comparable[] a){     
        // test weather the array entry is in order
        for (int i = 1; i < a.length; i++){
            if(less(a[i],a[i-1])) return false;
        }
        return true;
    }
    
    private static boolean less(Comparable v, Comparable w){
        return v.compareTo(w) < 0;
    }
    
    private static void exchange(Comparable[] a, int i, int j){
        Comparable temp = a[i];
        a[i] = a[j];
        a[j] = temp;
    }
    
    private static void show(Comparable[] a){
        // print the array, on a single line.
        for(int i = 0; i < a.length; i++){
            StdOut.print(a[i] + " ");
        }
        StdOut.println();
    }

    public static void main(String[] args) {
        // Read strings from standard input, sort them, and print
        String[] a = StdIn.readAllStrings();
        sort(a);
        assert isSorted(a);
        show(a);
    }
}
{% endhighlight %}

### 2.1 选择排序 ###
 > 选择排序(Selection Sort): 每次迭代过程中选出最小的元素，并且与当前迭代的位置进行交换，循环往复直到数组末尾。

{% highlight java linenos %}
public class SelectionSort {
    public static void sort(Comparable[] a){
        int N = a.length;
        for(int i = 0; i < N; i++){
            int min = i;
            for(int j = i+1; j < N; j++){
                if(less(a[j],a[min])) min = j; 
            }
            exchange(a,i,min);
        }
    }
}
{% endhighlight %}

就像每个人都有较为稳定的性格一样，每一种排序算法之所以不一样，是因为它们保持的**循环不变式(Invariant)**是不一样的。对于插入排序而言，假设当前迭代位置是↑，那么不难发现以下两个不变性质：

+ ↑左侧的元素都是有序的；
+ ↑右侧的元素皆不小于↑左侧的元素。

算法复杂度不难算出是O(N<sup>2</sup>)，确切来说是:

+ ~ N<sup>2</sup>/2 compares；
+ ~ N exchanges。

虽然选择排序的比较次数(compares)不尽如意，即便是已经排好顺序的数据也一视同仁地比较N<sup>2</sup>/2次，但是交换次数(exchanges)是所有排序算法中最少的，没有比一步到位更快的了。另外，由于在交换过程中靠前的元素会被换到后面，因此选择排序是unstable的；由于仅需要常数的额外空间做交换中介，因此是原地排序(inplace)。

### 2.2 插入排序 ###

> 插入排序(Insertion Sort): 类比理牌，每次我们抓了一张新牌，都会寻找合适的位置把牌插入，使得新得到的牌组依旧满足递增的性质，直到所有牌都插入完毕，这个过程就是插入排序.

{: .img_middle_mid}
![Cards](/assets/images/posts/2015-09-03/cards.png)

{% highlight java linenos %}
public class InsertionSort {
    public static void sort(Comparable[] a){
        int N = a.length;
        for(int i = 0; i < N; i++){
            for(int j = i; j > 0 && less(a[j],a[j-1]); j--){
                exchange(a,j,j-1);
            }
        }
    }
}
{% endhighlight %}

插入排序的`sort`average case: ~N<sup>2</sup>/4 compares and ~N<sup>2</sup>/4 exchanges; worst case: ~N<sup>2</sup>/2 compares and ~N<sup>2</sup>/2 exchanges;best case: N-1 compares and 0 exchanges。

由于排序的过程不难发现，插入排序满足以下两个Invariants：

+ ↑左侧的都是有序的；
+ ↑右侧都是位置的；

出入排序的复杂度分析比选择排序稍微复杂一点。

+ **Best Case**，如果是Sorted，那么只需要经过N-1此的compares和0次的exchanges；
+ **Worst Case**，如果正好是逆序的，那么易知需要经过N<sup>2</sup>/2次的compares和exchanges；
+ **Average Case**，经过简单计算可知需要N<sup>2</sup>/4次的compares和exchanges。

插入排序看起来并没有什么特别之处，尤其在规模比较大的时候，quadratic的复杂度无法忍受。但是在工业界中，插入排序作为快速排序(Quick sort)的补充在规模较小时(一般小于8)得到较为广泛的应用，例如在STL的sort和stdlib的qsort。

此外，一个有意思的结论是，倘若数组已经处于**部分有序(partially sorted)**的话，那么插入排序能在线性时间内完成。


### 2.3 希尔排序 ###

> 希尔排序(Shellsort): 在插入排序中，元素比较的步长h = 1，也就是和相邻的元素进行比较和交换。那么，是否可以从比较大的步长开始，每一次迭代都缩小步长，直到最后一次迭代步长h = 1，退化为插入排序。

对于每次步长为h的迭代，我们成为**h-sorting**，h逐渐减少，最后变成1-sorting。
希尔排序的一个核心问题是，**如何选择h变化的序列使得算法复杂度最低？**

高爷爷大笔一挥，给出了递推式h = 3h + 1，并且经过复杂证明可以知道在这个递推式下希尔排序的最坏复杂度是O(N<sup>1.5</sup>)。Java 代码如下。

{% highlight java linenos %}
public class ShellSort {    
    public static void sort(Comparable[] a){
        int N = a.length;
        int h = 1;
        while (h < N/3) h = 3*h + 1;  //1,4,13,39;
        while(h >= 1){
            for(int i = h; i < N; i++){
                for(int j = i; j >= h && less(a[j],a[j-h]); j -= h){
                    exchange(a,j,j-h);
                }
            }
            h = h/3;
        }
    }
}
{% endhighlight %}

有人可能会问，在h-sorting中为什么要用插入排序呢，用选择排序不行吗？下面给出不严谨的感性证明：
 
 + 在h较大时，由于比较稀疏，因此h-sorting的子数组比较小，因此排序较快；
 + 在h较小时，虽然子数组的规模增大了，但是由于之前的排序使得数组已经部分有序，这个时候插入排序能在最坏的情况下保证线性时间内解决问题，故依然比较快。

 希尔排序另外一个有趣的性质是，如果序列先经过了h-sorting然后经过了g-sorting，那么序列依旧会保持h-sorting。推而广之，那么序列一定也已经是(h+g)-sorting了。


### 2.4 归并排序 ###

#### 2.4.1 递归法 ####

> 归并排序(Mergesort): 利用了**分而治之(Divide and Conquer)**方法, 将原始问题分成两个子问题，当两个子问题解决后，再将两个子问题的结果进行归并(Merge).这个正是其名称的由来。归并排序与后文介绍的**快速排序(Quick Sort)**一道，是工业界最为广泛使用的两种排序算法。

{: .img_middle_mid}
![Merge sort](/assets/images/posts/2015-09-03/merge sort1.png)



{% highlight java linenos %}
public class MergeSort {    
    private static Comparable[] aux;
    
    public static void sort(Comparable[] a){
        aux = new Comparable[a.length];
        sort(a,0,a.length-1);
    }
    
    private static void sort(Comparable[] a, int lo, int hi){
        
        if(hi <= lo) return;
        int mid = lo + (hi-lo)/2;
        sort(a, lo, mid);
        sort(a, mid+1, hi);
        merge(a,lo,mid, hi);
    }
    
    private static void merge(Comparable[] a, int lo,int mid, int hi){
        for(int k = lo; k <= hi; k++){  //copy
            aux[k] = a[k];
        }
        int i = lo;
        int j = mid+1;
        for(int k = lo; k <= hi; k++){
            if      (i > mid)               a[k] = aux[j++];
            else if (j > hi)                a[k] = aux[i++];
            else if (less(aux[j],aux[i]))   a[k] = aux[j++];
            else                            a[k] = aux[i++];
        }
    }
}
{% endhighlight %}

这是一种自顶向下递归求解的方法，容易知道比较次数(compares)满足一下的递推关系：
<p style="text-align: center;">
C(N) = 2C(2N) + N
</p>

求解后可知即使在最坏的情况下，归并排序也能保证经过O(NlgN)次比较就能完成排序，但是，值得注意的是，归并排序需要额外的**线性空间**才能完成，因此不是inplace的。此外在发现相同元素的时候，优先选用左侧的(即靠前)的元素，因此归并排序是stable的。

在工业界的使用中，为了提升归并算法的效率，往往会采用以下两种方案：

+ 在数据规模比较小的时候，直接使用插入排序；
+ 如果两个子序列已经可以完全分开，即第一个子序列的hi不大于第二个子序列的lo，那么无需merge，函数直接返回即可。

此外，Java实现过程中为了保证算法的正确性，可以对invariants采用assert(boolean statement)的方法进行检验。在JVM中可以通过：

{% highlight java linenos %}
java -ea MyProgram //enable assertions
java -da MyProgram //disable assertions(default)
{% endhighlight %}

来控制是否执行assert(boolean statement)语句

#### 2.4.2 自底向上法 ####

归并排序的递归实现实际上是DFS，实际上，还有另外一种类似于**BFS的非递归版本**，想法也非常简单，就是手动控制玄幻次数反复对2n各元素进行排序，这里的n随着循环的增加而不断加1.从二叉树的角度看，就是从树的底部逐渐往上移动，计算完一层后，向上移动计算上一层，元素个数翻倍，直到到达根节点对所有元素排序。这样只需要经过lgN次的大循环即可完成排序。

{: .img_middle_mid}
![Merge sort2](/assets/images/posts/2015-09-03/merge sort2.png)

Java代码如下：
{% highlight java linenos %}
private static void merge(Comparable[] a, int lo, int mid, int hi){
    /* as before */
}
public static void sort(Comparable[] a){
    int N = a.length;
    aux = new Comparable[N];
    for(int sz=1; sz<N; sz = sz+sz){
        for(int i=0; i<N-sz; i += sz+sz){
            merge(a, i, i+sz-1, Math.min(N-1, i+sz+sz-1));
        }
    }
}
{% endhighlight %}


由前面的分析可以知道，无论是最好，最坏还是平均的情况下，归并排序的时间复杂度都都是O(NlogN)，这个上界比我们目前介绍的算法都要小，我们就非常纳闷了：

+ **Comparison sort**的下界是什么呢？
+ 进一步来说，**Comparison sort**的渐进复杂度是多少呢？

#### 2.4.3 基于比较的排序复杂度分析 ####

一般来说，**Comparison sort**可以用**决策树(Decision Tree)**作为抽象模型，如下图所示：

{: .img_middle_mid}
![Decision tree](/assets/images/posts/2015-09-03/decision tree.png)

每次的排序结果可以分为**大于**和**不大于**，分别进入决策树的两支，接着继续往下判断，直到最后一次判断能完全决定所有元素的顺序，这样算法终止。也就是说，**排序算法在叶节点终止**。有了这个重要的观察规律，我们可以进行复杂度推导。

考虑从两个方向计算一棵高度为h的决策树的叶子节点数量(#leaves)：

+ 对于N个不同的元素，所有的排序方案数是N!种，因此决策树**至少**有N!个叶节点，之所以说“至少”是因为有可能存在多个节点对应同一只排序方案。因此 


<p style="text-align: center;">
N! ≤ #leave
</p>

+ 对于高度为h的决策树，叶节点的数量最多为2h，因此

<p style="text-align: center;">
#leave ≤ 2h
</p>

由上可知
<p style="text-align: center;">
h ≥ lg(N!)
</p>

又由Stirling公式可知

<p style="text-align: center;">
h ≥ lg(N!) ∼ NlgN
</p>

而h正好就是比较的次数，因此Comparison Sort的下界是Ω(NlgN)，而又由归并排序知上界是O(NlgN)，故Comparison Sort的渐近复杂度就是Θ(NlgN)。

由此可见，归并排序作为复杂性最优的算法，具有非常稳定的效率。然而，归并算法在空间复杂度上并不是最优的，O(N)的空间复杂度让人难以接受，尤其是在现今大数据泛滥的时代。

为此，我们思考，能否找到一种更加理想的排序算法呢？

欲知详情，请听下节分解。


### 2.5 快速排序 ###

> 快速排序(Quicksort): 分而治之(Divide and Conquer), to sort an array, partitioning an array into two subarrays, then sorting the subarrays indepedently. Quicksort is complementary to Mergesort: for Mergesort, we break the array into two subarrays to be sorted and then combine the ordered subarrays to make the whole ordered array; for quicksort, we rearrange the array such that, when the two subarrays are sorted, the whole array is ordered. In the first instance, we do the two recursive calls before working on the whole array; in the second instance, we do the two recurive calls after working on the whole array. For Mergesort, the array is divided in half; for Quicksort, the position of the partition depends on the contents of the array.

{% highlight java linenos %}
public class QuickSort {    
    public static void sort(Comparable[] a){
        StdRandom.shuffle(a);
        sort(a, 0, a.length-1);
    }
    
    private static void sort(Comparable[] a, int lo, int hi){
        if(hi <= lo) return;
        int j = partition(a,lo,hi);
        sort(a, lo,j-1);
        sort(a, j+1,hi);
    }
    
    private static int partition(Comparable[] a, int lo, int hi){
        int i = lo, j = hi+1;
        Comparable v = a[lo];
        while(true){
            while(less(a[++i],v)) if (i == hi) break;
            while(less(v,a[--j])) if (j == lo) break;
            if(i >= j) break;
            exchange(a,i,j);
        }
        exchange(a,lo,j);
        return j;
    }
}

{% endhighlight %}


快速排序`Sort` worst case uses ~N<sup>2</sup>/2 compares, but random shuffling protects against this case.


> 快速3分区排序(Quicksort 3-way partition): used for duplicated keys to improve performance of Quicksort.

{% highlight java linenos %}
public class QuickSort3Way {    
    public static void sort(Comparable[] a){
        StdRandom.shuffle(a);
        sort(a, 0, a.length-1);
    }
    
    private static void sort(Comparable[] a, int lo, int hi){
        if(hi <= lo) return;
        int lt = lo, i= lo+1, gt = hi;
        Comparable v = a[lo];
        while(i <= gt){
            int cmp = a[i].compareTo(v);
            if      (cmp < 0) exchange(a, lt++, i++);
            else if (cmp > 0) exchange(a, i, gt--);
            else              i++;
        }
        sort(a, lo,lt-1);
        sort(a, gt+1,hi);
    }
}
{% endhighlight %}

快速3分区排序`Sort` uses ~(2ln2)NHcompares, to sort N items, where H is the Shannon entropy, defined from the frequencies of key values.

### 2.6 二叉堆排序 ###

> 优先队列(Priority Queue): remove the largest or smallest item;<br/> 
栈(Stack):                   remove the recently added item;<br/>
队列(Queue):                  remove the least recently added item;<br/> 
随机队列(Randomized Queue):     remove the randomized item。

优先队列用(Elementary Implemment)有序，无序数组很容易实现。但是他们insert和remove maximum操作不能同时达到logN。如果用binary heap(二叉堆)， 则可以实现。

{: .img_middle_mid}
![Priority Queue Implementation](/assets/images/posts/2015-09-03/priority queue.png)


> 二叉堆(Binary Heap): represented by heap-ordered binary tree so that the key in each node is larger than or equal to the keys in that node's two children(if any).

{: .img_middle_mid}
![Priority Queue Implementation](/assets/images/posts/2015-09-03/heap representations.png)

二叉堆有如下性质:

1. root key is the maximum;
2. the height of a complete binary tree of size N is lgN;
3. the parent of node k is node k/2;
4. the children of node k is node 2k and 2k+1;

Binary Heap的Array实现。
{% highlight java linenos %}
public class MaxPQ<Key extends Comparable<Key>> {   
    
    private Key[] pq;
    private int N = 0;
    
    public MaxPQ(int maxN){
        this.pq = (Key[])new Comparable[maxN+1];
        this.N = 10;
    }
    
    public boolean isEmpty(){
        return N == 0;
    }
    
    public int size(){
        return N;
    }
    
    public void insert(Key v){
        pq[++N] = v;
        swim(N);
    }
    
    public Key delMax(){
        Key max = pq[1];
        exchange(1, N--);
        pq[N+1] = null;
        sink(1);
        return max;
    }
    
    
    
    private boolean less(int i, int j){
        return pq[i].compareTo(pq[j]) < 0;
    }
    
    private void exchange(int i, int j){
        Key temp = pq[i];
        pq[i] = pq[j];
        pq[j] = pq[i];
    }
    
    private void swim(int k){
        while (k>1 && less(k/2,k)){
            exchange(k/2,k);
            k = k/2;
        }
    }
    
    private void sink(int k){
        while (2*k <= N){
            int j = 2*k;
            if(j < N && less(j,j+1)) j++;
            if(!less(k,j)) break;
            exchange(k,j);
            k = j;
        }
    }
}
{% endhighlight %}

我们可以用priority queue来develop a sorting method called Heapsort.
{% highlight java linenos %}
public class HeapSort { 
    public static void sort(Comparable[] a){
        int N = a.length;
        for(int k = N/2; k >=1; k--){
            sink(a,k,N);
        }
        while (N > 1)
        {
            exchange(a, 1, N--);
            sink(a, 1, N);
        }
    }
}
{% endhighlight %}

堆排序(HeapSort)`Sort` 用less than 2NlgN+2N compares to sort N items.

## 3.比较 ##
in place: 没有用到额外的存储，如aux[N] array;
stable: sort age, then sort name, the result is first sorted by age, within same age, sorted by name.




## 4.sorting programming example: 8 Puzzle ##


>8Puzzle: 在3×3的格子中填满1-8的整数，有一个格子是空的。交换空格子和其相邻的格子，以达到最终有序的状态。请给出使得任意N*N（2<N<128）的格子用最少的步数达到有序状态的解。

{: .img_middle_mid}
![8puzzle](/assets/images/posts/2015-09-05/8Puzzle.jpg)

有两个类用来解决这个问题。

{% highlight java linenos %}
public class Board {
    public Board(int[][] blocks)           // construct a board from an N-by-N array of blocks
                                           // (where blocks[i][j] = block in row i, column j)
    public int dimension()                 // board dimension N
    public int hamming()                   // number of blocks out of place
    public int manhattan()                 // sum of Manhattan distances between blocks and goal
    public boolean isGoal()                // is this board the goal board?
    public Board twin()                    // a board that is obtained by exchanging any pair of blocks
    public boolean equals(Object y)        // does this board equal y?
    public Iterable<Board> neighbors()     // all neighboring boards
    public String toString()               // string representation of this board (in the output format specified below)

    public static void main(String[] args) // unit tests (not graded)
}

public class Solver {
    public Solver(Board initial)           // find a solution to the initial board (using the A* algorithm)
    public boolean isSolvable()            // is the initial board solvable?
    public int moves()                     // min number of moves to solve initial board; -1 if unsolvable
    public Iterable<Board> solution()      // sequence of boards in a shortest solution; null if unsolvable
    public static void main(String[] args) // solve a slider puzzle (given below)
}

{% endhighlight %}

我们用一个MinPQ存储每一个搜索节点SearchNode,每一个搜索节点包括一个Board，一个moves，一个priority，一个manhattan。我们把初始的SearchNode放入MinPQ，然后删除其最小的priority，放入其neighour。重复此步骤直到manhanttan == 0。这里有几点需要注意：

1. MinPQ<SearchNode>的比较需要SearchNode实现Comparable，比较priority,若相同则比较manhattan;
2. 不是每一个Board都可解，但是每一个Board和他的twin(交换任意两个相邻的格子)有且仅有一个可解。
3. 如何获得最终solution？获取最后一个SearchNode(Manhattan == 0),然后previous取其上一个SearchNode直到previous == null;
4. mahattan函数，计算每一个格子需要几步走到(直接移动)最终的格子的步数，然后求1-8的格子的和。


{% highlight java linenos %}
private class SearchNode implements Comparable{

        private Board board;
        private int moves;
        private SearchNode previous;
        private int priority;
        
        public SearchNode(Board board, int moves, SearchNode previous){
            this.board = board;
            this.moves = moves;
            this.previous = previous;
            this.priority = this.moves + this.board.manhattan();
        }
        
        @Override
        public int compareTo(Object x) {
            SearchNode searchNodeX = (SearchNode)x;
            if(this.priority >searchNodeX.priority) return 1;
            else if(this.priority < searchNodeX.priority) return -1;
            else{
                if(this.board.manhattan() > searchNodeX.board.manhattan()) return 1;
                else if(this.board.manhattan() < searchNodeX.board.manhattan()) return -1;
                else return 0;
            }
        }
        
        public String toString(){
            StringBuilder s = new StringBuilder(this.board.toString());
            s.append("move:" + this.moves + "\n");
            s.append("priority:" + this.priority + "\n");
            return s.toString();
        }
    }
{% endhighlight %}



{: .img_middle_lg}
![8puzzle](/assets/images/posts/2015-09-05/8puzzle game tree.png)




## 5 总结 ##

本文介绍了6种经典的排序方法: 

1. 基础排序: 选择排序和插入排序；
2. 希尔排序(插入排序基础上);
3. 合并排序和快速排序(分而治之);
4. 二叉堆排序(二叉树结构)。

最后用MinPQ来实现8Puzzle自动求解的问题。

## 6 参考资料 ##
- [Algorithm](http://algs4.cs.princeton.edu/home/);

- [Visualize Algorithm](http://visualgo.net/);





