#!/bin/bash

#hexo自动备份脚本

git add .
git commit -m "init blog backup"
git push -u github hexo:hexo
git push -u gitee hexo:master

if [ $? = 0 ]; then
     echo "备份成功"
else
     echo "备份失败"
fi
