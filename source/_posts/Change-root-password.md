---
title: Centos7破解root密码
copyrighr: true
date: 2024-03-14 02:34:16
tags:
- Linux
categories:
- Linux
---
# Centos7破解root密码

- 使用LiveCD进入救援模式修改root密码
- 使用单用户模式重置密码

## 使用LiveCD进入救援模式修改root密码

1.挂载iso镜像，设置CD/DVD启动

2.进入系统引导界面选择故障排除选项

![image-20240314153853059](https://img.myhappiness.top/img/image-20240314153853059.png)

3.选择第二个选项救援系统

该界面翻译如下：

- 在基本图形模式下安装 Cent0S 7

- 拯救 Cent0S 系统

- 运行内存测试

- 从本地硬盘启动

- 返回主菜单 <

- 按 Tab 键查看菜单项的全部配置选项
  如果系统无法启动，您可以通过它访问文件
  并编辑配置文件，尝试重新启动。

![image-20240314154146844](https://img.myhappiness.top/img/image-20240314154146844.png)

4.进入如下界面时选择1

![image-20240314154637870](https://img.myhappiness.top/img/image-20240314154637870.png)

按下回车键，进入shell

![image-20240314155259975](https://img.myhappiness.top/img/image-20240314155259975.png)

进入shell后执行命令修改root密码

```
chroot /mnt/sysimage
passwd root
```

![image-20240314155010902](https://img.myhappiness.top/img/image-20240314155010902.png)

退出shell，将自动重新启动系统，密码修改完成（注意重启后取消挂载镜像）

![image-20240314155908550](https://img.myhappiness.top/img/image-20240314155908550.png)

## 使用单用户模式重置密码

1.重启系统，在出现内核选择界面时，按键盘上下方向键，进入如下图所示界面，选择第一项，按e键盘进行编辑

![image-20240314144449565](https://img.myhappiness.top/img/image-20240314144449565.png)

2.编辑内核界面找到ro这一行，修改为 rw init=/sysroot/bin/sh

![image-20240314145159278](https://img.myhappiness.top/img/image-20240314145159278.png)

3.按Ctrl+x进入如下图所示的救援模式

原理：启动一个shell环境，系统并没有真正启动

![image-20240314145648557](https://img.myhappiness.top/img/image-20240314145648557.png)



4.更改目录并更改密码

chroot命令用来在指定的根目录下运行指令

chroot即 change root directory(更改根目录)。在Linux系统中，系统默认的目录结构都是以"/"(根目录)开始的，在使用chroot命令后，系统的目录结构以指定的位置作为根目录。

在使用chroot命令后，系统读取到的目录和文件将不在是旧系统根目录下的，而是新根目录下的目录和文件。

使用以下命令进行更改root密码操作

```
chroot /sysroot
passwd root
```

![image-20240314151058433](https://img.myhappiness.top/img/image-20240314151058433.png)

**注意：**

如果系统开启了Selinux则需要执行命令touch ./autorelabel 以更新系统信息，否则重启系统更改的密码不会生效。

修改完密码后需要退出当前根目录，然后重启系统。

![image-20240314151539518](https://img.myhappiness.top/img/image-20240314151539518.png)

