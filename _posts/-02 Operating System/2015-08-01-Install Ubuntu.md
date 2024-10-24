---
layout: post
title: Install Ubuntu
categories: [-02 Operating System]
tags: [Operating System, Devops, Linux]
number: [-2.1]
fullview: false
shortinfo: 台式机安装Ubuntu。
---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1: Make Bootable Ubuntu USB

## 1.1: Make Bootable Ubuntu USB

{% highlight bash linenos %}
//Step 1: Format to Mac OS Extended (Journaled)

//Step 2: Download the ubuntu iso

//Step 3; Convert iso to IMG format
hdiutil convert -format UDRW -o ~/Path-to-IMG-file ~/Path-to-ISO-file

//Step 4: Get the usb device number, say 5
diskutil list

//Step 5: Unmount usb
diskutil unmountDisk /dev/disk5

//Step 6: dd
sudo dd if=/Path-to-IMG-DMG-file of=/dev/rdisk5 bs=1m
// output:
// 1109+1 records in
// 1109+1 records out
// 1162936320 bytes transferred in 77.611025 secs (14984164 bytes/sec)

//Step 7: Eject usb
diskutil eject /dev/diskN

//Done and go to plugin usb to your machine and reboot!

{% endhighlight %}

## 1.2: Make Bootable Ubuntu based Ukylin USB

{% highlight bash linenos %}
// in Windows to make bootable USB
//Step 1: Download Ventory software in windows

//Step 2: Download the Uklin iso: https://ubuntukylin.com/downloads/osdownload-cn.html

//Step 3; Format USB

// Step 4: copy Uklin iso to the USB, follow
// - https://mp.weixin.qq.com/s/h7Lcyb5-PqB0q-pHUINCug
//  https://ubuntukylin.com/public/pdf/2004.pdf
// 特别需要注意：
// 分区是，选“自定义分区”（而非快速安装，因这种方式给更目录/分的空间太小了！！！）
// - efi 2g
// - /data 20g
// - /backup 20g
// - /tmp 20g
// - /     剩下全部，1TB是约938g 

// Step 5: Done and go to plugin usb to your machine and reboot!

// Step 6: after install Ukylin
// 为防止休眠后无法唤醒, 在设置 -> 系统 -> 电源 -> 此段时间后休眠 改为“从不”


// Chrome installed from ukylin built-in software store
// if `ls` cannot show chinese correclty: run `export LC_ALL=C.UTF-8`

{% endhighlight %}

## 2 Install software


{% highlight bash linenos %}
//install vim, git
sudo apt install vim git -y

//查看ubuntu版本代号
lsb_release -a

//Distributor ID: Ubuntu
// ....
//Codename: impish <----this one

// change apt source and add Codename
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
sudo vim /etc/apt/sources.list //全替换为清华源

deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ impish focal main restricted
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ impish focal-updates main restricted
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ impish focal universe
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ impish focal-updates universe
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ impish focal multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ impish focal-updates multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ impish focal-backports main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ impish focal-security main restricted
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ impish focal-security universe
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ impish focal-security multiverse

// 更新 apt
sudo apt-get update

// If GPG error: the following signatures could not be verified beacause the public key is not available
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys KEY

//查看ubuntu版本代号
sudo apt-get upgrade

//安装 build-essential
sudo apt-get install build-essential

//安装 zsh
sudo apt install zsh -y

//安装 ohmyzsh https://github.com/ohmyzsh/ohmyzsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

//copy customized .zshrc

//install powerfont for zsh
sudo apt install fonts-powerline

//安装 nvm https://github.com/nvm-sh/nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

//install node v14.15.4
nvm install 14.15.4

//install yarn, https://classic.yarnpkg.com
npm install --global yarn

//install python2
sudo apt install python2

//install nautilus: nautilus ~/Desktop      will open folder
sudo apt install nautilus

//install code and chrome from website

// update code default settings and keybindings
// https://github.com/shunmian/dotfiles/tree/master/Mackup/Library/Application%20Support/Code/User/settings.json
// https://github.com/shunmian/dotfiles/tree/master/Mackup/Library/Application%20Support/Code/User/keybindings.json

// fix code zsh terminal font issue
// https://stackoverflow.com/questions/62710890/font-issues-while-integrating-zsh-on-visual-studio-code

// installing aws-cli and graphicsmagick
sudo apt install awscli
sudo apt-get install graphicsmagick

{% endhighlight %}

## A 参考资料 ##

- [Making Bootable Ubuntu from USB](https://itsfoss.com/create-bootable-ubuntu-usb-drive-mac-os/);
- [Making Bootable Ubuntu from USB 2](https://blog.csdn.net/qq_25883823/article/details/54744823);

- [The Architecture of Open Source Applications: Nginx](http://www.aosabook.org/en/nginx.html);


