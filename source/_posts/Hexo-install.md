---
title: Hexo部署
copyrighr: true
date: 2024-02-09 10:14:39
tags:
    - Linux
    - Centos
categories:
    - Linux
    - 常用服务安装
---
# 本地环境搭建

### 源码安装git

**1.下载源码包并解压**

```
curl -kO https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.33.8.tar.gz
tar xf git-2.33.8.tar.gz
cd git-2.33.8/
```
**2.安装编译依赖包**

```
yum -y install dh-autoreconf curl-devel expat-devel gettext-devel openssl-devel perl-devel zlib-devel gcc
```
**3.编译安装**

```
make prefix=/usr/local/git all
make prefix=/usr/local/git install
```
**4配置环境变量**

```
echo "export PATH=$PATH:/usr/local/git/bin" >> /etc/profile
##使配置生效
source /etc/profile
##验证是否安装成功
git --version
```
### 安装node.js

```
curl -O  https://nodejs.org/download/release/v17.9.1/node-v17.9.1-linux-x64.tar.xz
tar -xf node-v17.9.1-linux-x64.tar.xz
mv node-v17.9.1-linux-x64 /usr/local/node
echo "export PATH=$PATH:/usr/local/node/bin" >> /etc/profile
source /etc/profile
node -v # 查看版本
npm -v # 查看版本
#设置npm镜像源为国内
npm config set registry https://registry.npmmirror.com/
#查看当前配置的npm源
npm config get registry
```
### 安装Hexo

```
npm install -g hexo-cli
hexo init /hexo/blog/  #/hexo/blog/为你要安装hexo的路径
cd /hexo/blog/
npm install
hexo g
hexo server
```
**使用nginx代理**

注意：使用nginx代理后发布文章只需要执行`hexo clean` `hexo g`无需使用hexo server启动服务

```
yum -y install nginx
```

创建图像存放路径`mkdir -p /var/www/html/images`
```
cat > /etc/nginx/conf.d/hexo.conf <<EOF
server {
    listen       80 default_server;
    listen       [::]:80 default_server;
    server_name  192.168.20.10;
    root         /hexo/blog/public;

    include /etc/nginx/default.d/*.conf;

    location / {
    }
    error_page 404 /404.html;
        location = /40x.html {
    }

    error_page 500 502 503 504 /50x.html;
        location = /50x.html {
    }
    location /images {
    alias /var/www/html/images;
    }
}
EOF
```
```
systemctl start nginx
systemctl enable nginx
```

# 将hexo托管到Github pages

> 安装配置hexo见上面教程

### 配置githubpag

```
npm install hexo-deployer-git --save
# 配置git
git config --global user.name "github用户名"
git config --global user.email "github邮箱"
git config user.name
git config user.email
ssh-keygen -t rsa -C "github邮箱"
#将生成的id_pub内容复制到github->setting->ssh key里面
#使用ssh -T git@github.com验证
[root@control blog]# ssh -T git@github.com
The authenticity of host 'github.com (20.205.243.166)' can't be established.
ECDSA key fingerprint is SHA256:p2QAMXNIC1TJYWeIOttrVc98/R1BUFWu3/LiyKgUfQM.
ECDSA key fingerprint is MD5:7b:99:81:1e:4c:91:a5:0d:5a:2e:2e:80:13:3f:24:ca.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'github.com,20.205.243.166' (ECDSA) to the list of known hosts.
Hi wangyu1209! You've successfully authenticated, but GitHub does not provide shell access.
```
**修改_config.yml文件**

```
deploy:
  type: git
  repo: git@github.com:xxx/xxxx.github.io.git  #此处可以查看github新建的仓库地址
  branch: main
```

## 发布文章到github上

```
hexo clean
hexo g
hexo d
```

## 更换主题

> 此次使用butterfly，有关此主题更多用法见https://butterfly.js.org/

```
git clone -b master https://github.com/jerryc127/hexo-theme-butterfly.git themes/butterfly
```
**安装插件**

```
npm install hexo-renderer-pug hexo-renderer-stylus --save
```
**升级建议**
将主题目录的_config.yml文件拷贝到hexo根目录下并命名为_config.butterfly.yml(注意：复制的是主题目录的_config.yml.不是hexo根目录的_config.yml.不要删除主题目录的_config.yml删除)
以后只需要在_config.butterfly.yml进行配置即可
如果使用了_config.butterfly.yml，配置主题的_config.yml将不会生效
Hexo会自动合并主题的_config.yml和_config.butterfly.yml里的配置，如果存在同名配置，会使用_config.butterfly.yml的配置，其优先度高。

**应用主题**
修改 Hexo 根目录下的 _config.yml，把主題改為 butterfly
```
theme: butterfly
```
**配置站点信息**

```
# Site
title: 12零9  #标题
subtitle: ''   #副标题
description: ''  #个性签名
keywords:   
author: Mr wang   #作者
language: zh-CN   #语言
timezone: ASia/Shanghai #时区
url: http://192.168.20.10/ #网站
```
**支持的语言**
- zh-CN 简体中文
- zh-TW 繁体中文
- default(en) 默认英文

**设置主题代码样式**
1.编辑_config.butterfly.yml修改以下内容
```
highlight_theme: mac #  darker / pale night / light / ocean / mac / mac light / false 代码主题
highlight_copy: true # copy button  复制按钮
highlight_lang: false # show the code language 是否显示代码语言
highlight_shrink: false # true: shrink the code blocks / false: expand the code blocks | none: expand code blocks and hide the button 
highlight_height_limit: false # unit: px
code_word_wrap: true #代码自动换行，关闭滚动条
```
2.同时将站点配置文件_config.yml的hightlight设置为false
```
lighlight:
  enable: false
  line_number: false
  auto_detect: false
  tab_replace: ''
  wrap: true
  hljs: false
```
### 标签页

1.CD到Hexo博客根目录
2.输入命令`hexo new page tags`
3.编辑source/tags/index.md文件写入以下内容

```
---
title: 标签
date: 2024-02-09 10:06:49
type: "tags"
orderby: random
order: 1
---
```
**参数解释**
type 【必须】页面类型，必须为`tags`
orderby 【可选】排序方式：random/name/length
order 【可选】排序次序：1，asc for ascending; -1, desc for descending

### 分类页面

1.CD到Hexo博客根目录
2.输入命令`hexo new page categories`
3.编辑source/categories/index.md文件写入以下内容
```
---
title: 分类
date: 2024-02-09 10:09:21
type: "categories"
---
```
### 设置菜单目录

修改主题配置文件
```
# Menu 目录
menu:
  首页: / || fas fa-home
  时间轴: /archives/ || fas fa-archive
  标签: /tags/ || fas fa-tags
  分类: /categories/ || fas fa-folder-open
  # List||fas fa-list:
  #   Music: /music/ || fas fa-music
  #   Movie: /movies/ || fas fa-video
  # Link: /link/ || fas fa-link
  # About: /about/ || fas fa-heart
```
注意：必须是/xxx/后面||分开，然后写图标名，如果不希望显示图标，图标名可不写。导航的文字可自行修改。

### 头像

修改主题配置文件
```
avatar:
  img: http://192.168.20.10/images/avatar.jpg
  effect: false # true头像会一直转圈

```
### 顶部图片

修改主题配置文件
```
index_img: http://192.168.20.10/images/top.jpg
```

### 文章图片

文章md文件中添加cover
```
cover: http://192.168.20.10/images/Hexo.jpg
```
