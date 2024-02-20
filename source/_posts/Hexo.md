---
title: Hexo部署
copyrighr: true
date: 2024-02-09 10:14:39
cover: https://img.myhappiness.top/img/Hexo.jpg
tags:
    - Linux
    - Centos
categories:
    - Linux
---
# 源码安装git
## 下载源码包并解压
```
curl -kO https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.33.8.tar.gz
tar xf git-2.33.8.tar.gz
cd git-2.33.8/
```
## 安装编译依赖包
```
yum -y install dh-autoreconf curl-devel expat-devel gettext-devel openssl-devel perl-devel zlib-devel gcc
```
## 编译安装
```
make prefix=/usr/local/git all
make prefix=/usr/local/git install
```
## 配置环境变量
```
echo "export PATH=$PATH:/usr/local/git/bin" >> /etc/profile
##使配置生效
source /etc/profile
##验证是否安装成功
git --version
```
# 安装node.js
```
curl -O  https://nodejs.org/download/release/v17.9.1/node-v17.9.1-linux-x64.tar.xz
tar -xf node-v17.9.1-linux-x64.tar.xz
mv node-v17.9.1-linux-x64 /usr/local/node
echo "export PATH=$PATH:/usr/local/node/bin" >> /etc/profile
source /etc/profile
node -v # 查看版本
npm -v # 查看版本
```
# 安装Hexo
```
npm install -g hexo-cli
hexo init /hexo/blog/  #/hexo/blog/为你要安装hexo的路径
cd /hexo/blog/
hexo g
hexo server
```
##使用nginx代理
yum -y install nginx
```
cat > /etc/nginx/conf.d/hexo.conf <<EOF
    server {
        listen       80 default_server;
        listen       [::]:80 default_server;
        server_name  _;
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
    }
EOF
```
```
systemctl start nginx
systemctl enable nginx
```

# 更换主题
```
 npm i hexo-renderer-swig
修改配置文件
```
