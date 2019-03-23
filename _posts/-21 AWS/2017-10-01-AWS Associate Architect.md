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

## 1. Storage ##

### 1.1 IAM

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

#### 1.6.1 EBS Volume Types

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

    - Spot - enables you to bid whatever price you want for instance capacity, providing for even greater savings if your application shave flexible start and end times. Applications that have flexible start and end times. Applications that are only feasible at very low compute prices. Can be purchased on-Demand (hourly). Can be purchased as a Reservation for up to 70% off the on-demand price. If a spot instance is terminated by Amazon EC2, you will not be charged for a partial hour of usage; However, if you  terminate the instance your self, you will be charged for the complete hour in which the instance ran.

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

#### 2.1.4 EBS Volumes


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


## 4 Network

### 4.2 Subnet

- One subnet equals one availability zone


## 2 参考资料 ##
- [《Vim Masterclass》](https://www.udemy.com/vim-commands-cheat-sheet/);



