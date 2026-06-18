---
title: WSL提示“请求的操作成功，直到重新启动系统前更改将不会生效
copyrighr: true
date: 2026-06-18 10:47:46
tags:
  - Linux
categories:
  - WSL
---

# WSL提示“请求的操作成功，直到重新启动系统前更改将不会生效”完整解决
## 一、先分清两种情况
1. **正常提示（重启就好）**
执行 `wsl --install` / 启用Windows可选组件时，系统安装了**虚拟机平台、WSL子系统**两个底层组件，这类内核级修改必须重启加载，提示是正常流程。
操作：保存文件，**完整重启电脑**，重启后再打开PowerShell执行安装/设置命令。

2. **异常循环（重启后再次弹出同提示，WSL仍不可用）**
重启后功能没生效、重复提示，按下面顺序排查修复。

## 二、前置硬性条件（不满足怎么重启都无效）
### 1. BIOS开启CPU虚拟化（最常见根源）
WSL2必须硬件虚拟化支持，否则虚拟机平台加载失败、重启失效：
- 开机按 `Del/F2/F10/F12`（品牌不同按键不同）进BIOS
- Intel CPU：开启 `Intel Virtualization Technology / VT-x`
- AMD CPU：开启 `SVM Mode / AMD-V`
保存退出重启Windows。

### 2. Windows版本达标
Win10 ≥ 2004（内部版本19041+）；Win11全版本支持
`Win+R` 输入 `winver` 查看版本，过低先升级系统。

### 3. 必须用管理员终端
右键开始菜单 → Windows PowerShell(管理员) / 终端(管理员)，普通权限会导致组件安装不完整。

## 三、命令行强制重装WSL组件（解决重启失效）
管理员PowerShell逐条执行：
```powershell
# 1. 先关闭WSL、卸载已有Linux发行版（有就执行，没有跳过）
wsl --shutdown
wsl --unregister Ubuntu

# 2. 彻底关闭两个核心功能
dism.exe /online /disable-feature /featurename:Microsoft-Windows-Subsystem-Linux
dism.exe /online /disable-feature /featurename:VirtualMachinePlatform
```
**重启电脑**

重启后再打开管理员终端，启用组件：
```powershell
# 3. 重新完整启用WSL和虚拟机平台
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```
再次**完整重启**。

重启完成后执行：
```powershell
# 安装WSL内核、设置默认WSL2
wsl --update
wsl --set-default-version 2
# 一键安装Ubuntu
wsl --install -d Ubuntu
```
运行出现下面这个，重启设备重新执行`wsl --install -d Ubuntu`即可。
```
wsl --install -d Ubuntu
正在安装 Windows 可选组件: VirtualMachinePlatform

部署映像服务和管理工具
版本: 10.0.26100.8521

映像版本: 10.0.26200.8655

启用一个或多个功能
[==========================100.0%==========================]
操作成功完成。
请求的操作成功。直到重新启动系统前更改将不会生效。
```