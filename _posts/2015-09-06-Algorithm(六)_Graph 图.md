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

## 1 图介绍 ##

<blockquote><b>Graph</b>: a set of <b>vertices</b> and a collection of <b>edges</b> that each connect a pair of vertices.<br/>

<b>adjacent</b>: two <b>vertices</b> connected by <b>edge</b>;<br/>
<b>path</b>: a sequences of <b>vertices</b> connected by <b>edge</b>;<br/>

</blockquote>

## 2 图算法 ##

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
   private int[] distTo;                            // distTo[v] = length of shortest s->v path

   public BreadthFirstPaths(Graph G, int s){
      marked = new boolean[G.V()];
      distTo = new int[G.V()];
      edgeTo = new int[G.V()];
      for (int v = 0; v < G.V(); v++)
        distTo[v] = INFINITY;
      this.s = s;
      bfs(G, s);
   }
   
   private void bfs(Graph G, int s){
      Queue<Integer> queue = new Queue<Integer>();
      marked[s] = true;                             // Mark the source
      distTo[s] = 0;
      queue.enqueue(s);                             // and put it on the queue.
      while (!queue.isEmpty()){
         int v = queue.dequeue();                   // Remove next vertex from the queue.
         for (int w : G.adj(v)){
            if (!marked[w]){                       // For every unmarked adjacent vertex,
                edgeTo[w] = v;                      // save last edge on a shortest path,
                distTo[w] = distTo[v] + 1;
                marked[w] = true;                       // mark it because path is known,
                queue.enqueue(w);                       // and add it to the queue.
            }
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

<blockquote> <b>Directed Graph (or Digraph)</b>: a set of vertices and a collection of directed edges. Each directed edge connects an ordered pair of vertices;<br/>
<b>Directed Path</b> in a digraph: a sequence of vertices in which there is a (directed) edge pointing from each vertex in the sequence to its successor in the sequence.
</blockquote>


#### 2.2.1 邻接表实现 ####

{% highlight java linenos %}
public class Digraph{
     private final int V;
     private int E;
     private Bag<Integer>[] adj;
     
     public Digraph(int V){           //create a V-vertex digraph with no edges
        this.V = V;
        this.E = 0;
        adj = (Bag<Integer>[]) new Bag[V];
        for (int v = 0; v < V; v++)
           adj[v] = new Bag<Integer>();
     }
     
     public int V()  {  return V;  }      //number of vertices
     public int E()  {  return E;  }      //number of edges
     
     public void addEdge(int v, int w){     //add edge v->w to this digraph
        adj[v].add(w);
        E++;
     }
     
     public Iterable<Integer> adj(int v){  
      return adj[v];  }
     
     public Digraph reverse(){          //reverse of this Digraph
        Digraph R = new Digraph(V);
        for (int v = 0; v < V; v++)
           for (int w : adj(v))
              R.addEdge(w, v);
        return R; }
}
{% endhighlight %}

#### 2.2.2 深度优先搜索 ####

{% highlight java linenos %}
public class DirectedDFS{
  
   private boolean[] marked;
   
   public DirectedDFS(Digraph G, int s){
      marked = new boolean[G.V()];
      dfs(G, s); 
   }
   
   public DirectedDFS(Digraph G, Iterable<Integer> sources){
      marked = new boolean[G.V()];
      for (int s : sources)
         if (!marked[s]) dfs(G, s);
   }
   
   private void dfs(Digraph G, int v){
      marked[v] = true;
      for (int w : G.adj(v))
         if (!marked[w]) dfs(G, w);
   }
   
   public boolean marked(int v){  
    return marked[v];  
   }
   
   
   public static void main(String[] args){
      Digraph G = new Digraph(new In(args[0]));
      Bag<Integer> sources = new Bag<Integer>();
      for (int i = 1; i < args.length; i++)
         sources.add(Integer.parseInt(args[i]));
      DirectedDFS reachable = new DirectedDFS(G, sources);
      for (int v = 0; v < G.V(); v++)
         if (reachable.marked(v)) StdOut.print(v + " ");
      StdOut.println();
   }
}
{% endhighlight %}

#### 2.2.3 拓扑排序 ####

<blockquote><b>Topological Sort</b>: given a digraph, put the vertices in order such that all its directed edges point from a vertex earlier in the order to a vertex later in the order (or report that doing so is not possible);<br/>
<b>A Directed Acyclic Graph (DAG)</b>: a digraph with no directed cycles;<br/>
<b>Cycles in Digraphs</b>: if job x must be completed before job y, job y before job z, and job z before job x, then someone has made a mistake, because those three constraints cannot all be satisfied.<br/>
</blockquote>


{: .img_middle_mid}
![adjacency-list](/assets/images/posts/2015-09-06/Topological Sort.png)


1. Run depth-first search
2. Return vertices in reverse postorder

{% highlight java linenos %}
public class DepthFirstOrder{
  
   private boolean[] marked;
   private Queue<Integer> pre;          // vertices in preorder
   private Queue<Integer> post;         // vertices in postorder
   private Stack<Integer> reversePost;  // vertices in reverse postorder
   
   public DepthFirstOrder(Digraph G){
      pre           = new Queue<Integer>();
      post          = new Queue<Integer>();
      reversePost   = new Stack<Integer>();
      marked  = new boolean[G.V()];
      for (int v = 0; v < G.V(); v++)
         if (!marked[v]) dfs(G, v);
   }
   
   private void dfs(Digraph G, int v){
      pre.enqueue(v);
      marked[v] = true;
      for (int w : G.adj(v))
         if (!marked[w])
            dfs(G, w);
      post.enqueue(v);
      reversePost.push(v);
   }
   
   public Iterable<Integer> pre(){return pre;}
   
   public Iterable<Integer> post(){return post;}
   
   public Iterable<Integer> reversePost(){return reversePost;}
}
{% endhighlight %}



#### 2.2.4 强链接 ####

<blockquote><b>Strong Connectivity</b>: Two vertices v and w are strongly connected if they are mutually reachable: that is, if there is a directed path from v to w and a directed path from w to v. A digraph is strongly connected if all its vertices are strongly connected to one another;<br/>
<b>Strong Components</b>:Like connectivity in undirected graphs, strong connectivity in di- graphs is an equivalence relation on the set of vertices, as it has the following properties:
<ul>
<li>Reflexive : Every vertex v is strongly connected to itself.</li>
<li>Symmetric : If v is strongly connected to w, then w is strongly connected to v.</li>
<li>Transitive : If v is strongly connected to w and w is strongly connected to x, then v
is also strongly connected to x.</li>
</ul>
</blockquote>

{: .img_middle_mid}
![adjacency-list](/assets/images/posts/2015-09-06/Strong Connectivity.png)

{% highlight java linenos %}
public class KosarajuSharirSCC{
  
  private boolean[] marked;     //reached vertices
  private int[] id;             //component identifiers
  private int count;            //number of strong components

  public KosarajuSharirSCC(Digraph G){
    marked = new boolean[G.V()];
    id = new int[G.V()];
    DepthFirstOrder order = new DepthFirstOrder(G.reverse());
    for (int s : order.reversePost())
      if (!marked[s]){  
        dfs(G, s); count++;
      }
  }
  
    private void dfs(Digraph G, int v){
       marked[v] = true;
       id[v] = count;
       for (int w : G.adj(v))
          if (!marked[w])
              dfs(G, w);
    }
    
    public boolean stronglyConnected(int v, int w){return id[v] == id[w];}
    public int id(int v){return id[v];}
    public int count(){return count;}
}
{% endhighlight %}

### 2.3 最小生成树  ###

### 2.4 最短路径 ###




## 3 Programming assignment ##

### 3.1 WordNet ###

SAP思路：要计算最短路径，因此bfs的distTo可以用到。只要将BreadthFirstPaths增加返回marked和distTo的函数，就可以知道和vertex S 连接的点及其距离。然后在int v和 int w的公共marked点里，求其最小的点。SAP就是一个Graph和Graph processing 解耦的典型例子，SAP建立在BreadFirstPaths基础上。

{% highlight java linenos %}
public class SAP {
  Digraph G;
  
  // consructor takes a digraph (not necessarily a DAG)
  public SAP(Digraph G){
    this.G = G; 
  }
  
  // length of shortest ancestral path between v and w;-1 if no such path
  public int length(int v, int w){
    return this.shortPath(v, w)[0];
  }
  
  // a common ancestor of v and w that participates ina shortest ancestral path: -1 if no such path
  public int ancestor(int v, int w){
    return shortPath(v,w)[1];
  }
  
  // length of shortest ancestral path between any vertext in v and any vertex in w; -1 if no such path
  public int length(Iterable<Integer> v, Iterable<Integer> w){
    return this.shortPath(v, w)[0];

  }
  
  // a common ancestor that participates in shortest ancestral path: -1 if no such path
  public int ancestor(Iterable<Integer>v, Iterable<Integer> w){
    return this.shortPath(v, w)[1];
  }
  
  private int[] shortPath(int v, int w){
    
    int[] result = new int[2];
    result[0] = Integer.MAX_VALUE;
    result[1] = Integer.MAX_VALUE;
    
    UpgradedBFSDirectedPath BFSV = new UpgradedBFSDirectedPath(G, v);
    boolean[] markedV = BFSV.getMarked();
    int[]   distV = BFSV.distTo;
    
    UpgradedBFSDirectedPath BFSW = new UpgradedBFSDirectedPath(G, w);
    boolean[] markedW = BFSW.getMarked();
    int[]   distW = BFSW.distTo;
    
    int tempLength = Integer.MAX_VALUE;
    
    for(int i = 0; i < markedV.length;i++){
      if((markedV[i] & markedW[i]) && ((distV[i] +  distW[i]) < tempLength)){
        tempLength = distV[i] +  distW[i];
        result[0] = tempLength;
        result[1] = i;
      }
    }
    
    if(result[0] == Integer.MAX_VALUE) {
      result[0] = -1;
      result[1] = -1;
      return result;
    }
    return result;
  }

  
  private int[] shortPath(Iterable<Integer> v, Iterable<Integer> w){
    
    int[] result = new int[2];
    result[0] = Integer.MAX_VALUE;
    result[1] = Integer.MAX_VALUE;
    
    int minLength = Integer.MAX_VALUE;
    
    for(int i: v){
      for(int j: w){
        int length = shortPath(i, j)[0];
        int ancestor = shortPath(i,j)[1];
        if (length !=-1 && length < minLength){
          minLength = length;
          result[0] = minLength;
          result[1] = ancestor;
        } 
      }
    }
    if(result[0] == Integer.MAX_VALUE) {
      result[0] = -1;
      result[1] = -1;
      return result;
    }
    return result;
  }
  
  public static void main(String[] args) {
    StdOut.printf("hello world0:");
    In in = new In(args[0]);
    Digraph G = new Digraph(in);
    StdOut.printf("Digraph:" + G);
    SAP sap = new SAP(G);
    StdOut.printf("hello world1:");
    while(!StdIn.isEmpty()){
      int v = StdIn.readInt();
      int w = StdIn.readInt();
      StdOut.printf("hello world2:");
      int length   = sap.length(v, w);
      int ancestor = sap.ancestor(v, w);
      StdOut.printf("length = %d, ancestor = %d\n", length, ancestor);
    }
  }
  
  
  /*UpgradedBFSDirectedPath, with getMarked[]added-----------------------------*/
  
  private class UpgradedBFSDirectedPath{
    
    private static final int INFINITY = Integer.MAX_VALUE;
    private boolean[] marked;  // marked[v] = is there an s->v path?
    private int[] edgeTo;      // edgeTo[v] = last edge on shortest s->v path
    private int[] distTo;      // distTo[v] = length of shortest s->v path

    public UpgradedBFSDirectedPath(Digraph G, int s) {
      marked = new boolean[G.V()];
      distTo = new int[G.V()];
      edgeTo = new int[G.V()];
      for (int v = 0; v < G.V(); v++)
        distTo[v] = INFINITY;
      bfs(G, s);
    }

    public UpgradedBFSDirectedPath(Digraph G, Iterable<Integer> sources) {
      marked = new boolean[G.V()];
      distTo = new int[G.V()];
      edgeTo = new int[G.V()];
      for (int v = 0; v < G.V(); v++)
        distTo[v] = INFINITY;
      bfs(G, sources);
    }

    // BFS from single source
    private void bfs(Digraph G, int s) {
      Queue<Integer> q = new Queue<Integer>();
      marked[s] = true;
      distTo[s] = 0;
      q.enqueue(s);
      while (!q.isEmpty()) {
        int v = q.dequeue();
        for (int w : G.adj(v)) {
          if (!marked[w]) {
            edgeTo[w] = v;
            distTo[w] = distTo[v] + 1;
            marked[w] = true;
            q.enqueue(w);
          }
        }
      }
    }

    // BFS from multiple sources
    private void bfs(Digraph G, Iterable<Integer> sources) {
      Queue<Integer> q = new Queue<Integer>();
      for (int s : sources) {
        marked[s] = true;
        distTo[s] = 0;
        q.enqueue(s);
      }
      while (!q.isEmpty()) {
        int v = q.dequeue();
        for (int w : G.adj(v)) {
          if (!marked[w]) {
            edgeTo[w] = v;
            distTo[w] = distTo[v] + 1;
            marked[w] = true;
            q.enqueue(w);
          }
        }
      }
    }

    public boolean hasPathTo(int v) {
      return marked[v];
    }


    public int distTo(int v) {
      return distTo[v];
    }
    public boolean[] getMarked(){
      return this.marked;
    }

    public Iterable<Integer> pathTo(int v) {
      if (!hasPathTo(v)) return null;
      Stack<Integer> path = new Stack<Integer>();
      int x;
      for (x = v; distTo[x] != 0; x = edgeTo[x])
        path.push(x);
      path.push(x);
      return path;
    }
  }
}

{% endhighlight %}

WordNet思路: 这里有一些细节需要澄清，

1. 首先，synset是一个vertex, hypernerm里存的是edges, 即synset->synset集合，因此synset和hypernerm可以构建图。
2. WordNet API 需要返回synset里(vertex)的所有单词及判断单词是否在里面，由于需要快速查找，插入，因此用SET来保存单词Noun(iVar String noun & iVar ArrayList id(每一个单词可以属于多个vertext)，实现Comparable)。
3. idList数组保存vertex id 和 String的关系；
4. 判断WordNet是否为单root，hypernerm出现一项，标记其为true，最后数false的个数，有且只有一个为单root。

{% highlight java linenos %}
public class WordNet {
  
  private class Noun implements Comparable<Noun>{
    private String noun;
    private ArrayList<Integer> id = new ArrayList<Integer>();
    
    public Noun(String noun){
      this.noun = noun;
    }
    
    @Override
    public int compareTo(Noun o) {
      return this.noun.compareTo(o.noun);
    }
    
    public ArrayList<Integer> getId(){
      return this.id;
    }
    
    public void addId(Integer x){
      this.id.add(x);
    }
  }
  
  // constructor takes the name of the two input files
  private SET<Noun> nounSET;
  private Digraph G;        //store hypernym
  private SAP sap;
  private ArrayList<String> idList;//store synset

  
  public WordNet(String synsets, String hypernyms){
    In inSynsets = new In(synsets);
    In inHypernyms = new In(hypernyms);
    
    //counting the total number of vertex
    int maxVertex = 0;
    idList = new ArrayList<String>();
    nounSET = new SET<Noun>();
    
    //start to read synsets.txt
    String line = inSynsets.readLine();
    while(line != null){
      maxVertex++;
      String[] synsetLine = line.split(",");
      //String[0] is id
      Integer id = Integer.parseInt(synsetLine[0]);
      //String[1] is noun, split it and add to the set
      String[] nounSet = synsetLine[1].split(" ");
      for(String nounName: nounSet){
        Noun noun = new Noun(nounName);
        if(nounSET.contains(noun)){
          noun = nounSET.ceiling(noun);
          noun.addId(id);
        }else{
          nounSET.add(noun);
          noun.addId(id);
        }
      }
      
      // add it to the idList
      idList.add(synsetLine[1]);
      //continue readind synsets
      line = inSynsets.readLine();
    }
      
    G = new Digraph(maxVertex);
    // the candidate root
    boolean[] isNotRoot = new boolean[maxVertex];
      
    //start to read hypernyms.txt
    line = inHypernyms.readLine();
    while(line != null){
      String[] hypernymsLine = line.split(",");
      //String[0] is id
      int v = Integer.parseInt(hypernymsLine[0]);
      isNotRoot[v] = true;
      //String[1] and others is its ancestor, constrcuting G
      for(int i = 1; i < hypernymsLine.length; i++){
        G.addEdge(v, Integer.parseInt(hypernymsLine[i]));
      }
      line = inHypernyms.readLine();
    }
      
    //test for root: no cycle
    DirectedCycle directedCycle = new DirectedCycle(G);
    if(directedCycle.hasCycle()){
      throw new java.lang.IllegalArgumentException();
    }
      
    //test for root: no more than on candidate root
    int rootCount = 0;
    for (boolean notRoot: isNotRoot){
      if(!notRoot){
        rootCount++;
      }
    }
    if(rootCount > 1){
      throw new java.lang.IllegalArgumentException();
    }
    sap = new SAP(G);
  }
  
  // returns all WordNet nouns
  
  public Iterable<String> nouns(){
    Queue<String> nouns = new Queue<String>();
    for(Noun noun: nounSET){
      nouns.enqueue(noun.noun);
    }
    return nouns;
  }
  
  // is the word a WordNet noun?
  public boolean isNoun(String word){
    Noun noun = new Noun(word);
    return nounSET.contains(noun);
  }
  
  // distance between nounA and nounB(defined below)
  public int distance (String nounA, String nounB){
    if(!isNoun(nounA)){
      throw new java.lang.IllegalArgumentException();
    }
    if(!isNoun(nounB)){
      throw new java.lang.IllegalArgumentException();
    }
    
    Noun nodeA = nounSET.ceiling(new Noun(nounA));
    Noun nodeB = nounSET.ceiling(new Noun(nounB));
    return sap.length(nodeA.getId(), nodeB.getId());
  }
  
  // a synset (second field of synsets.txt) that is the common ancestor of nounA and nounB
  // in a shortest ancestral path (defined below)
  public String sap(String nounA, String nounB){
    if(!isNoun(nounA)){
      throw new java.lang.IllegalArgumentException();
    }
    if(!isNoun(nounB)){
      throw new java.lang.IllegalArgumentException();
    }
    
    Noun nodeA = nounSET.ceiling(new Noun(nounA));
    Noun nodeB = nounSET.ceiling(new Noun(nounB));
    return idList.get(sap.ancestor(nodeA.getId(), nodeB.getId()));
  }
  
  public static void main(String[] args) {
    String synsets = args[0];
    String hypernyms = args[1];
    
    WordNet wordNet = new WordNet(synsets, hypernyms);
  }
}

{% endhighlight %}



Outcast思路：求和。由于N*N矩阵对称，因此可以先填充再求和减少计算次数。


{% highlight java linenos %}
public class Outcast {
  private WordNet wordNet;
  
  public Outcast(WordNet wordNet){
    this.wordNet = wordNet;
  }
  
  public String outcast(String[] nouns){

        int[] distance = new int[nouns.length];  
        for (int i=0; i<nouns.length; i++){  
            for (int j=i; j<nouns.length; j++){  
                int dist = wordNet.distance(nouns[i], nouns[j]);
                distance[i] += dist;  
                if (i != j){  
                    distance[j] += dist;  
                }  
            }  
        }  
        int maxDistance = 0;  
        int maxIndex = 0;  
        for (int i=0; i<distance.length; i++){  
            if (distance[i] > maxDistance){  
                maxDistance = distance[i];  
                maxIndex = i;  
            }  
        }  
        return nouns[maxIndex];  
    }  

  public static void main(String[] args) {
    WordNet wordnet = new WordNet(args[0],args[1]);
    Outcast outcast = new Outcast(wordnet);
    for(int t = 2; t < args.length; t++){
      In in = new In(args[t]);
      String[] nouns = in.readAllStrings();
      StdOut.println(args[t] + ":" + outcast.outcast(nouns));
    }
  }
}


{% endhighlight %}

### 3.2 ###


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





