---
title: Hexo博客部署
copyrighr: true
date: 2024-07-12 02:18:18
tags:
    - Linux
categories:
    - 常用服务部署
---
# Hexo博客部署

### 源码安装git

**1.**安装编译依赖包****

```
yum -y install dh-autoreconf curl-devel expat-devel gettext-devel openssl-devel perl-devel zlib-devel gcc
```

**2.下载源码包并解压**

```
curl -kO https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.33.8.tar.gz
tar xf git-2.33.8.tar.gz
cd git-2.33.8/
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
npm install -g cnpm
cnpm install -g hexo-cli
hexo init /hexo/blog/  #/hexo/blog/为你要安装hexo的路径
cd /hexo/blog/
npm install
hexo g
hexo server
```

> 安装完Hexo后可以使用以下两种方式来管理访问自己的网站
>
> 如果是公网服务器推荐使用nginx代理绑定自己的域名即可；如果是本地电脑想要通过公网访问你的网站则推荐使用Githubpages托管你的网页。

#### **使用nginx代理**

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

#### **将hexo托管到Github pages**

1. 建立名为 ***username\*.github.io**的储存库
2. 安装`hexo-deployer-git`并添加密钥要Github上

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

2. **修改_config.yml文件**

```
deploy:
  type: git
  repo: git@github.com:xxx/xxxx.github.io.git  #此处可以查看github新建的仓库地址
  branch: main
```

3. **配置自定义域名**

   在source目录下，新建CNAME文件输入自定义域名信息

   添加域名解析记录CNAME记录值：`USERNAME.github.io`

4. 在储存库中前往 **Settings** > **Pages** >**Custom domain**填写自定义域名，根据需求勾选**Enforce HTTPS **开启强制https启动

5. **发布文章到github上**

   ```
   hexo clean
   hexo g
   hexo d
   ```

> 经过以上配置即可通过自定义域名来访问你的博客
