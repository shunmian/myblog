---
layout: post
title: Algorithm(六)： Graph 图
categories: [Algorithm]
tags: [Graph]
number: [-2.2.4]
fullview: false
shortinfo: 图是重要的一种数据结构，能巧妙优雅地解决许多其他数据结构和算法不能解决的问题。
---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1. 图介绍 ##

<blockquote><b>Graph</b>: a set of <b>vertices</b> and a collection of <b>edges</b> that each connect a pair of vertices.<br/>

<b>adjacent</b>: two <b>vertices</b> connected by <b>edge</b>;<br/>
<b>path</b>: a sequences of <b>vertices</b> connected by <b>edge</b>;<br/>

</blockquote>

## 2. 图算法 ##

Graph API

{% highlight java linenos %}
public class Graph{
                     Graph(int V)            // create a V-vertex graph with no edges
                     Graph(In in)            // read a graph from input stream in
                 int V()                     // number of vertices
                 int E()                     // number of edges
                void addEdge(int v, int w)   // add edge v-w to this graph
   Iterable<Integer> adj(int v)              // vertices adjacent to v
              String toString()              // string representation

}
{% endhighlight %}


### 2.1 无向图 ###

#### 2.1.1 邻接表实现 ####

通常有三种图的实现方法：

1. adjacency matrix: N×N matrix， matrix[v][w] = matrix[w][v] if v and w are connected by edge。 N×N的额外空间过于昂贵。
2. An array of edges: class edge has two iVar int v and int w if v and w are connected. But adj()的实现需要遍历所有edges，过于昂贵。
3. An array of adjacency-list: a vertex-indexed array of lists of the vertices adjacent to each vertex. 这种方法在时间和空间上都要优于以上两种，是我们要采用的实现方法。

{: .img_middle_mid}
![adjacency-list](/assets/images/posts/2015-09-06/adjacent-list.png)


{% highlight java linenos %}
public class UndirectedGraph {

    private final int V;                    // number of vertices
    private int E;                          // number of edges
    private Bag<Integer>[] adj;             // adjacency lists
         
    public UndirectedGraph(int V){
        this.V = V;                         
        this.E = 0;                         
        
        adj = (Bag<Integer>[]) new Bag[V];  // Create array of lists.
        for (int v = 0; v < V; v++)         // Initialize all lists
            adj[v] = new Bag<Integer>();    //   to empty.
     }

     public UndirectedGraph(In in){
         this(in.readInt());                // Read V and construct this graph.
         int E = in.readInt();              // Read E.
         for (int i = 0; i < E; i++){       
               int v = in.readInt();        // Read a vertex,
               int w = in.readInt();        // read another vertex,
               addEdge(v, w);               // and add edge connecting them.
         }
      }
      
     public int V()  {  return V;  }
     public int E()  {  return E;  }
         
     public void addEdge(int v, int w){
         adj[v].add(w);                     // Add w to v’s list.
         adj[w].add(v);                     // Add v to w’s list.
         E++;
     }
         
     public Iterable<Integer> adj(int v){ 
         return adj[v];
     }
}
{% endhighlight %}



#### 2.1.2 深度优先搜索 ####
在Graph类基础上，我们可以用Graph-Pcocessing来对Graph实例进行处理，这样把Graph和Graph-Processing的好处是可以将Graph和图处理解耦。这里我们首先介绍深度优先搜索遍历一个图来获取图中vertex s连接的vertex v以及具体路径。


{% highlight java linenos %}
public class DepthFirstPaths{                   // using depthFirstSearch to find path to s in graph G
   private boolean[] marked;                    // has dfs() been called for this vertex?
   private int[] edgeTo;                        // last vertex on know path to this vertex
   private final int s;                         // source
   public DepthFirstSearchPaths(Graph G, int s){
      marked = new boolean[G.V()];
      edgeTo = new int[G.V()];
      this.s = s;
      dfs(G, s); 
   }
   private void dfs(Graph G, int v){
      marked[v] = true;
      count++;
      for (int w : G.adj(v))
         if (!marked[w]) {
             edgetTo[w] = v;
             dfs(G, w);
         }
   }
   
   public boolean hasPathTo(int v){
       return marked[v];
   }
   
   public Iterable<Integer> pathTo(int v){
       if(!hasPathTo(v)) return null;
       Stack<Integer> path = new Stack<Integer>();
       for (int x = v; x != s; x = edgeTo[x])
           path.push(x);
       path.push(s);
       return path;
   }
}
{% endhighlight %}

#### 2.1.3 广度优先搜索 ####
深度优先搜索发现的paths取决于graph的表现方式（同一个图，不同表现方式，对于s->v的path，有不同的解）。而通常，我们对以下问题更感兴趣.

> <b>Single-source shortest paths</b>: Given a graph and a source vertex s, support queries of the form Is there a path from s to a given target vertex v? If so, find a shortest such path (one with the minimal numbers of edges).


{% highlight java linenos %}
public class BreadthFirstPaths{
   private boolean[] marked;                        // Is a shortest path to this vertex known?
   private int[] edgeTo;                            // last vertex on known path to this vertex
   private final int s;                             // source
   
   public BreadthFirstPaths(Graph G, int s){
      marked = new boolean[G.V()];
      edgeTo = new int[G.V()];
      this.s = s;
      bfs(G, s);
   }
   
   private void bfs(Graph G, int s){
      Queue<Integer> queue = new Queue<Integer>();
      marked[s] = true;                             // Mark the source
      queue.enqueue(s);                             // and put it on the queue.
      while (!queue.isEmpty()){
         int v = queue.dequeue();                   // Remove next vertex from the queue.
         for (int w : G.adj(v)){
            if (!marked[w])                         // For every unmarked adjacent vertex,
                edgeTo[w] = v;                      // save last edge on a shortest path,
            marked[w] = true;                       // mark it because path is known,
            queue.enqueue(w);                       // and add it to the queue.
      }
     }
   }
   
   public boolean hasPathTo(int v){  
       return marked[v];  
   }

   public Iterable<Integer> pathTo(int v){
       if(!hasPathTo(v)) return null;
       Stack<Integer> path = new Stack<Integer>();
       for (int x = v; x != s; x = edgeTo[x])
           path.push(x);
       path.push(s);
       return path;
   }
}
{% endhighlight %}

for any vertex v reachable from s, BFS computes a shortest path from s to v(no path from s to v has fewer edges).


#### 2.1.4 连通单元 ####

Depth-first search to find connected components in a graph

{% highlight java linenos %}

public class CC{

   private boolean[] marked;
   private int[] id;
   private int count;
   
   public CC(Graph G){
      marked = new boolean[G.V()];
      id = new int[G.V()];
      for (int s = 0; s < G.V(); s++)
         if (!marked[s]){
             dfs(G, s);
             count++; 
        }
   }
   
   private void dfs(Graph G, int v){
      marked[v] = true;
      id[v] = count;
      for (int w : G.adj(v))
         if (!marked[w])dfs(G, w);
   }
   
   public boolean connected(int v, int w){  
       return id[v] == id[w];  
   }
   
   public int id(int v) {  return id[v];  }
   public int count()   {  return count;  }
}
{% endhighlight %}





### 2.2 有向图 ###

#### 2.2.1 邻接表实现 ####

#### 2.2.2 深度优先搜索 ####

#### 2.2.3 广度优先搜索 ####

#### 2.2.4 拓扑排序 ####

#### 2.2.5 强链接 ####






### 2.3 最小生成树  ###

### 2.4 最短路径 ###







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





