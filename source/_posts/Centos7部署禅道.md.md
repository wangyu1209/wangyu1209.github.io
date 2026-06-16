---
title: Centos7部署禅道.md
copyrighr: true
date: 2026-06-16 17:42:06
tags:
  - Centos
  - Linux
categories:
  - 常用服务部署
---

## Centos7.6系统下安装httpd，mariadb，php7.2环境运行禅道

**摘要**：本文介绍如何在Centos7.4系统下面使用yum命令安装httpd，php7.2与mariadb服务，并使用禅道源码包运行禅道软件。

**一、运行环境说明**

推荐运行环境为 **Apache + PHP(7.0/7.1/7.2版本) + MySQL(5.5/5.6版本)/mariadb 组合** ，Nginx 其次。

PHP需要使用 pdo, pdo_mysql, json, filter, openssl, mbstring, zlib, curl, gd, iconv 模块，需要确保 PHP 运行环境有加载上述模块。

**二、安装Apache服务**

依次执行如下指令，安装并开启 Apache 服务:

```
yum -y install httpd           #安装Apache服务
systemctl start httpd.service  #开启Apache服务 
systemctl enable httpd.service #Apache服务开机启动
```

Apache 其他运维命令:

```
systemctl status httpd.service  #查看Apache服务状态 
systemctl stop httpd.service    #关闭Apache服务 
systemctl restart httpd.service #重启Apache服务
```

**关闭防火墙**( 或者自行百度相关指令开启服务器的 80 端口 )，以便排除因为网络问题 , 无法访问 Apache 服务:

```
systemctl stop firewalld.service     # 关闭防火墙 
systemctl disable firewalld.service  # 禁止firewall开机启动 

systemctl status firewalld.service   # 查看防火墙状态 
systemctl start firewalld.service    # 开启防火墙
```

**关闭 SELINUX**，未关闭时可能有无法授予 /var 路径下文件的读写权限问题，关闭命令如下:

```
setenforce 0 # 临时关闭SELINUX, 重启服务器失效
```

编辑 **/etc/selinux/config** 文件，将 SELINUX 的值设置为 disabled , 下次开机 SELINUX 就不会启动了

```
vi /etc/selinux/config # 修改文件中的 SELINUX=disabled 
```

浏览器访问 http://服务器ip地址 , 页面展示如下，则表示 Apache 运行成功了。

![image-20220119131142749](https://img.myhappiness.top/img/image-20220119131142749.png)

**apache 会被安装到： /etc/httpd/**

**apache 配置文件地址： /etc/httpd/conf/httpd.conf**

**apache 网站文件默认访问路径：/var/www/html/**

**三、安装PHP7.2版本**

PHP7.2 版本需要配置 yum 源 :

```
rpm -Uvh https://mirror.webtatic.com/yum/el7/epel-release.rpm
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
```

yum 安装 PHP7.2 所需组件 :

```
yum -y install php72w php72w-pdo php72w-mysql php72w-mbstring php72w-ldap php72w-gd php72w-json php72w-xml php72w-zip
```

创建 phpinfo 文件, 测试 PHP 与 Apache 服务的整合:

```
echo '<?php phpinfo();?>'  >  /var/www/html/index.php
```

访问前 , 重启 Apache 服务，浏览器访问 http://服务器ip/index.php，页面展示如下, 则Apache 解析 PHP 成功。

```
systemctl restart httpd
```

![image-20220119132419268](https://img.myhappiness.top/img/image-20220119132419268.png)

**四、安装mariadb 数据库**

安装并开启 mariadb 服务:

```
yum -y install mariadb mariadb-server 
systemctl start mariadb.service # 开启服务 
systemctl enable mariadb.service # 开机启动 
systemctl status mariadb.service # 查看服务状态
```

重置数据库 root 账号密码( 默认root密码为空 )，命令行执行如下命令 , 注意执行命令前必须开启 mariadb服务:

```
mysql_secure_installation 

Enter current password for root (enter for none): # 输入当前root账号密码，刚安装默认为空，直接回车即可 
Set root password? [Y/n] # 是否输入root密码，输入y 回车 
New password: # 输入密码 
Re-enter new password: # 重复输入 
Remove anonymous users? [Y/n] # 删除其他用户 y 
Disallow root login remotely? [Y/n]  # 允许root账号远程登录 y 
Remove test database and access to it? [Y/n]  # 删除测试表 y 
Reload privilege tables now? [Y/n] # 重新加载配置表 y
```

**五、安装禅道软件**

1,下载新版禅道软件源码包, 下载地址：http://www.zentao.net/download.html

2,使用 rz 命令将禅道软件上传至服务器的 /var/www/html 目录，您也可以使用其他方式上传。

```
yum -y install lrzsz # 安装rz上传程序 
cd /var/www/html # 切换到apache根目录 
rz # 上传源码包禅道
```

3,使用 unzip 命令解压禅道源码包程序。

```
yum -y install unzip # 安装unzip解压 
unzip ZenTaoPMS.*.zip -d /var/www/html # 解压禅道源码包
```

![image-20220119132934924](https://img.myhappiness.top/img/image-20220119132934924.png)

4, 修改 Apache 访问路径: vim /etc/httpd/conf/httpd.conf , 注意修改如下图 3处位置 :

![image-20220119133152481](https://img.myhappiness.top/img/image-20220119133152481.png)

修改后 systemctl restart httpd 重启 Apache 服务, 使刚修改的配置生效 ;

5.解压完成后，浏览器访问 http://服务器ip 地址，安装禅道即可。

![image-20220119133223530](https://img.myhappiness.top/img/image-20220119133223530.png)

![image-20220119133246321](https://img.myhappiness.top/img/image-20220119133246321.png)

![image-20220119133305974](https://img.myhappiness.top/img/image-20220119133305974.png)

![image-20220119133517063](https://img.myhappiness.top/img/image-20220119133517063.png)

![image-20220119133602183](https://img.myhappiness.top/img/image-20220119133602183.png)

![image-20220119133646402](https://img.myhappiness.top/img/image-20220119133646402.png)

![image-20220119133707642](https://img.myhappiness.top/img/image-20220119133707642.png)

使用账号密码登录，用户名：admin 密码：123456

![image-20220119133801875](https://img.myhappiness.top/img/image-20220119133801875.png)

至此搭建完成
