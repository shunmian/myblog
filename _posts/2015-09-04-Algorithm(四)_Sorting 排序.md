---
layout: post
title: Algorithm(四)： Sorting 排序
categories: [Algorithm]
tags: [Sorting]
number: [-2.2.4]
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
 > 选择排序(Selection Sort): repeatedly selecting the smallest remaining item and exchange to the first index of the remaining array。

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

选择排序的`sort`用~N<sup>2</sup>/2 compares and N exchanges。

### 2.2 插入排序 ###

> 插入排序(Insertion Sort): the left items of the current index are in sorted order, current index find its place among the left items.

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

### 2.3 希尔排序 ###

> 希尔排序(Shellsort): a simple extension of insertion sort that gains speed by allowing exchanges of array entries that are far apart, to produce partially sorted arrays that can be efficiently sorted, eventually by insertion sort.

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



### 2.4 合并排序 ###

> 合并排序(Mergesort): 分而治之(Divide and Conquer), to sort an array, divide it into two halves, sort the two halves(recursively) and then merge the results.

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


合并排序`Sort` 用at most NlgN compares and 6 NlgN array access to sort any array of length N。 

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
![Priority Queue Implementation](/assets/images/posts/2015-09-04/priority queue.png)


> 二叉堆(Binary Heap): represented by heap-ordered binary tree so that the key in each node is larger than or equal to the keys in that node's two children(if any).

{: .img_middle_mid}
![Priority Queue Implementation](/assets/images/posts/2015-09-04/heap representations.png)

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

{: .img_middle_lg}
![Sorting Algorithms](/assets/images/posts/2015-09-04/sorting algorithm.png)


## 4.sorting programming example: 8 Puzzle ##







## 5 总结 ##

本文介绍了6种经典的排序方法: 

1. 基础排序: 选择排序和插入排序；
2. 希尔排序(插入排序基础上);
3. 合并排序和快速排序(分而治之);
4. 二叉堆排序(二叉树结构)。

## 5 参考资料 ##
- [Algorithm](http://algs4.cs.princeton.edu/home/);

- [Visualize Algorithm](http://visualgo.net/);





