---
layout: post
title: Emacs(一)： Foundamentals
categories: [-20 Text Editor]
tags: [Emacs]
number: [-20.1]
fullview: false
shortinfo: 《Teach Yourself Emacs in 24 Hours》简介。
---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1. Emacs ##

### Hour 3: get started

By default, buffers that do not correspond to files on disk contain stars around their names.

Difference?

- emacs variable
- emacs function: invoked from other functions or by command of `eval-expression`/`eval-last-sexp`
- emacs command: mainly invoked interactively by keybindings or with `M-x`; can also be invoked by other function calls. Not all functions are commands but all commands are functions. A function is turn into command by `(interactive)`. `M-x apropos`, `M-x apropos-command`, `M-x aprops-documentation` (search by keyword in function description)
- emacs keysequence: `M-x describe-key` to check the keysequence binding.

### 1.1 主要用法



### 1.2 同步的usecase



## Reference

- [Writing GNU Emacs Extension](https://book.douban.com/subject/1432819/);
