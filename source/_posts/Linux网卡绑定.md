---
title: Linux网卡绑定
copyrighr: true
date: 2024-04-18 14:21:16
tags:
- Linux
categories:
- Linux
---
## Bond的工作原理及作用

网卡绑定（Bonding）是一种网络技术，通过将多个物理网卡（NICs）组合成一个逻辑网卡，以提高网络带宽、增加容错能力和提高性能。这种技术可以在服务器或网络设备上使用，以实现负载均衡和冗余备份。

### 工作原理：
1. **负载均衡**：在负载均衡模式下，数据包会根据预定的算法分发到绑定的多个网卡上，从而提高网络带宽和性能。不同的负载均衡算法可以根据源地址、目的地址、端口号等因素来选择发送数据包的网卡，确保网络流量均匀分布。

2. **冗余备份**：在冗余备份模式下，如果一个网卡失效，系统会自动切换到备用网卡，确保网络连接的连续性和可靠性。这种模式提供了容错能力，使系统在网卡故障时仍能正常运行。

### 作用：
1. **提高带宽**：通过将多个网卡组合成一个逻辑网卡，可以将多个网络连接的带宽叠加在一起，提高整体网络带宽。

2. **提高性能**：负载均衡模式可以将网络流量分散到多个网卡上处理，从而提高系统的性能和响应速度。

3. **容错能力**：冗余备份模式可以保证在一个网卡失效时系统仍然可用，提高系统的可靠性和稳定性。

4. **灵活性**：网卡绑定技术提供了多种工作模式选择，管理员可以根据具体需求选择最适合的模式，满足不同的网络环境和应用需求。

## Bond的几种工作模式

在Linux系统中，网卡绑定（Bonding）技术提供了不同的模式，也称为Bond模式，用于定义多个物理网卡如何工作在一起以提供带宽聚合、负载均衡和冗余备份等功能。以下是一些常见的Bond模式的介绍：

1. **Round Robin (mode 0)**:
   - 数据包会依次通过每个网卡发送，实现简单的负载均衡。

2. **Active-Backup (mode 1)**:
   - 一个网卡为活动状态，另一个为备用状态，当活动网卡失效时自动切换到备用网卡。

3. **Balance XOR (mode 2)**:
   - 使用源和目的IP地址的散列（hashing）来选择发送数据包的网卡，实现负载均衡。

4. **Broadcast (mode 3)**:
   - 所有数据包都通过所有网卡发送，用于广播。

5. **802.3ad (LACP) (mode 4)**:
   - 使用链路聚合控制协议（LACP）来协调多个网卡之间的绑定，提供带宽聚合和冗余备份。

6. **Balance TLB (mode 5)**:
   - 根据负载情况动态选择网卡发送数据包，实现负载均衡和容错能力。

7. **Balance ALB (mode 6)**:
   - 结合了负载均衡和活动备份的特性，数据包通过所有网卡发送，但接收数据包时只使用一张网卡。

## 使用nmcli命令做Bond

示例：使用nmcli命令做bond0，其他bond模式只需修改mod模式即可

**注意：**如ens36网卡已配置网络并正在使用nmcl命令则无法进行直接修改配置文件，会生成一个类似ens36-1的配置文件。

解决方法：

1. 进入网卡配置文件目录将ens36-1文件覆盖ens36

```
systemctl start NetworkManager
nmcli connection add type bond con-name bond0 ifname bond0 mode 0 miimon 100
nmcli connection modify bond0 ipv4.addresses "192.168.10.20/24" ipv4.method manual
nmcli connection modify bond0 ipv4.gateway "192.168.10.2"
nmcli connection modify bond0 ipv4.dns "223.5.5.5"
nmcli connection add type Ethernet con-name ens36 ifname ens36 master bond0
nmcli connection add type Ethernet con-name ens37 ifname ens37 master bond0
systemctl stop NetworkManager && systemctl disable NetworkManager && systemctl restart network
```

## 使用传统配置网卡文件模式做Bond

```
# 创建bond主配置文件
cat > /etc/sysconfig/network-scripts/ifcfg-bond0 <<EOF
DEVICE=bond0
TYPE=bond
NAME=bond0
BONDING_MASTER=yes
BOOTPROTO=static
USERCTL=no
ONBOOT=yes
IPADDR=填写对应的ip
PREFIX=掩码位：例如24
GATEWAY=网关
DNS1=DNS地址
BONDING_OPTS="mode=0 miimon=100"
EOF

# 修改网卡一配置文件
cat > /etc/sysconfig/network-scripts/ifcfg-eth1 <<EOF
TYPE=Ethernet
BOOTPROTO=none
DEVICE=eth1
ONBOOT=yes
MASTER=bond0
SLAVE=yes
EOF

# 修改网卡二配置文件
cat > /etc/sysconfig/network-scripts/ifcfg-eth2 <<EOF
TYPE=Ethernet
BOOTPROTO=none
DEVICE=eth2
ONBOOT=yes
MASTER=bond0
SLAVE=yes
EOF

#重启网络服务生效
systemctl restart network
```


