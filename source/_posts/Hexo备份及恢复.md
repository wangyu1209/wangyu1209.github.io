---
title: Hexo备份及恢复
copyrighr: true
date: 2024-07-12 02:21:21
tags:
    - Linux
categories:
    - 常用服务安装
---

## hexo备份

1.进入博客根目录执行

```
git init
```

2.编写vim .gitignore文件添加以下内容（添加的内容表示git push时忽略这些文件）

```
.DS_Store
Thumbs.db
db.json
*.log
node_modules/
public/
.deploy*/
_multiconfig.yml
package-lock.json
```

3.如果有使用git clone安装主题，需要删除主题配置文件的.git文件（例如安装了以下两个主题）

```
rm -rf themes/butterfly/.git
rm -rf themes/next/.
```

4.上传代码到github及gitee

```
# 配置git
git config --global user.name "github用户名"
git config --global user.email "github邮箱"
git config user.name
git config user.email
ssh-keygen -t rsa -C "github邮箱"
#将生成的id_pub内容复制到github->setting->ssh key里面
#使用ssh -T 验证github和gitee是否正常通信，出现以下返回信息说明成功。
[root@control blog]# ssh -T git@github.com
Hi wangyu1209! You've successfully authenticated, but GitHub does not provide shell access.
[root@control blog]# ssh -T git@gitee.com
Hi wangyu1209(@wangyu1209)! You've successfully authenticated, but GITEE.COM does not provide shell access.
#提交代码到github及gitee
git add .
git commit -m "init blog backup"
git branch -m master hexo  #将本地分支重命名为hexo便于管理
git remote add github git@github.com:xxxxx/xxxxx.github.io.git
git remote add gitee git@gitee.com:xxxxx/xxxxx.github.io.git
git push -u github hexo:hexo
git push -u gitee hexo:master
```

## hexo恢复

安装git和node.js

```
npm install -g cnpm
cnpm install -g hexo-cli
```

clone备份仓库的代码到本地

```
git clone -b hexo git@github.com:xxxxx/xxxxx.github.io.git /hexo/blog/
```

clone原博客内容

```
cd /hexo/blog/
npm install
git clone  git@github.com:xxxxx/xxxxx.github.io.git .deploy_git
git config --global user.name "github用户名"
git config --global user.email "github邮箱"
```

正常更新博客

```
hexo clean
hexo g
hexo d
```


