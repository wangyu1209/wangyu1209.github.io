---
title: Git分支管理
copyrighr: true
date: 2026-06-15 17:23:13
tags:
  - Gitcategories:
  - Git
categories:
  - Git
---


# 当前main是旧代码 → 旧代码打1.0版本 → 上传新代码覆盖main为最新版
前提：本地当前在 `main` 分支，当前代码就是**你要归档成1.0的旧版本**，不存在名为`1.0`的旧标签

## 步骤1：确认当前状态（必执行）
```bash
# 确认所在分支
git branch
# 查看提交历史，确认当前就是旧版代码
git log --oneline
```
正常输出：`* main`，当前HEAD指向旧代码提交记录

## 步骤2：将当前旧main代码打上版本标签 1.0
### 2.1 本地创建版本标签（带备注，规范正式标签）
```bash
git tag -a 1.0 -m "版本1.0：初始旧版代码归档"
```
- `-a`：创建附注标签（正式发版推荐）
- 不加 `-a` 就是轻量标签，仅做快照

### 2.2 把标签推送到远程GitHub仓库
```bash
git push origin 1.0
```
此时效果：
远程仓库 `tag 1.0` 固定锁定你改版前所有旧代码；`main` 暂时还是旧代码

## 步骤3：放入你的新代码，更新main分支
### 3.1 覆盖/新增修改项目内所有新代码
把你准备好的新版本文件、修改后的文件，直接覆盖到项目根目录，删除废弃旧文件也直接手动处理

### 3.2 将所有变更加入暂存区
```bash
git add .
# 查看改动核对
git status
```

### 3.3 提交新版本到本地main
```bash
git commit -m "迭代更新：main分支升级为最新代码"
```

### 3.4 推送到远程main分支
```bash
git push origin main
```

## 最终成品结构
1. **远程 main 分支**：存放你刚上传的最新代码，后续迭代都往这个分支提交
2. **标签 1.0**：永久快照保存改版之前原始旧代码，可随时查看、下载、回退

## 常用后续操作（按需使用）
### 查看所有本地+远程标签
```bash
git tag
git ls-remote --tags origin
```

### 临时切换查看1.0旧代码（不会改动main）
```bash
git checkout 1.0
# 看完切回最新main
git checkout main
```

### 后续再迭代新版本常规提交模板
```bash
git add .
git commit -m "本次修改说明"
git push origin main
```

## 补充：如果后续想打出 2.0、3.0 版本逻辑一致
1. 当前main是稳定新版本
2. `git tag -a 2.0 -m "版本2.0说明"`
3. `git push origin 2.0`