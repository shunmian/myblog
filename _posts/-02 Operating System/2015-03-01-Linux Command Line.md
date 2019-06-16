---
layout: post
title: The Linux Command Line
categories: [-02 Operating System]
tags: [Operating System, Devops, Linux]
number: [-02.1]
fullview: false
shortinfo: 本文《The Linux Command Line》的笔记。

---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## Part I: Learning the Shell ##

### C1: What is the Shell

- double click a word is copy, middle button in the mouse is paste.
- `exit` will quit the terminal

### C2: Navigation

### C3: Exploring the System

### C4: Manipulating Files and Directories

disk ---(format)--> filesystem ---(mount)--> directory tree.

/dev/sda9 is the first(a) disk device 9th partion, normally, you need to `mount /dev/sda9 /home`, which mount file system (formatted disk device) in to direcotry tree

- df: disk usage in file system. `df -h`, h for human ßreadable
- du: TBC

- ln: hard link vs symbolic link







### C5: Working with Commands

### C6: Redirection

- redirect output: `>`;
- redirect error: `2>`; 2 stands for 2 file descriptor;
- redirect both output and error: `&>`; `ls -l /bin/usr 2> /dev/null`;
- redirect input: `<`;

- pipeline: 
  - wc
  - sort
  - uniq
  - grep
  - head
  - tail
  - tee


### C7: Seeing the World as the Shell Sees It

- `*`: Character Expansion: `echo *`
- `*`: Pathname Expansion: `echo *s`, `echo [[:upper:]]*`, `echo /usr/*/share`
- `~`: Tilt Expansion: `echo ~`(the home direcotry of current user)
- `$(())`: Arithmetic Expansion: `echo $((2+2))`
- `{}`: Brace Expansion: `echo Number_{A,B,C}`, `echo Number_{1..5}`, `echo {Z..A}`, `echo a{A{1,2},B{3,4}}b`
- `$`: Parameter(data) Expansion: `echo $USER`
- `$()`: Command(procedure) Expansion: `ls -l $(which cp)`
- ``:命令替换
  "":弱引用，可以实现变量替换
  '':强引用，不实现变量替换
- `\`: 转义字符。

### C8: Advanced Keyboard Tricks

- Navigate: `^+a`, `^+e`, `^+f`, `^+b`
- `history`
- `clear`: `^+l`

### C9: Permissions

- `id`
- `chmod`
- `umask`
- `su`
- `sudo`: The sudo command is like su in many ways, but has some important additional capabilities. The administrator can configure sudo to allow an ordinary user to execute commands as a different user (usually the superuser) in a very controlled way.
- `chown`: `chwon foo.txt bob:jack`
- `chgrp`
- `passwd`

### C10: Processes

- `ps`: report a snapshot of current processes
- `top`: report dynamically of current processes
- `jobs`: list active jobs
- `&`: put process in the background
- `ctrl-C`and `ctrl-Z`: kill & background
- `bg`: place a job in the background
- `fg`: place a job in the foreground
- `kill`: send a signal to a process. `kill -9 xlogo` sends signal 9 to xlogo.
- `pstree`
- `vmstat`
- `xload`
- `tload`
- `shutdown`: shut down or reboot the system

## Part II: Configuration and the Environment ##

### C11: The Environment

> **Shell Variable vs Temp Env Variable**: `shellVar=shellVar; export envVar=envVar; printenv | grep 'shellVar\|envVar'`, output `envVar=envVar`. shellVar只存在当前shell process, **不会被子进程继承**；envVar会被子进程继承，但是用export只是temp(即再开一个shell，`printenv | grep envVar`会输出空), 如果要persist,就得`export envVar=envVar`到`~/.profile`或`~/.bash_profile`文件。

{: .img_middle_lg}
![cprintf]({{site.url}}/assets/images/posts/-02_Operating System/Linux_Command_Line/2015-03-01-Linux Command Line/env_config_file.png)

- `printenv`: 只打印env variables
- `set`: 打印shell variables and env variables
- `export`: 设置一个env variables
- `alias`
- `source`: exectue a script, usually used to activate the changes of `~/.bash_profile` via `source ~/.bash_profile`.


### C12: A Gentle Introduction to VI

### C13: Customizing the Prompt



## Part III: Common Tasks and Essential Tools ##

### C14: Package Management

- `yum`: high level, package CRUD
- `rpm`: low level, install the downloaded file

### C15: Storage Media

- `mount`: mount(attach a device to the filesystem tree) a filesystem
- `unmount`: unmount a filesystem
- `fdisk`: partition table manipulation
- `fsck`: check and repair a filesystem
- `fdformat`: format a floppy disk
- `mkfs`: create a filesystem
- `dd`: write a block-oriented data directly to a device
- `genisoimage`(mkisofs): create an ISO 9660 image file
- `wodim`(cdrecord): write data to optical storage media
- `md5sum`: calculate an MD5 checksum.

### C16: Networking

- `ping`: send an ICMP ECHO_REQUEST to network hosts, `ping www.google.com`
- `traceroute`: trace the path of a network packet, `traceroute www.google.com`.
- `netstat`: Print network connections, routing tables, interface statistics, masquerade connections and multicast memberships. `netstat -l | grep echo`输出和echo相关的网络信息。
- `ftp`: internet file transfer program.
- `lftp`: An improved internet file transfer program.
- `wget`: Non-interactive network downloader, `wget http://www.linuxcommand.org/`
- `ssh`: OpenSSH SSH(Secure Shell) client (remote login program)
  - telnet is like ssh but the content is not encrypted
  - `sshd` is the server
  - `ssh` is the client, `ssh lal@212.215.3.2`
  - set public/private key is safer than password, `ssh-keygen` generate `~/.ssh/id_rsa`(private key) and `~/.ssh/id_rsa.pub`(public key, which should go to server `authorized_keys` file)
- `scp`: Secure copy (remote file copy program)
- `sftp`: Secure file transfer program
- `arp`: 查看arp(ip to mac)信息，`arp -a` display all arp cache entry.

- DNS
    - `host`, DNS lookup utility, `host www.yahoo.com`
    - `nslookup`, DNS lookup utility, `nslookup www.yahoo.com` 


### C17: Searching for Files

- `locate`: search files by name， ``
- `find`: search files in a directory hierarchy, `find ~ -type f -and -name 'shift.sh'`(查找~目录下名字为shift.sh的文件)
- `xargs`: build and execute command lines from standard input
- `touch`: change file times
- `stat`: display file or filesystem status

### C18: Archiving and Backup

- `gzip`, compress or expand files, `gzip test.txt`, `gunzip test.txt.gz`
- `bzip2`, similar to gzip with different compressing algo to achieve higher compress ratio.
- `tar`, tap-archiving utility
- `zip`, both archiving and compress.
- `rsync`, remote file and directory synchronization

### C19: Regular Expressions

- `grep`

### C20: Text Processing

- `cat`
- `sort`
- `uniq`
- `cut`
- `paste`
- `join`
- `comm`

### C21: Formatting Output

- `nl`: number of lines
- `fold`: wrap each line to a specified length
- `fmt`: a simple text formatter
- `pr`: format text for printing
- `printf`: format and print data
- `groff`: a document formatting system


### C22: Printing

- `pr`, convert text files for printing
- `lpr`, print files
- `a2ps`, format files for printing on a PostScript printer
- `lpstat`, show printer status information
- `lpq`, show printer queue status
- `lprm`, cancel print jobs
- `cancel`, cancel print jobs

### C23: Compiling Programs

- `make`


## Part IV: Writing Shell Scripts ##

### C24: Writing Your First Script

### C25: Starting a Project

The shell does not care about the type of data assigned to a variable; it treats them all as strings.

{% highlight c linenos %}
a=z                   # Assign the string "z" to a variable a.
b="a string"          # Embedded spaces must be within quotes.
c="a string and $b"   # Other expansions such as variables can be expanded into the assignment.
e=$((5 * 7))          # Arithmetic expansion.
f="\t\ta string\n"    # Escape sequences such as tabs and newlines.
{% endhighlight %}    # Results of a command.




### C26: Top-Down Design

- function

{% highlight c linenos %}
#!/bin/bash
# Shell function demo
function funct {
	echo "2"
	return
}

echo "1"
funct
echo "3"
{% endhighlight %}    # Results of a command.

- local variable

{% highlight c linenos %}
#!/bin/bash

foo=0
function funct {
	local foo=1
	echo $foo
	return
}

echo "global: foo=$foo"
funct
echo "global: foo=$foo"
{% endhighlight %}    # Results of a command.

### C27: Flow Control - Branching With If
- `test expression` 等价于 `[ expression ]`。
- `[[ expression ]]` 和 `[ expression ]`相似，但增加了正则表达式的判断。
- `(( 2+2 ))`用于算术运算。

{% highlight c linenos %}
#!/bin/bash

FILE=~/.bashrc

if	[ -f $FILE ]; then
	echo "$FILE is a file"
elif [ -d $FILE ]; then
	echo "$FILE is directory"
else
	echo "$FILE is another type"
fi
{% endhighlight %}

{: .img_middle_lg}
![test_expression_for_file_string_integer]({{site.url}}/assets/images/posts/-02_Operating System/Linux_Command_Line/2015-03-01-Linux Command Line/test_expression_for_file_string_integer.png)


### C28: Reading Keyboard Input

`read`

### C29: Flow Control - Looping With While And Until

{% highlight c linenos %}

#!/bin/bash

count=1

while [ $count -le 5 ]; do
	echo $count
	count=$((count+1))
done
echo "Finished".
{% endhighlight %}

{% highlight c linenos %}
#!/bin/bash

count=1

until [ $count -gt 5 ]; do
	echo $count
	count=$((count+1))
done
echo "Finished".
{% endhighlight %}


### C30: Troubleshooting

### C31: Flow Control - Branching With Case

{% highlight c linenos %}

#!/bin/bash
# case-menu: a menu driven system information program

clear
echo "
Please Select:
A. Display System Information
B. Display Disk Space
C. Display Home Space Utilization
Q. Quit
"
read -p "Enter selection [A, B, C or Q] > "
case $REPLY in
q|Q) echo "Program terminated."
     exit
     ;;
a|A) echo "Hostname: $HOSTNAME"
     uptime
     ;;
b|B) df -h
     ;;
c|C) if [[ $(id -u) -eq 0 ]]; then
         echo "Home Space Utilization (All Users)"
         du -sh /home/*
     else
         echo "Home Space Utilization ($USER)"
         du -sh $HOME
     fi
     ;;
*)   echo "Invalid entry" >&2
     exit 1
     ;;
esac

{% endhighlight %}

### C32: Positional Parameters

{% highlight c linenos %}

#!/bin/bash
# posit-param: script to view command line parameters
echo "
Number of arguments: $#
\$0 = $0
\$1 = $1
\$2 = $2
\$3 = $3
\$4 = $4
\$5 = $5
\$6 = $6
\$7 = $7
\$8 = $8
\$9 = $9
"

{% endhighlight %}

### C33: Flow Control - Looping With For

`for i in {A..D}; do echo $i; done`

### C34: Strings and Numbers

{% highlight c linenos %}

{% endhighlight %}

### C35: Arrays

### C36: Exotica






## A1: extra command TBC

- `service`
- `chkconfig`





{: .img_middle_lg}
![cprintf]({{site.url}}/assets/images/posts/-02_Operating System/6828/2015-02-04-OS MIT 6828 Part I：Operating system interfaces/cprintf.png)

{% highlight c linenos %}

{% endhighlight %}

## 5 参考资料 ##

- [《xv6 book - chapter 0: Operating System Interfaces》](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-828-operating-system-engineering-fall-2012/lecture-notes-and-readings/);





