---
layout: post
title: Wireshark Part II 应用(二)：Fighting a Slow Network
categories: [-02 Networks]
tags: [Networks,Wireshark]
number: [-8.2]
fullview: false
shortinfo: 本文是《Practical Packet Analysis》系列第1篇笔记《Packet Analysis and Netork Basics》。

---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1 Packet Analysis and Packet Sniffers ##

### 1.1 Packet Analysis and Packet Sniffers ###

> What is packet: a complete protocol data unit(PDU) that includes header and footer information from all layers of the OSI model. 也有单指IP层的数据单位。

what is packet analysis
The criteria to select packet sniffer tool(supported protocol comes first)

how packet sniffers work 

1. Collection of raw data: switching to promiscous mode.

2. Conversion to readable format.

3. Analysis.

### 1.2 How computers communicate ###

network communicate by protocols.

different protocol have different features, but have several common features:

1. Connection initiation. Is Client or Server initiating the communication? What information need to exchange between transfer of payload.

2. Secure requirement. Is encryption required? If yes, how does the key transmitted?

3. Data Formatting. What is the ordere of data transferred and received?

4. Error detection and correction. How to detect error and recover, such as timeout and packet loss?

5. Connection termination. Who should initiate termination and how?

#### 1.2.1 Seven-Layer OSI Model ####

略。

#### 1.2.2 Data Encapsulation ####

略。

#### 1.2.3 Network Hardware ####

##### 1.2.3.1 Hub #####

> **Hub(多端口的转发器)**: half-duplex repeating device，running on physical layer。有多个port，会产生不必要的traffic，比如port 2 要发送packet给port 4 在1个4-port的 hub上，则port 2重复发送3个packet给分别给port1，3，4。连接port 1和3的client打开packet发现MAC地址不是给他们的，就discard该packet；port 4的client打开packet发现MAC地址是给他的，就接收。

##### 1.2.3.2 Switches #####

> **Switch(交换机)**: full-duplex，send packets only to specific ports, running on data link layer。存储port host的MAC地址，不会像Hub一样重复发送packet，因此大大减少traffic。

##### 1.2.3.3 Routers #####

> **Router(路由)**，IP到IP。Switch只能到neighbour node，但是Router可以从Source到Destination(中间可以隔好多neighbour nodes)。

#### 1.2.4 Traffic Classifications ####

##### 1.2.4.1 Broadcast Traffic #####

> **Broadcast(广播)**：one source to all destination in broadcast domain.

data Link Layer: MAC address FF:FF:FF:FF:FF:FF is the broadcast address;

IP Layer: 192.168.0.255(192.168.0.xxx with 255.255.255.0 as subnet mask) is the boradcast address.

broadcast domain: broadcast packet's range (within hub or switch) without going into router。The internet is composed of broadcast domain connected by router。

{: .img_middle_mid}
![broadcast domain](/assets/images/posts/2015-04-20-Wireshark Part I (一)：Packet Analysis and Netork Basics/broadcast domain.png)

##### 1.2.4.2 Multicast Traffic #####

> **Multicast(组播)**：one source to multiple destination simoultaneously by sending packets only once。在发送者和每一接收者之间实现点对多点网络连接。如果一台发送者同时给多个的接收者传输相同的数据，也只需复制一份的相同数据包。

##### 1.2.4.3 Unicast Traffic #####

> **Unicast(单播)**：one source to one destination。

## 2 Tapping into the wire ##

Network Map

### 2.1 Living Promiscuously ###

### 2.2 Sniffing ###

#### 2.2.1 Sniffing Hub ####

#### 2.2.2 Sniffing Switch ####

##### 2.2.2.1 Port Mirroring #####

##### 2.2.2.2 Hubbing Out #####

##### 2.2.2.3 Using a Tap #####

##### 2.2.2.4 ARP Cache Poisoning #####

##### 2.2.2.5 Packet Sniffering App in host #####

#### 2.2.3 Sniffing Router ####

the as **Sniffing Switch**

### 2.3 Sniffering methods Decision Tree ###

## 3 Introduction to Wireshark ##

### 3.1 The Benefits of Wireshark ###

1. Supported protocls. More than 800 protocols, from basic IP and DHCP to advanced AppleTalk and BitTorrent.

2. User-friendliness. GUI-Based, easier to use than Command-Based(tcpdump); open source, free to download.

3. Program Support. [Wireshark Community](https://www.wireshark.org/)。

4. Operating System Support. Windows, Mac OS X and Linux-based platforms.

### 3.2 Installing Wireshark ###

需要注意的有两点：

1. NIC(Network Interface Card) that supports promiscuous mode.

2. WinPcap Caputure Driver to interact your operating system to capture raw packet data, apply filters and switch the NIC in and out of promiscuous mode.

### 3.3 Your First Packet Capture ###

#### 3.3.1 Main Window ####


Packet List Pane: when I refer to traffic, I'm referrring to all packets displayed in the Packet List Pane. When I refer to DNS traffic specifically, I mean the DNS protocol packets in the Packet List Pane。

Packet Detail Pane

Packet Bytes Pane：the 0s and 1s on the Physical Layer。

#### 3.3.2 Preferences ####

packet color coding, different color in Packet List Pane means different protocol。



## 4 Working With Captured Packets ##

### 4.1 Working With Capture Files: Saving, Exporting, Merging  ###

### 4.2 Working With Packets: Finding, Marking, Printing ###

1. Finding: CTRL-F

2. Marking: right click on the packet in packet list pane, then choose marking.

3. Printing: File-print.


### 4.3 Setting Time: Display Formats and References ###

time is of the essence -- especially in packet analysis：

1. Time Display Formats：View->Time Display Formats.

2. Pacekt Time Referencing： Edit-> Set Time Reference.即以Packet List Pane中的某个Packet的时间为参考时间0，重新计算后面的Packet的时间。

### 4.4 Setting Capture Option: 输入，输出，选项 ###

1. 输入：选择NIC；

2. 输出：选择output file；

3. 选项：display选项。

### 4.5 Filters: Using,Displaying,Saving  ####

Wireshark有两类Filter：

1. Capture filter，即满足条件的捕捉。

2. Display filter，即全部Capture，然后满足条件的display。

#### 4.5.1 Capturing Filter ####

Capturing Filter用在需要减轻NIC traffic load的情境，即不满足filter条件的就不捕捉。

使用 BPF(Berkeley Packet Filter)语法：

1. hostname filter: host 172.16.16.149

2. MAC address filter: ether host 00-1a-a0-52-e2-a0。如果你担心IP会变，就要用到这个MAC filter。

3. src and dst filter： src host 172.16.16.149或dst host 172.16.16.149。

4. Port and Protocol Filter。

#### 4.5.2 Displaying Filter ####

在Packet List Panel上可以输入Displaying Filter。

## 5 总结 ##

{: .img_middle_mid}
![broadcast domain](/assets/images/posts/2015-04-20-Wireshark Part I (一)：Packet Analysis and Netork Basics/broadcast domain.png)

## 6 参考资料 ##

- [《Practical Packet Analysis: Using Wireshark to Solve Real-World Network Problems》](https://www.amazon.com/Practical-Packet-Analysis-Wireshark-Real-World/dp/1593272669/ref=sr_1_1?s=books&ie=UTF8&qid=1477547038&sr=1-1&keywords=practical+packet+analysis);





