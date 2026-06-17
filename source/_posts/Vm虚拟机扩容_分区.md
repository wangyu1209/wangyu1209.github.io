---
title: Vm虚拟机扩容/分区
copyrighr: true
date: 2026-06-17 09:53:11
tags:
  - Linux
  - Centos
categories:
  - VMware
---

# VMware 虚拟机使用 `cloud-utils-growpart` 扩容 Linux 根目录完整操作文档

## 1. 文档说明

本文档适用于在 **VMware 虚拟化环境**中，对 Linux 虚拟机的系统盘进行扩容，并使用 `cloud-utils-growpart` 工具扩展根分区的场景。

常见系统包括：

- CentOS 7 / CentOS 8
- Rocky Linux
- AlmaLinux
- RHEL
- Ubuntu
- Debian

本文重点说明以下场景：

```text
VMware 中已经扩展了虚拟磁盘容量
Linux 系统内需要扩容根目录 /
根分区位于 LVM 上
使用 growpart 扩展分区
使用 pvresize 扩展 LVM PV
使用 lvextend 扩展 LV
使用 xfs_growfs 或 resize2fs 扩展文件系统
```

---

# 2. 扩容前注意事项

## 2.1 操作风险

扩容属于磁盘分区和文件系统操作，建议在操作前完成以下事项：

1. 对虚拟机做快照；
2. 备份重要数据；
3. 确认虚拟机没有磁盘 I/O 异常；
4. 确认扩容的是正确磁盘；
5. 避免误操作数据盘。

---

## 2.2 常见根目录结构

执行：

```bash
df -Th
```

示例输出：

```text
Filesystem              Type      Size  Used Avail Use% Mounted on
/dev/mapper/centos-root xfs        17G   14G  3.2G  82% /
/dev/sda1               xfs      1014M  132M  883M  13% /boot
```

查看磁盘结构：

```bash
lsblk
```

示例：

```text
NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda               8:0    0   60G  0 disk
├─sda1            8:1    0    1G  0 part /boot
└─sda2            8:2    0   19G  0 part
  ├─centos-root 253:0    0   17G  0 lvm  /
  └─centos-swap 253:1    0    2G  0 lvm  [SWAP]
```

这里的含义是：

```text
/dev/sda      是整块系统盘
/dev/sda1     是 /boot 分区
/dev/sda2     是 LVM 分区
centos-root   是根目录 /
```

扩容目标通常是：

```text
/dev/sda2 -> LVM PV -> centos-root -> /
```

---

# 3. VMware 中扩展虚拟磁盘

## 3.1 关闭虚拟机或在线扩容

在 VMware vSphere / ESXi / Workstation 中：

1. 找到目标虚拟机；
2. 编辑虚拟机设置；
3. 找到系统盘，例如 Hard disk 1；
4. 将磁盘容量从 20G 调整到 60G；
5. 保存配置。

例如：

```text
原磁盘容量：20 GB
新磁盘容量：60 GB
```

如果系统支持在线识别磁盘变化，可以不用关机；如果不支持，建议重启虚拟机。

---

# 4. Linux 系统内识别新磁盘容量

## 4.1 查看当前磁盘容量

```bash
fdisk -l /dev/sda
```

示例：

```text
Disk /dev/sda: 64.4 GB, 64424509440 bytes, 125829120 sectors
```

如果这里已经显示新容量，说明系统已经识别到 VMware 扩容后的磁盘。

---

## 4.2 如果系统没有识别到新容量

可以尝试重新扫描 SCSI 设备。

查看 SCSI 设备：

```bash
ls /sys/class/scsi_device/
```

示例：

```text
0:0:0:0
2:0:0:0
```

执行重新扫描：

```bash
echo 1 > /sys/class/scsi_device/0\:0\:0\:0/device/rescan
```

或者扫描所有 SCSI Host：

```bash
for host in /sys/class/scsi_host/host*; do
  echo "- - -" > ${host}/scan
done
```

再次查看：

```bash
fdisk -l /dev/sda
lsblk
```

如果仍未识别，建议重启虚拟机：

```bash
reboot
```

---

# 5. 安装 `cloud-utils-growpart`

## 5.1 CentOS / RHEL / Rocky / AlmaLinux

```bash
yum install -y cloud-utils-growpart
```

或：

```bash
dnf install -y cloud-utils-growpart
```

---

## 5.2 Ubuntu / Debian

```bash
apt update
apt install -y cloud-guest-utils
```

Ubuntu / Debian 中，`growpart` 通常来自 `cloud-guest-utils` 包。

---

## 5.3 验证工具是否安装成功

```bash
growpart --help
```

或者：

```bash
which growpart
```

示例：

```text
/usr/bin/growpart
```

---

# 6. 确认根目录所在分区

## 6.1 查看根目录文件系统

```bash
df -Th /
```

示例：

```text
Filesystem              Type  Size  Used Avail Use% Mounted on
/dev/mapper/centos-root xfs    17G   14G  3.2G  82% /
```

说明根目录 `/` 使用的是 XFS 文件系统。

---

## 6.2 查看 LVM 结构

```bash
lsblk
```

示例：

```text
NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda               8:0    0   60G  0 disk
├─sda1            8:1    0    1G  0 part /boot
└─sda2            8:2    0   19G  0 part
  ├─centos-root 253:0    0   17G  0 lvm  /
  └─centos-swap 253:1    0    2G  0 lvm  [SWAP]
```

可以看出：

```text
整块磁盘：/dev/sda
需要扩展的分区：/dev/sda2
分区号：2
根 LV：/dev/mapper/centos-root
```

---

## 6.3 查看 LVM 信息

```bash
pvs
vgs
lvs
```

示例：

```text
# pvs
PV         VG     Fmt  Attr PSize   PFree
/dev/sda2  centos lvm2 a--  <19.00g    0

# vgs
VG     #PV #LV #SN Attr   VSize   VFree
centos   1   2   0 wz--n- <19.00g    0

# lvs
LV   VG     Attr       LSize
root centos -wi-ao---- 17.00g
swap centos -wi-ao----  2.00g
```

---

# 7. 使用 `growpart` 扩展分区

## 7.1 `growpart` 命令格式

```bash
growpart 磁盘 分区号
```

例如要扩展 `/dev/sda2`，正确命令是：

```bash
growpart /dev/sda 2
```

注意，不能写成：

```bash
growpart /dev/sda2 2
```

错误写法会报类似错误：

```text
this looks like a partition rather than the entire disk
```

因为 `/dev/sda2` 是分区，不是整块磁盘。

---

## 7.2 执行分区扩容

```bash
growpart /dev/sda 2
```

示例输出：

```text
CHANGED: partition=2 start=2099200 old: size=39843840 end=41943040 new: size=123729887 end=125829087
```

如果提示没有可用空间，可能是：

1. VMware 中磁盘没有实际扩容；
2. Linux 没有识别到新磁盘容量；
3. 分区已经扩展到最大；
4. 操作的磁盘或分区号不正确。

---

## 7.3 确认分区是否变大

```bash
fdisk -l /dev/sda
```

示例：

```text
Disk /dev/sda: 64.4 GB, 64424509440 bytes, 125829120 sectors

Device     Boot   Start       End   Blocks  Id System
/dev/sda1  *       2048   2099199  1048576  83 Linux
/dev/sda2       2099200 125829086 61864943+ 8e Linux LVM
```

也可以查看：

```bash
lsblk
```

示例：

```text
sda               8:0    0   60G  0 disk
├─sda1            8:1    0    1G  0 part /boot
└─sda2            8:2    0   59G  0 part
  ├─centos-root 253:0    0   17G  0 lvm  /
  └─centos-swap 253:1    0    2G  0 lvm  [SWAP]
```

此时 `/dev/sda2` 已经变大，但根目录 `/` 还没有变大。

---

# 8. 扩展 LVM PV

分区变大后，需要让 LVM 识别新增空间。

执行：

```bash
pvresize /dev/sda2
```

示例输出：

```text
Physical volume "/dev/sda2" changed
1 physical volume(s) resized or updated / 0 physical volume(s) not resized
```

查看 PV：

```bash
pvs
```

示例：

```text
PV         VG     Fmt  Attr PSize    PFree
/dev/sda2  centos lvm2 a--  <59.00g  40.00g
```

查看 VG：

```bash
vgs
```

示例：

```text
VG     #PV #LV #SN Attr   VSize    VFree
centos   1   2   0 wz--n- <59.00g  40.00g
```

此时 `VFree` 出现可用空间，说明可以继续扩展根 LV。

---

# 9. 扩展根 LV

## 9.1 查看根 LV 名称

```bash
lvs
```

示例：

```text
LV   VG     Attr       LSize
root centos -wi-ao---- 17.00g
swap centos -wi-ao----  2.00g
```

根 LV 通常有两种路径写法：

```bash
/dev/mapper/centos-root
```

或：

```bash
/dev/centos/root
```

二者一般等价。

---

## 9.2 将所有剩余空间扩展给根目录

```bash
lvextend -l +100%FREE /dev/mapper/centos-root
```

或：

```bash
lvextend -l +100%FREE /dev/centos/root
```

示例输出：

```text
Size of logical volume centos/root changed from 17.00 GiB to 57.00 GiB.
Logical volume centos/root successfully resized.
```

---

## 9.3 只扩展指定容量

如果不想把所有空间都给 `/`，例如只扩展 20G：

```bash
lvextend -L +20G /dev/mapper/centos-root
```

说明：

```text
-L +20G 表示在现有基础上增加 20G
-L 20G  表示调整到总大小 20G
```

通常建议使用：

```bash
-L +20G
```

避免误解。

---

# 10. 扩展文件系统

LV 扩容后，文件系统还需要扩容，否则 `df -Th` 看到的根目录大小不会变化。

不同文件系统使用不同命令。

---

## 10.1 XFS 文件系统扩容

如果 `df -Th /` 显示根目录类型是 `xfs`：

```text
/dev/mapper/centos-root xfs 17G 14G 3.2G 82% /
```

执行：

```bash
xfs_growfs /
```

示例输出：

```text
meta-data=/dev/mapper/centos-root isize=512 agcount=4, agsize=1114112 blks
data blocks changed from 4456448 to 14942208
```

注意：

```text
XFS 扩容使用挂载点 /
不是设备名
```

正确：

```bash
xfs_growfs /
```

不推荐写成：

```bash
xfs_growfs /dev/mapper/centos-root
```

---

## 10.2 ext4 文件系统扩容

如果 `df -Th /` 显示根目录类型是 `ext4`：

```text
/dev/mapper/ubuntu--vg-ubuntu--lv ext4 20G 10G 9G 53% /
```

执行：

```bash
resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv
```

或者：

```bash
resize2fs /dev/ubuntu-vg/ubuntu-lv
```

---

# 11. 验证扩容结果

## 11.1 查看根目录容量

```bash
df -Th /
```

示例：

```text
Filesystem              Type  Size  Used Avail Use% Mounted on
/dev/mapper/centos-root xfs    57G   14G   43G  25% /
```

---

## 11.2 查看磁盘结构

```bash
lsblk
```

示例：

```text
NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda               8:0    0   60G  0 disk
├─sda1            8:1    0    1G  0 part /boot
└─sda2            8:2    0   59G  0 part
  ├─centos-root 253:0    0   57G  0 lvm  /
  └─centos-swap 253:1    0    2G  0 lvm  [SWAP]
```

---

## 11.3 查看 LVM 状态

```bash
pvs
vgs
lvs
```

示例：

```text
# pvs
PV         VG     Fmt  Attr PSize    PFree
/dev/sda2  centos lvm2 a--  <59.00g      0

# vgs
VG     #PV #LV #SN Attr   VSize    VFree
centos   1   2   0 wz--n- <59.00g      0

# lvs
LV   VG     Attr       LSize
root centos -wi-ao---- 57.00g
swap centos -wi-ao----  2.00g
```

---

# 12. 一键操作命令示例

以下命令适用于：

```text
系统盘：/dev/sda
LVM 分区：/dev/sda2
根 LV：/dev/mapper/centos-root
文件系统：xfs
```

完整命令：

```bash
df -Th /
lsblk
fdisk -l /dev/sda

growpart /dev/sda 2
pvresize /dev/sda2
lvextend -l +100%FREE /dev/mapper/centos-root
xfs_growfs /

df -Th /
lsblk
pvs
vgs
lvs
```

---

# 13. ext4 文件系统一键示例

如果根目录是 ext4：

```bash
df -Th /
lsblk
fdisk -l /dev/sda

growpart /dev/sda 2
pvresize /dev/sda2
lvextend -l +100%FREE /dev/mapper/ubuntu--vg-ubuntu--lv
resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv

df -Th /
lsblk
pvs
vgs
lvs
```

---

# 14. 非 LVM 场景说明

有些系统根目录没有使用 LVM，例如：

```text
/dev/sda1 ext4 /
```

或：

```text
/dev/sda2 xfs /
```

这种情况下流程不同：

```text
growpart 扩展分区
直接扩展文件系统
```

---

## 14.1 非 LVM + ext4

假设根目录是 `/dev/sda2`，文件系统是 ext4：

```bash
growpart /dev/sda 2
resize2fs /dev/sda2
df -Th /
```

---

## 14.2 非 LVM + XFS

假设根目录是 `/dev/sda2`，文件系统是 XFS：

```bash
growpart /dev/sda 2
xfs_growfs /
df -Th /
```

---

# 15. 常见问题

## 15.1 `growpart /dev/sda2 2` 报错

错误命令：

```bash
growpart /dev/sda2 2
```

可能报错：

```text
this looks like a partition rather than the entire disk
```

原因：

```text
/dev/sda2 是分区，不是整块磁盘
```

正确命令：

```bash
growpart /dev/sda 2
```

---

## 15.2 `growpart` 提示没有空间

可能原因：

1. VMware 中没有真正扩展磁盘；
2. Linux 没识别到新磁盘容量；
3. 当前分区已经占满整块磁盘；
4. 扩错磁盘；
5. 扩错分区号。

检查：

```bash
fdisk -l /dev/sda
lsblk
```

---

## 15.3 执行 `pvresize` 后 `vgs` 没有空闲空间

检查 `/dev/sda2` 是否真的变大：

```bash
lsblk
fdisk -l /dev/sda
pvs
vgs
```

如果 `/dev/sda2` 没有变大，说明 `growpart` 没成功。

---

## 15.4 `lvextend` 后 `df -Th` 容量没变化

原因是只扩展了 LV，没有扩展文件系统。

如果是 XFS：

```bash
xfs_growfs /
```

如果是 ext4：

```bash
resize2fs /dev/mapper/xxx
```

---

## 15.5 不知道根 LV 路径

查看：

```bash
df -Th /
```

示例：

```text
/dev/mapper/centos-root xfs 17G 14G 3.2G 82% /
```

根 LV 就是：

```bash
/dev/mapper/centos-root
```

也可以用：

```bash
lvs
```

---

## 15.6 XFS 可以在线扩容吗？

可以。

XFS 支持在线扩容，不需要卸载根目录。

执行：

```bash
xfs_growfs /
```

---

## 15.7 XFS 可以缩容吗？

不可以。

XFS 文件系统不支持直接缩容。

因此扩容前要确认容量分配规划。

---

# 16. 推荐标准操作流程

推荐在生产环境按以下顺序执行：

```bash
# 1. 查看扩容前状态
df -Th /
lsblk
fdisk -l /dev/sda
pvs
vgs
lvs

# 2. 扩展分区
growpart /dev/sda 2

# 3. 扩展 LVM PV
pvresize /dev/sda2

# 4. 查看 VG 空闲空间
vgs

# 5. 扩展根 LV
lvextend -l +100%FREE /dev/mapper/centos-root

# 6. 扩展 XFS 文件系统
xfs_growfs /

# 7. 验证结果
df -Th /
lsblk
pvs
vgs
lvs
```

---

# 17. 示例完整记录

## 17.1 扩容前

```bash
df -Th /
```

```text
Filesystem              Type  Size  Used Avail Use% Mounted on
/dev/mapper/centos-root xfs    17G   14G  3.2G  82% /
```

```bash
fdisk -l /dev/sda
```

```text
Disk /dev/sda: 64.4 GB, 64424509440 bytes, 125829120 sectors

Device     Boot   Start       End   Blocks  Id System
/dev/sda1  *       2048   2099199  1048576  83 Linux
/dev/sda2       2099200  41943039 19921920  8e Linux LVM
```

---

## 17.2 执行扩容

```bash
growpart /dev/sda 2
```

```text
CHANGED: partition=2 start=2099200 old: size=39843840 end=41943040 new: size=123729887 end=125829087
```

```bash
pvresize /dev/sda2
```

```text
Physical volume "/dev/sda2" changed
1 physical volume(s) resized or updated / 0 physical volume(s) not resized
```

```bash
lvextend -l +100%FREE /dev/mapper/centos-root
```

```text
Size of logical volume centos/root changed from 17.00 GiB to 57.00 GiB.
Logical volume centos/root successfully resized.
```

```bash
xfs_growfs /
```

```text
data blocks changed from 4456448 to 14942208
```

---

## 17.3 扩容后

```bash
df -Th /
```

```text
Filesystem              Type  Size  Used Avail Use% Mounted on
/dev/mapper/centos-root xfs    57G   14G   43G  25% /
```

---

# 18. 总结

VMware 中扩容 Linux 根目录的核心流程是：

```text
VMware 扩展虚拟磁盘
        ↓
Linux 识别新磁盘容量
        ↓
growpart 扩展分区
        ↓
pvresize 扩展 LVM PV
        ↓
lvextend 扩展根 LV
        ↓
xfs_growfs 或 resize2fs 扩展文件系统
        ↓
df -Th 验证结果
```

LVM + XFS 根目录的常用命令是：

```bash
growpart /dev/sda 2
pvresize /dev/sda2
lvextend -l +100%FREE /dev/mapper/centos-root
xfs_growfs /
df -Th /
```

其中：

```text
growpart        扩展分区
pvresize        扩展 LVM 物理卷
lvextend        扩展 LVM 逻辑卷
xfs_growfs      扩展 XFS 文件系统
resize2fs       扩展 ext4 文件系统
```