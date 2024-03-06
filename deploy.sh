#!/bin/bash

#########################################
# Script Name: deploy.sh
# Author: wangyu
# Contact: wangyu@755136227@gmail.com
# Created Date: 2024-02-23
# Last Modified Date: 2024-02-23
#########################################

# 确保在 Hexo 项目根目录下运行此脚本

#清除缓存
hexo clean
# 生成静态文件
hexo generate

# 部署到 GitHub Pages
hexo deploy

# 输出成功信息
echo "发布成功！"

