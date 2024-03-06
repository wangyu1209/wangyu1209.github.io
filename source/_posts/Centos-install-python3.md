---
title: Centos安装python3
copyrighr: true
date: 2024-02-19 20:53:39
tags:
    - Python
    - Linux
    - Centos
categories:
    - Python
---
# Centos安装python3

安装需要的依赖
```
yum install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gcc make zlib zlib-devel -y
```
拉取python安装包
```
wget https://www.python.org/ftp/python/3.6.8/Python-3.6.8.tar.xz
```
解压python源码包
```
xz -d Python-3.6.8.tar.xz
tar -xf Python-3.6.8.tar
```
编译安装
```
cd Python-3.6.8
./configure prefix=/usr/local/python3
make -j 4 && make install
```
编译安装完成后会在/usr/local下生成python3目录

![image-20211117162220282](https://img.myhappiness.top/img/image-20211117162220282.png)

添加软链接，并备份之前的链接目录
```
mv /usr/bin/python /usr/bin/python.bak
ln -s /usr/local/python3/bin/python3.6 /usr/bin/python
```
更改配置文件，配置yum，因为yum使用的是python2
```
vim /usr/bin/yum
改：#! /usr/bin/python
为：#! /usr/bin/python2
```
更改配置文件
```
vim /usr/libexec/urlgrabber-ext-down
改：#! /usr/bin/python
为：#! /usr/bin/python2
```
验证版本号
```
[root@localhost ~]# python -V
Python 3.6.8
```
使用python2版本
```
[root@localhost ~]# python2
Python 2.7.5 (default, Oct 30 2018, 23:45:53) 
[GCC 4.8.5 20150623 (Red Hat 4.8.5-36)] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> 
```
使用python3版本
```
python
Python 3.6.8 (default, Nov 17 2021, 16:00:46) 
[GCC 4.8.5 20150623 (Red Hat 4.8.5-39)] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> 
```
配置pip软链接
```
rm  -rf /usr/bin/pip
ln -s /usr/local/python3/bin/pip3  /usr/bin/pip
```
查看pip版本，并升级pip
```
[root@localhost ~]pip -V
pip 18.1 from /usr/local/python3/lib/python3.6/site-packages/pip (python 3.6)
[root@localhost ~]pip install --upgrade pip
[root@localhost ~]# pip -V
pip 21.3.1 from /usr/local/python3/lib/python3.6/site-packages/pip (python 3.6)
```
