---
layout: post
title: AWS Associate Architect
categories: [-21 AWS]
tags: [Vim]
number: [-21.1]
fullview: false
shortinfo: AWS介绍。
---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## -1 AWS CLI

- `aws configure`
- `aws s3 help`
- `aws s3 ls`

## 0 IAM

#### 1.1.3 Role

- Role is used to avoid using user credential in resources such as EC2, which is not secure if it is shared across multiple EC2 and one EC2 leakage will needs you to invalidate that user and create a new user credential. By assign role to EC2, you can use `aws s3 ls` without `aws config` to enter the user credentials.

- Role is global: you cannot create a role for a specific region.
    - One can attach a role to a RUNNING EC2 instance

## 1. Storage ##

### 1.2 S3

#### 1.2.0 What

- object based, not for install an operation system (which should uses block storage).
- from 0 Bytest to 5TB.
- unlimited storage.
- stored in Buckets.
- S3 is a universal namespace, that is, names must be unique globally.
- bucket url formats: `https://s3-eu-west-1.amazongaws.com/acloudguru`.
- read after Write consistency for PUTS of new objects.
- eventual consistency for overwrite PUTS and DELETES (can take some time to propagate).
- S3 storgae tiers
    - S3 standard: 99.99% availability, 99.999999999% durability
    - S3 RRS (Reduced Redundancy Storage) for noncritical  reproducible data that can be stored with less redundancy that the S3 standard.
    - S3-IA: (Infrequently Accessed), lower fee than S3, but you are charged a retrieval fee.
    - S3 One Zone - IA: the same as S3-IA except exist only in one availabbility zone.
    - Glacier: very cheap, but used for archival only. Expedidited, Standard or Build. A standard retrival time takes 3 - 5 hours.
- key value store
    - Key
    - Value
    - Version ID
    - Metadata
    - Access Control List

#### 1.2.1 Versioning

- stores all versions of an object (including all writes and even if you delete an object)
- great backup tool.
- once enabled, version cannot be disabled, only suspended.
- Integrates with Lifecycle rules
- Versioning's MFA Delete capability, which use multi-factor authentication, can be used to provide an additional layer of secrurity.


#### 1.2.2 Cross region replication

- versioning must be enabled on both the source and estination buckets.
- Regions must be unique.
- Files in an existing bucket are not replicated automatically. All subsequent updated files will be replicated automatically.
- You cannot replicate to multiple buckets or use daisy chaining(??).
- Delete markers are NOT replicated.
- Deleting individual versions or delete markers will not be replicated.
- Understand what Crosss Region Replication is at a high level.


#### 1.2.3 Lifecyle Management, S3-IA & Glacier lab

- can be used in conjunction with versioning
- can be applied to current versions and previous versions
- Following actions can now be done: 
    - transaction to the Standard-Infrequent Access Storage Class (30 days after the creation date)
    - archive to the Glacier Storage Class(30 days after IA, if relevant)
    - permanent delete

#### 1.2.4 Securing buckets

- By default, all newly created buckets are PRIVATE;
- You can setup access control to your buckets using;
    - Bucket Polocies (apply to whole Bucket);
    - Access Control List (apply to specific file within the bucket)

- S3 Buckets can be configured to create access logs which log all requests made to the S3 bucket. This can be done to another bucket.

- Encryption
    - In Transit: SSL/TLS

    - At Rest
        - Server Side Encryption
            - S3 Managed Keys - SSE-S3
            - AWS Key Management Service, Managed Keys - SSE-KMS
            - Server Side Encryption With Customer Provided Keys - SSE-C
        - Client Side Encryption

#### 1.2.5 S3 Transfer Acceleration

- S3 Transfer Acceleration utilises the CloudFront Edge Network to accelerate your uploads to S3. Instead of uploading directly to your S3 buckets, you can use a distinct URL to upload directly to an edge location which will then transfer that file to S3.

#### 1.2.6 Host Static Website in S3

- You can host static website in S3. Websites that require database connections such as Wordpress etc cannot be hosted on S3.
- S3 Scales automatically to meet your demand. Many enterprises will put static websites on S3 when they think there is going to be a large number of requests.
- You should use bucket policies to make entire S3 buckets public for static website access.

### 1.3 CloudFront


#### 1.3.1 What is CDN

- A content delivery network (CDN) is a system of distributed servers (network) that deliver webpages and other web content to a user based on the geographic locations of the user, the origin of the webpage and a content delivery server.

- Edge Location - This is the location where content will be cached. This is separate to an AWS Region/AZ.

- Origin - This is the origin of the files that the CDN will distribute to Edge Location. This can be either an S3 Bucket, an EC2 instance, an Elastic Load Balancer or Route53.

- Distribution, consists of a collection of Edge Location.

- CloudFront can be used to deliver your entire website using a global network of edge locations. Requests for your content will be routed to the nearest edge location.CloudFront is optimized with S3, EC2, Route53, and Elastic Load Balancer.

- Web Distribution - Typlically used for websites

- RTMP - Used for Media Streaming

- Edge locations are not just READ only, you can write to them too (ie put an object on to them).

- Objects are cacehd for the life of the TTL (Time To Live).

- You can clear cached objects, but you will be charged.

### 1.4 Storage Gateway

#### 1.4.1 What

- AWS Storage Gateway is a service that connects an on-premises software appliance with cloud-based storage to provide seamless and secure integration between an organization's on-premises IT environment and AWS's storage infrastructure. The service enables you to securely store data to the AWS cloud for scalable and cost-effective storage.

- AWS Storage Gateway's software appliance is available for download as a virtual machine (VM) image that you install on a host in your datacenter. Storage Gateway supports either VMware ESXi or Microsoft Hyper-V. Once you've installed your gateway and associated it with your AWS account through the activation process, you can use the AWS Management Console to create the storage gateway option that is right for you.

- Four Types of Storage Gateways
    - File Gateway (NFS): such as pdf, word, picture, video. Files are stored as objects is **S3** buckets, accessed through a Network File System (NFS) mount point.
    - Volumes Gateway (iSCSI): block storage, virtual hard disk from on-premies to Volume Gateway via iSCSI block protocol.
        - Stored Volumes: store your primary data locally, while asynchronously backing up that data to AWS.
        - Cached Volumes: only the most recently used file.
    - Tape Gateway (VTL): for archive in the AWS Cloud via popular backup applications like NetBackup, Backup Exec, Veeam etc.


### 1.5 Snowball

#### 1.5.1 What

- AWS Import/Export Disk accelerates moving large amounts of data into and out of the AWS cloud using portable storage devices for transport, can import to or export from S3.

- Types
    - Snowball: 80TB.

    - Snowball Edge: 100TB with compute capability.

    - Snowmobile.

### 1.6 Elastic Block Storgage (EBS)

- Amazon EBS allows you to create storage volumes and attach them to amazon EC2 instances. Once attached, you can create a file system on top of these volumes, run a database, or use them in any other way you would use a block device. Amazon EBS volums are placed in a specific Availability Zone, where they are automatically replicated to protect you from the failure of a single component.

#### 1.6.1 EBS Volume 

- types
    - SSB
        - General Purpose SSD (GP2)
            - General purpose, balances both price and performance.
            - Ratio of 3 IOPS per GB with up to 10,000 IOPS and the ability to burst up to 3000 IOPS for extended periods of time for volumes at 3334 Gib and above.

        - Provisioned IOPS SSD (IO1)
            - Designed for I/O intensive applications such as large relational or NoSQL databases.
            - Use if you need more than 10,000 IOPS
            - can provision up to 20,000 IOPS per volume.

    - Magnetic
        - Throughput Optimized HDD (ST1)
            - Big data
            - Data warehouses
            - Log processing
            - Cannot be a boot volume

        - Cold HDD (SC1)
            - Lowest Cost Storage for infrequently accessed workloads
            - File server
            - Cannot be a boot volume

- Notes
    {: .img_middle_hg}
    ![EBS AMI](/assets/images/posts/-21_AWS/2017-10-01-AWS Associate Architect/EBS AMI class vs instance.png)

    - Volumes exist on EBS
        - volumes is just virtual hard disk
        - you can change volume size on the fly, including changing the size and storage type.
        - volumes always be in the same Availability Zone as the EC2 instance
        - to move an EC2 volume from one AZ/Region to another, take a snap or an image of it, then copy it to the new AZ/Region
        
    - Snapshot exist on S3
        - snapshot are just time copies of volumes
        - snapshot record the incremental diffierence
        - the first snaphost takes more time to create since the first difference is almost the whole volume.
        - to create a snapshot for EBS volumes that serve as root devices, you should stop the instance before taking the snapshot.
        - However, you can take a snap while the instance is running
        - Snapshot of encrypted volumes are encrypted automatically
        - Volumes restored from encrypted snapshots are enecyrpted automatically
        - You can share snapshots, but only if they are unencrypted
            - These snapshots can be shared with other AwWS accounts or made public

    - duplicate EBS to other AZ/region
        - to different AZ
            volum -> snapshot -> create new volume from the snapshot in different AZ -> attach to a new instance

        - to different region
            volume -> snapshot -> copy snapshot to a new region -> create image from the copied snapshot

    - EBS vs instance Store

    - EBS default delted when EC2 terminate. One can change behavior that EC2 termiantion doesn't affect EBS.

### 1.7 Summary

- Read the above notes
- In addition
    - Write to S3 - HTTP 200 code for a successiveful write
    - You can load files to S3 much faster by enabling multipart upload
    - Read the S3 FAQ obefore taking the exam. It comes up A LOT!


## 2 Computing

### 2.1 EC2

#### 2.1.1 What

- Amazon Elastic Compute Cloud (Amazon EC2) is a web service that provides resizable compute capacity in the cloud. Amazon EC2 reduces the time required to obtain and boot new server instances to minutes, allowing you to quickly scale capacity, both up and down, as your computing requirements change.

- Purchasing model

    - On Demand - allows you to pay a **fixed** rate by the hour with no commitment. perfect for users that want the low cost and flexibility of Amazon EC2 without any up-front payment or long-term commitment. Applicatoins with short term, spiky or unpredictable workloads that cannot be interrupted. Applications being developed or tested on Amazon EC2 for the first time.

    - Reserved - provides you with a capacity reservation, and offer a significant discount on the hourly charge for an instacnce. 1 year or 3 year terms. Applications with steady state or predictable usage. Applications that require reserved capacity. Users can make up-front payments to reduce their total computing costs even further (standard RIs (Reserved Instances), up to 75% off on-demand; Convertible RIs, up to 54% off on demand; scheduled RIs are available to launch within the time window you reserve.)

    - Spot - enables you to bid whatever price you want for instance capacity, providing for even greater savings if your application shave flexible start and end times. Applications that have flexible start and end times. Applications that are only feasible at very low compute prices. Can be purchased on-Demand (hourly). Can be purchased as a Reservation for up to 70% off the on-demand price. If a spot instance is terminated by Amazon EC2, you will not be charged for a partial hour of usage; However, if you terminate the instance your self, you will be charged for the complete hour in which the instance ran.

    - Dedicated Hosts - Physical EC2 server dedicated for your use. Dedicated hosts can help you reduce costs by allowing you to use your existing server-bound software licenses

- **HARDWARE** - EC2 Instance Types:
    - **F** for FPGA
    - **I** for IOPS
    - **G** for Graphics
    - **H** for High Disk Throughput
    - **T** for cheap general purpose (think T2 Micro)
    - **D** for density
    - **R** for RAM
    - **M** for main choice for general purpose apps
    - **C** for Compute
    - **P** for Graphics (think Pics)
    - **X** for extrame Memory

{: .img_middle_hg}
![EC2 instance type](/assets/images/posts/-21_AWS/2017-10-01-AWS Associate Architect/EC2 instance type.png)
    

- **SOFTWARE** - AMI
    - linux
    - red-hat

- Termination Protection is turned off by default, you must turn it on

- On an EBS-backed instance, the default action is for the root EBS volume to be deleted when the instance is terminated.

- EBS Root Volumes of your DEFAULT AMI's cannot be encrypted. You can also use a thrid party tool (such as bit locker etc) to encrypt the root volume, or this can be done when creating AMI's in the AWS console or uusing the API.

- Additional volumes can be encrypted.

- Root volume type
    - EBS
        - The root device for an instance launched from the AMI is an Amazon EBS volume created from an Amazon EBS snapshot
        - EBS backed instances can be stopped. You will not lose the data on this instance if it is stopped.
    - instance store (Ephemeral storage)
        - For root device for an instance launched for from the AMI is an isntance store volume created from a template stored in Amazon S3
        - Ephemeral storage, the instance cannot be stopped, if the underlying host fails, you will lose your data.
    - in common:
        - you can reboot both without losing your data.
        - by default, both ROOT volumes will be deleted on termination, however with EBS volumes, you can tell AWS to keep the device volume.
      
- GET EC2 instance meta data inside EC2
    `curl http://169.254.169.254/latest/meta-data/`

#### 2.1.2 Launch EC2 instance & SSH to it

- download new key pair `myKeyPair.pem`
- `CHMOD 400 myKeyPair.pem`
- `ssh ec2-user@3.0.99.6 -i myKeyPair.pem` where `3.0.99.6` is the ec2 instance public ip.
- try to install apache and start the service then type `3.0.99.6` in browser. (`yum install httpd`, `cd /var/www/`, `vim index.html`, write html to `index.html`, save and `service httpd start`)

#### 2.1.3 Security Group Basics

- All Inbound Traffic is Blocked By Default
- All Outbound Traffic is Allowed
- Changes to Security Groups take effective immediately. If your instance attached to Security Group A. Change to A take effective imeediately to this instance.
- An instance can have multiple security groups
- A secruity group can be attached to multiple instances
- Security Groups are stateful, which means inbound rule http would enable outbound rule http implicitly, though outbound rule doesn't show there is rule http.
- You cannot block specific IP addresses using Security Groups, instead use Network Access Control Lists.


#### 2.1.5 Elastic Load Balancer

- 3 types
    - Application Load Balancer
        - for HTTP and HTTPs traffic (OSI 7, the application layer): can create advanced request routing, sending specified requests to specific web servers.
    - Network Load Balancer
        - for TCP traffic (OSI 4, the transport layer): capable of handling millions of requests per second while maintaining ultra-low latencies, for extreame performance.
    - Classic Load Balancer
        - the legacy Elastic Load Balancers(for both OSI 7 and 4).
        - Error: 504, means server has error, either in server itself or db.
        - X-Forwared-For header: client(src 124.12.3.231) -> classic load balancer (src 10.0.0.23) -> EC2(src 10.0.0.23 (X-Forwared-For 123.12.3.231))
- instaces monitored by ELB are reported as: InService or OutofService
- Health Checks do the instance check by talking to it
- ELB have their own DNS name. You are never given an IP address.
- Read the ELB FAQ for Classic Load Balancers. 
- aCloudGuru has deep dive course on application load balancers.

#### 2.1.6 Using bash script to pre-launch the ec2 instance

in launch instance -> Configure Instance Details -> Advanced Details, one can add bash scripts

{% highlight bash linenos %}
#!bin/bash
sudo su
yum update -y
yum install httpd -y
cd /var/www/html
aws s3 cp s3://udemy-ec2-httpd-server-html .  --recursive
service httpd start
{% endhighlight %}

#### 2.1.7 Autoscaling

- Autoscaling Launch Configuration (define each instance)
- AutoScaling Groups (define how to scale(repeat) across AZ using Autoscaling Launch Configuration as primitive instance data)

#### 2.1.7 EC2 Placment Groups

- 2 Types
    - Clustered Placement Group
        - it is a group of instances within a **single** AZ. Placement groups are recommended for applications that need low network latency, high network throughput, or both. 通常用于big data，你不希望数据有高延时(被放在不同AZ)，你希望数据低延时(同一个AZ)
        - Only certain instances can be launched in to a Clustered Placement Group.
    - Spread Placement Group
        - distribute critical data among multiple AZ/region


-  Examp tips
    - A clustered placement group can't span multiple AZ while a spread placement group can.
    - The name you specify for a placement group must be unique within your aws account.
    - Only certain types of instances can be launched in a placement group (Compute Optimized, GPU, Memory Optimized, Storage Optimized)
    - AWS recommend homogenous instances within placement groups
    - You can't merget placement groups 
    - You can't move an existing instance into a placement group. You can create an AMI from your existing instance, and then launch a new instance from the AMI into a placement group.

#### 2.1.8 EFS

- What:
    - Previous, when you need block storage for EC2, normally you need pre-provisioning EC2 with EBS and no single EBS can be used by multiple EC2. EFS comes to solve this problen. It's block storage like EBS, but not pre-provisioning is needed and it can be accessed by multiple EC2 instances.
    - Suports Network File System verion 4 (NFSv4) protocal
    - can scale up to petabytes
    - can support thousands of concurrent NFS connections
    - data is stored across multiple AZ's within a region
    - Read After Write Consistency

### 2.2 Lambda

- What:
    AWS Lambda is a compute service where you can upload your code and create a lambda function. AWS Lambda takes care of provisioning and managing the servers that you use to run the code. You don't have to worry about operating systems, patching, scaling, etc. You ca use Lambda in the following ways:
    - As an event-drivent copute service where aws lambda runs your code in response to events. These events could be changes to data in an Amazon S3 bucekt or an Amazon DynamoDB table.
    - As a compute service to run your code in response to HTTP requests using Amazion API Gateway or API calls made using AWS SDKs.

- scale out
    - Lambda does scale out automatically. Note, scale out(more EC2) vs scale up(each EC2 upgrade resouces such as RAM) 

- Price
    - number of requests
        - first 1 million requests are free, $0.2 per 1 million requests thereafter.
    - duration
        - RAM + time

- Exam tips
    - Lambda scales out (not up) automatically
    - Lambda functions are independent, 1 event = 1 function
    - Lambda is serverless
    - Know what services are serverless
    - Lambda functions can trigger other lambda functions, 1 event can = x functions if functions trigger other fucntiosn
    - Architectures can get extremely complicated, AWS X-ray allows you to debug what is happening
    - Lambda can do things globally, you can use it to back up S3 buckets to other S3 butckets.
    - Know your triggers: api gateway, alexa kits.
    - Lambda maximum executing time is 5 min.




## 3 Monitoring

### 3.1 CloudWatch

- 2 types
    - Standard Monitoring = 5 minutes
    - Detailed Monitoring = 1 minute

- Dashboards: creates awesome dashboards to see what is happening with your AWS environment.

- Alarms: allows you to set alarms that notify you, such as via email when particular thresholds are hit.

- Events: helps you to respond to state changes in your AWS resources.

- Logs: helps you to aggregate, monitor, and store logs.

- CloudWatch vs CloudTrial: CloudWatch for performance monitoring aws existing resources (EC2 cpu utilization), CloudTrial for auditing what you do to aws (such as create new user, new role, S3 bucket)

## 4 Network

### 4.1 Route53

#### 4.1.1 Theory

- SOA Records
- NS Records
- A name
- C name
- alias name
- mx records

#### 4.1.2 Different Routing

- Simple Routing
    - you can only have **one record** with multiple IP addresses. Route53 will return ip address in a random order
- Weighted Routing
    - the same as simple routing except return ip address in a weighted probability (implemented with **multiple records**, each recortd www.example -> 25%, 30.0.0.1, the ec2 public ip) instead of random.
- Latency-based Routing:
    - the same as weighted routing, except return ip address that has the lowest latency
- Failover Routing:
    - a active (primary) record for major routing; a passive (backup) record when the primary record's ip address is not available (detected by Route53's health check).
- Geolocation Routing:
    - route to ip address based on the origin of client's request. For example, you want ip address from china to be all routed to EC2 in singpore.
- Multivalue Answer Routing
    - the same as simple routing execept has multiple records. The difference is Multivalue Answer Routing enable health check while simple routing not.

#### 4.1.3 Exam tips

### 4.2 VPC

- what
    - AWS VPC lets you provision a logically isolated section of the AWS Cloud where you can launch AWS resource in a virtual network you define. You have complete control over your virtual networking environment, including selection of your own IP address range, creation of subnets, and configuration of route tables and network gateways
    - Elements
        - Internet gateway (Virtual private gatway): each IGW can attach to one VPC
        - Route Table
        - Network Access Control List (Stateless)
        - Subnet (1 subnet = 1 AZ), each Subnet can associate one Network Access Control List 
        - Security Group (stateful, inbound rule apply to outbound automatically, for example, you add inbound rule  port 80, outbound 80 is enabled automatically, for Network Access Control List, you need to add outbound rule port 80 as well). Security Group can only be reused within the same VPC
    - No Transitive Peering: VPC A talk to Both VPC B and VPC C; VPC cannot talk to VPC B since no transitive peering for VPC. In order to let VPC C talk to VPC B, you need to enable the rule between VPC B and VPC directly.



- internet gateway
    - per internet gateway per VPC

- route table
    - map to subnets

- subnet
    - access control list

- security group

- each EC2 has a public and private ip address

- VPC Peering
    - Allows you to connect one VPC with another via a direct network route using private IP address
    - one vpc can connect to another vpc


### 4.2 Subnet

- One subnet equals one availability zone

### 4.3 NAT instance & NAT Gateway

- NAT instance 
    - When creating a NAT instance, Disable Source/Destination Check on the instance.
    - NAT instances must be in a public subnet
    - There must be a route out of the private subnet to the NAT instance, in order for this to work
    - The amount of traffic that NAT instances can support depends on the instance size. If you are bottlenecking, increase the instance size.
    - You can create high availability using Autoscaling Groups, multiple subnets in different AZs, and a script to automate failover.
    - Behind a secrity group

- NAT Gateway
    - Preferred by the enterprise
    - Scale automatically up to 10 Gbps
    - No need to patch
    - Not associated with security groups
    - Automatically assigned a public ip address
    - Remember to update your route tables
    - No need to disable source/destination checks.
    - More secure than a NAT instance

- NAT vs Bastion
    - A NAT is used to provide internet traffic to EC2 instance in private subnets
    - A bastion is used to securely administer EC2 instance (using SSH or RDP) in private subnets. In Australia we call them jump box.


### 4.4 Network Access Control List

- Your VPC automatically comes a default network ALC, and by default it allows all outbound and inbound traffic.

- When creating new Network ACL, the inbound and outbound default to all deny.

- Each subnet in your VPC must be associated with a network ACL. If you don't explicitly associate a subnet with a network ACL, the subnet is automatically associated with the default network ACL.

- You can associate a network ACL with multiple subnets; however, a subnet can be associated with only one network ACL at a time. When you associate a network ACL with a subnet, the previous association is removed.

- Network ACLs contain a numbered list of rules that is evaluated in order, starting with the lowest numbered rule.

- Block IP addresses using network ACLs not Security Groups

### 4.5 Security Group

- Security groups act like a firewall at the instance level whereas Network Access Control List are an additional layer of security that act at the subnet level

### 4.8 VPC Flow Logs

- what
    - VPC Flow Logs is a feature that enables you to capture information about the IP traffic going to and from network interfaces in your VPC. Flow log data is stored using Amazon CloudWatch Logs. After youo've created a flow log, you can view and retrieve its data in Amazon CloudWatch Logs.

    - 3 levels
    - VPC
    - Subnet
    - Network Interface Level

- Exam tips
    - You cannot enable flow logs for VPCs that are peered with your VPC unless the peer VPC is in your account
    - You cannot tag a flow log
    - After you've created a flow log, you cannot change its configuration; for exampke, you can't associate a different IAM role with the flow log.

    - Not all ip traffic is monitored:
        - Traffic generated by instances when they contact the Amazon DNS server. If you use your own DNS server, then all traffic to that DNS server is logged.
        - Traffic generated by a Windows instance for Amazon Windows license activation
        - Traffic to and from 169.254.169.254 for instance metadata
        - DHCP traffic
        - Traffic to the reserved IP address for the default VPC router. 

### 4.8 VPC Endpoint

### 4.9 Summary

- How many VPC's am I allowed in each AWS Region by default ? 5.


## 5 Database

### 5.1 Disk 

#### 5.1.1 Sql - OLTP

SQL
MySQL
PostgreSQL
Oracle
Aurora
MariaDB

##### 5.1.1.5 Aurora

- What
    - MYSQL-compatible, RDS engine that combines the speed and availability of heigh-end commerical databases. Aurora provides up to 5 times better formance than MysSQL at a price point one tenth that of a commercial database while delivering similar performance and availability.

- Scaling
    - start with 10 GB, salces in 10GB increments to 64 TB
    - Compute resources can scale up to 32vCPUs and 224GB of Memory.
    - 2 copies of your data is contained in each AZ, with minimum of 3 AZ. In total 6 copies of your data.
    - Self-healing. Data blocks and disks are continuously scanned for errors and repaired automatically.

- Replicas
    - 2 types
        - Aurora Replicas (current 15)
        - MySQL Read Replicas (current 15)



#### 5.1.2 NoSql

##### 5.1.2.1 DynamoDB

- What
    - Stored on SSD storage
    - Spread Across 3 geographically distinct data center (AZ)
    - Eventual Consistent Reads (default): from space pespective, multiple copies reach eventual consistent
    - Strongly Consistent Reads: from time pespective, all writes that is successful will be reflected for read after thoes writes.
    - pricce
        - Write throughtput $0.0065 per hour for every 10 units
        - Read throught $0.0065 per hour for every 50 units.
        - storage charge $0.25/(Gb * month)

- scaling
    - push button scaling, meaning you can scale your database in fly, without any down time.

### 5.2 RedShift - OLAP

- what
    - data warehousing service

- Configration
    - Single Node (160GB)
    - Multi - Node
        - Leader Node (manages client connections and receives queries)
        - Compute Node (store data and perform queries and computations). Up to 128 compute nodes.

- Storage type
    - Column storage, which is unlike normal row storage since OLAP often needs column aggregation computation and Column storage is more efficient for that.

- price
    - commpute node hours
    - backup
    - data transfer (only within a VPC, not outside it)

- Security
    - Encrypted in transit using SSL
    - Enctryped at rest using AES-256 encryption
    - By default, RedShift takes care of key management
        - manage your own keys through HSM
        - AWS Key Management Service

- Availability
    - Currently only available in 1 AZ
    - Can restore snapshots to new AZ's in the event of an outage



### 5.3 In memory Elasticache

- Exam tip:
    - Q: a scenario where a particular database is under a lof of stress/load, how to alleviate this
        - A: Elasticache if read heavy, not prone to frequent change
        - A: Redshitf if OLAP transactions is running on database.

#### 5.3.1 Memcached

- No Multi AZ

#### 5.3.2 Redis

- Multi AZ


### 5.4 Launch RDS instance and connect to it via EC2 server

- RDS instance has a separate security group from EC2 Serverinstance. If you want to let your EC2 server instance talk to RDS instance, make sure RDS instance's security group has inbound rule for mysql from the security group of EC2 server instance.

### 5.5 Back Ups, Multi-AZ & Read Replicas

- 2 types for RDS back up
    - Automatic Backup, enabled by default
    - Snaphot, done manually. They are stored even after you delete the original RDS instance, unlike automatic backup.
    - Whenver you retore either automatic backup or snapshot backup database, the restored version of the database will be a new RDS instance with a new DNS endpoint.

- Encryption
    - Encryption is done via AWS Key Management
    - Once your RDS instance is encrypted, the data stored at rest in the underlying storage is encrypted, as are its automated backups, read replicas, and snapshot
    - At the present time, encrypting an existing DB instance is not supoorted. To use Amazon RDS encryption for an existing database, you must first create a snapshot, make a copy of the snapshot and encrypt the copy.

- Multi AZ
    - allow you to have an exact copy of your production database in another AZ. 
    - AWS handles the replication for you, any write to primary database will be automatically synchronized to the replicate one.
    - If primary database fail (such as, db maintenance, az failure), the database instance endpoint url will be resolved to the ip address of the replicate database for you by aws. That's the reason you only know the endpoint url for database and shouldn't be exposed to the ip of the database.
    - RDS multi AZ is for disaster recovery only, not for performance improvement. For performance improvement, you need read replicas.
    - available for
       - MySQL
       - PostgreSQL
       - Aurora
       - MariaDB
       - Oracle
       - SQL

- Read replica
    - scaling out
    - allow you to have read-only copy of your production database. This is achieved by using asynchronous replication from the primary RDS instance to the read replica. You use read replicas primary for very read-heavy database workloads 
    - Must have automatic backups turned on in order to deploy a read replica.
    - You can have up to 5 read replica copies of any database.
    - You can have read replicas of read replicas
    - Reach read replica will have its own DNS end point
    - You can have read replicas that have multi AZ.
    - Read replicas can be promoted to be their own databases. This breaks the replication and is very useful for one to refactor the production database.
    - you can have read replica in a second region.
    - available for 
       - MySQL
       - PostgreSQL
       - Aurora
       - MariaDB 

## 6 Application Service

### 6.1 SQS

- What
    - Simple Queue Service
    - Consumer constantly pull the message
    - Message
        - size: 256 KB in any format
        - keeping time: 1 minute to 14 days, default to 4 days
        - visibility timeout (30s(default) to 12 hours): a consumer pull the message, the visibility timeout start counting, if the consumer finish proccessing the message before timeout, consumer will delete the message in the queue to avoid others see the message; if the consumer cannot finish processing the message before timeout, other consumer is supposed to see the message and pull it. Visibility timeout's aim is to avoid the same message being consumed more than once.

        - long polling vs short polling: for shor polling, the consumer poll from the queue, if no message, return immediately,; for long polling, the consumer will be blocked until there is an available message, which can save your money.


    - 2 types
        - Standard queue (default): message delivered at least once; however, more than one queue may be delivered out of order
        - FIFA queue: messages are guaranteed to be delivered once and in order, limited to 300 transactions per second.
        


### 6.2 SWF

- What:
    - Simpel Workflow service
    - Actors
        - Starter:
            the program that can initiate a workflow.
        - Workes:
            the program that interact with Amazon SWF to get tasks, process received taksks, and return the results
        - Decider:
            the program that controls the coordination of taks, i.e. their ordering, concurrency, and scheduling according to the application logic.
    - SWF vs SQS:
       - SWF ensures a task is assigned only once and is never duplicated. For SQS, after visibility timeout, if the consumer didn't delete it, the message is visible to other consumers.
       - SWF is task oriented while SQS is message oriented
       - SWF up to 1 year retention while SQS up to 14 days

### 6.3 SNS

- What
    - Simple Notification Service
    - Consumer being pushed the message
    - can trigger subscriber via
        - HTTP
        - HTTPS
        - Email
        - Email-JSON
        - SQS
        - Applicatoin
        - Lambda
    - allow you to group multiple recipients using topics.
    - SNS vs SQS:
        both messaging service in AWS
        - SQS Polls
        - SNS Push

### 6.4 Elastic Transcoder

- What
    - Media Transcorder: convert media files from their original source format in to different formats that will play on smartphones, tablets, PC's etc.
    - Pay based on minutes that you transcode and the resolution at which you transcode.

### 6.5 API Gateway

- What
    - The Network front door for client to access server, such as EC2, Lambda.
    - Enable response cache
    - Enable throttling requests to prevent requests
    - Connected to cloudWatch to log all requests
    - Low cost & Efficient & scales automatically.
    - Cross-Origin Resource Sharing (CORS)
        - CORS is a mechanism that allows restricted resources (e.g. fonts) on  a web page to be requested from another domain outside the domain from which the first resource was served
        - Error: "Origin policy cannot be read at the remote resource?". You need to enable CORS on API Gateway

### 6.6 Kinesis

- What
    - What is streaming data: the data that is generated continously by thousands of data sources, which typically send in the data records simultaneously, and in small sizes (order of kb), such as stock prices, game data, social network data, geospatial data
    - kinesis makes it easy to load and analyze streaming data, also providing the ability for you to build your own custom applications for you business needs.
    - 3 types:
        - Kinesis Streams: producers -> kinesis stream -> consumer (EC2). consists of shards.
        - Kinesis Firehose: can handle data directly using lambda and then upload results to S3 or ElasticSearch. No concern about shard.
        - Kinesis Analytics: using sql language to analysis data in Kinesis streams or Firhose


{: .img_middle_hg}
![kinesis](/assets/images/posts/-21_AWS/2017-10-01-AWS Associate Architect/kinesis.png)
    



## 2 参考资料 ##
- [《Vim Masterclass》](https://www.udemy.com/vim-commands-cheat-sheet/);



