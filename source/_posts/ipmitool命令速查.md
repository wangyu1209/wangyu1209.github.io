---
title: ipmitool命令速查
copyrighr: true
date: 2026-06-17 11:07:58
tags:
  - Linux
categories:
  - 常用命令工具
---

# **ipmitool 命令速查表**  
*(适用于 Linux、Windows（Cygwin/WSL）和 macOS)*  

> **常用选项**  
> - `-I <interface>`   – 接口类型 (`open`, `lan`, `lanplus`, `serial`, `imb`)  
> - `-H <host>`        – 目标 BMC IP（远程）  
> - `-U <user>`        – 用户名（远程）  
> - `-P <passwd>`      – 密码（远程）  
> - `-L <priv>`        – 权限级别 (`admin`, `user`, `operator`)  
> - `-f <file>`        – 从文件读取参数  
> - `-c`               – 生成 CSV 输出（适用于 `sensor`、`fru`）  

---

## 目录
1. **会话 / 连接**  
2. **系统 (System) 命令**  
3. **传感器 (Sensor) 命令**  
4. **事件日志 (Event Log)**  
5. **电源控制 (Power Control)**  
6. **SOL / Serial‑Over‑Lan**  
7. **用户 / 权限 (User / Privilege)**  
8. **FRU / 硬件信息**  
9. **LAN / 网络**  
10. **Chassis / 机箱**  
11. **Boot / 启动**  
12. **Raw 命令**  
13. **Debug / 其他**  

---

## 1️⃣ 会话 / 连接

| 命令 | 说明 |
|------|------|
| `ipmitool -I <interface> -H <host> -U <user> -P <passwd> <command>` | 完整远程调用模式 |
| `ipmitool -I open <command>` | 本地（直接访问 BMC） |
| `ipmitool -I lanplus -L <priv> <command>` | 通过 LAN+（默认） |
| `ipmitool -I serial <command>` | 使用串行线路 (KCS / Serial) |
| `ipmitool -I imb <command>` | 使用 Intel IMB（特定平台） |

---

## 2️⃣ 系统 (System) 命令

| 命令 | 说明 |
|------|------|
| `ipmitool chassis status` | 查看机箱状态（电源、风扇、温度） |
| `ipmitool mc info` | BMC（MC）基本信息 |
| `ipmitool mc reset warm` | **软** 重启 BMC（warm） |
| `ipmitool mc reset cold` | **硬** 重启 BMC（cold） |
| `ipmitool sdr list` | 列出所有传感器（Sensor Data Repository） |
| `ipmitool sensor list` | 同上（简写） |
| `ipmitool sel info` | SEL（系统事件日志）概要 |
| `ipmitool sel list` | 列出全部 SEL 条目 |
| `ipmitool sel clear` | 清除 SEL |
| `ipmitool sel get <id>` | 按 ID 查看单条 SEL |
| `ipmitool event <command>` | 事件/日志相关（兼容旧版） |
| `ipmitool chassis identify [<seconds>]` | 让机箱指示灯闪烁（定位） |
| `ipmitool chassis bootdev <dev> [options]` | 设定下次启动设备（e.g., `pxe`, `disk`, `cdrom`) |
| `ipmitool chassis bootparam get 5` | 查看当前 boot 参数（5=bootdev） |
| `ipmitool chassis power status` | 查询电源状态 |
| `ipmitool chassis power on` | 开机 |
| `ipmitool chassis power off` | 关机（软） |
| `ipmitool chassis power cycle` | 重启（软） |
| `ipmitool chassis power reset` | 强制硬重启（等同于 `mc reset cold`） |
| `ipmitool chassis power diag` | 诊断测试（平台依赖） |
| `ipmitool chassis policy list` | 列出电源/风扇策略 |
| `ipmitool chassis policy set <policy>` | 设置电源/风扇策略 |
| `ipmitool chassis control <command>` | 发送原始控制命令（如 `poweron`, `poweroff`) |

---

## 3️⃣ 传感器 (Sensor) 命令

| 命令 | 说明 |
|------|------|
| `ipmitool sensor` | 列出所有传感器（默认） |
| `ipmitool sensor get <id>` | 读取单个传感器值 |
| `ipmittool sensor reading <id>` | 同上（简写） |
| `ipmitool sensor list` | 同 `sensor` |
| `ipmitool sensor thresh <id> lower/upper <value>` | 设置阈值 |
| `ipmitool sensor reading <id> | grep -i critical` | 检查是否触发关键阈值 |
| `ipmitool sensor type <type>` | 列出某类传感器（`temperature`, `voltage`, `fan`, …） |
| `ipmitool sdr elist all` | 以可读格式列出所有 SDR（含描述） |
| `ipmitool sdr get <id>` | 读取单条 SDR 条目 |
| `ipmitool sdr dump <file>` | 保存完整 SDR 记录到文件 |

---

## 4️⃣ 事件日志 (SEL – System Event Log)

| 命令 | 说明 |
|------|------|
| `ipmitool sel list` | 列出所有事件 |
| `ipmitool sel info` | SEL 概要信息 |
| `ipmitool sel get <id>` | 查看单条事件 |
| `ipmitool sel clear` | 清空 SEL |
| `ipmitool sel erase` | 彻底擦除（硬） |
| `ipmitool sel elist` | 友好（expanded）格式 |
| `ipmitool sel add "xxxx"` | 手动添加事件（调试） |
| `ipmitool sel time get` | 读取 BMC 当前时间 |
| `ipmitool sel time set "<YYYY-MM-DD HH:MM:SS>"` | 设置 BMC 时间（影响 SEL 时间戳） |

---

## 5️⃣ 电源控制 (Power Control)

| 命令 | 说明 |
|------|------|
| `ipmitool chassis power status` | 查看当前电源状态 |
| `ipmitool chassis power on` | 开机 |
| `ipmitool chassis power off` | 软关机 |
| `ipmitool chassis power cycle` | 软重启 |
| `ipmitool chassis power reset` | 硬重启（相当于 `mc reset cold`） |
| `ipmittool chassis bootdev <dev> [options]` | 设定一次性启动设备（`pxe|disk|cdrom|bios|floppy`) |
| `ipmitool chassis bootparam get <id>` | 获取 boot 参数（`id` 1‑5） |
| `ipmitool chassis bootparam set <id> <value>` | 设置 boot 参数 |
| `ipmitool chassis policy list` | 查看功率/风扇策略 |
| `ipmitool chassis policy set <policy>` | 设置策略 |

---

## 6️⃣ SOL / Serial‑Over‑Lan

| 命令 | 说明 |
|------|------|
| `ipmitool sol activate` | 启动 SOL 会话（进入交互式终端） |
| `ipmitool sol deactivate` | 关闭 SOL 会话 |
| `ipmitool sol info` | 查看 SOL 配置 |
| `ipmitool sol set <parameter> <value>` | 设置 SOL 参数（如 `payload`, `character`, `escape`) |
| `ipmitool sol stats` | 显示 SOL 统计信息 |
| `ipmitool sol break` | 发送中断（Ctrl‑]） |

---

## 7️⃣ 用户 / 权限 (User Management)

| 命令 | 说明 |
|------|------|
| `ipmitool user list <channel>` | 列出指定通道的全部用户 |
| `ipmitool user set name <id> <username>` | 为用户 ID 设定用户名 |
| `ipmittool user set password <id> <password>` | 为用户 ID 设定密码 |
| `ipmitool user set privilege <id> <priv>` | 设置权限 (`4=ADMIN`, `2=OPERATOR`, `1=USER`) |
| `ipmitool user enable <id>` | 启用用户 |
| `ipmitool user disable <id>` | 禁用用户 |
| `ipmitool user test <id>` | 测试用户登录 |
| `ipmitool user set password <id> <newpasswd>` (remote) | 远程修改密码 |
| `ipmitool channel setaccess <channel> <id> <priv>` | 调整通道访问级别 |
| `ipmitool channel info <channel>` | 查询通道信息（包括默认用户名/密码） |

---

## 8️⃣ FRU / 硬件信息 (Field Replaceable Unit)

| 命令 | 说明 |
|------|------|
| `ipmitool fru` | 列出全部 FRU 记录 |
| `ipmitool fru print <id>` | 打印单个 FRU（默认 0） |
| `ipmittool fru print -v <id>` | 详细模式 |
| `ipmitool fru dump <file>` | 将所有 FRU 数据保存到文件 |
| `ipmittool fru edit <id>` | 交互式编辑（仅限支持） |
| `ipmitool fru list` | 同 `fru` |
| `ipmitool fru read <file>` | 从文件读取 FRU（用于上传） |
| `ipmitool fru write <file>` | 将 FRU 写回 BMC |

---

## 8️⃣ LAN / 网络 (LAN Configuration)

| 命令 | 说明 |
|------|------|
| `ipmitool lan print <channel>` | 查看 LAN 配置（IP、子网、网关) |
| `ipmitool lan set <channel> ipsrc <source>` | IP 源 (`static|dhcp|bios`) |
| `ipmitool lan set <channel> ipaddr <addr>` | 设置 IP 地址 |
| `ipmittool lan set <channel> netmask <mask>` | 设置子网掩码 |
| `ipmittool lan set <channel> defgw ipaddr <gw>` | 设置默认网关 |
| `ipmittool lan set <channel> defgw macaddr <mac>` | 设置默认网关的 MAC |
| `ipmitool lan set <channel> password <pwd>` | 设置 LAN 通道的密码（不常用） |
| `ipmittool lan set <channel> vlan id <vlan>` | 设定 VLAN ID |
| `ipmittool lan set <channel> vlan priority <prio>` | 设定 VLAN 优先级 |
| `ipmittool lan set <channel> macaddr <mac>` | 手工指定 BMC MAC |
| `ipmittool lan set <channel> arp respond <on|off>` | 控制 ARP 响应 |
| `ipmittool lan set <channel> arp generate <on|off>` | 控制 ARP 生成 |
| `ipmittool lan set <channel> bmckey <key>` | 设置 RMCP+ BMC 密钥 |
| `ipmittool lan set <channel> authpw <pw>` | 设置 LAN 通道的认证密码 |
| `ipmittool lan set <channel> privilege <priv>` | 设置远程访问的默认特权 |
| `ipmitool lan stats get` | 查看 LAN 统计（TX/RX 包数） |

---

## 8️⃣ 机箱 (Chassis) 命令

| 命令 | 说明 |
|------|------|
| `ipmitool chassis status` | 机箱状态（电源、风扇、温度） |
| `ipmittool chassis identify [<seconds>]` | 指示灯闪烁（定位） |
| `ipmitool chassis reset <reset_type>` | 重置机箱（`cold`, `warm`, `diagnostic`) |
| `ipmitool chassis power <command>` | 与 **5️⃣ 电源控制** 相同，常用别名 |
| `ipmitool chassis bootdev <dev> [options]` | 同 **5️⃣** |
| `ipmitool chassis bootparam get <id>` | 同 **5️⃣** |
| `ipmittool chassis bootparam set <id> <value>` | 同 **5️⃣** |
| `ipmittool chassis policy list` | 同 **5️⃣** |
| `ipmittool chassis policy set <policy>` | 同 **5️⃣** |
| `ipmittool chassis control <command>` | 原始机箱控制（如 `reset`, `diagnostic`) |

---

## 9️⃣ 启动 (Boot) 命令

| 命令 | 说明 |
|------|------|
| `ipmitool chassis bootdev <dev> [options]` | 一次性启动设备 (`pxe|disk|cdrom|bios|floppy|setup`) |
| `ipmittool chassis bootparam get 5` | 查看当前一次性 boot 设备 |
| `ipmittool chassis bootparam set 5 <dev>` | 设定一次性 boot 设备 |
| `ipmitool chassis bootparam get 4` | 查看 boot options（`set-once`, `persistent`) |
| `ipmittool chassis bootparam set 4 <value>` | 设定持久 boot 选项 |
| `ipmittool chassis bootparam get 3` | 查看 boot flags (e.g., `BIOS`, `OS`) |
| `ipmitool chassis bootparam set 3 <value>` | 设定 boot flags |

---

## 🔟 原始 (Raw) 命令  

> **使用方法**：`ipmitool raw <netfn> <cmd> [data …]`  
> - `netfn` 与 `cmd` 为十六进制（不带 `0x` 前缀）  
> - 适用于所有未在上表覆盖的厂商扩展命令

| 示例 | 说明 |
|------|------|
| `ipmitool raw 0x06 0x01` | 读取 `Get Device ID`（等价于 `mc info`) |
| `ipmitool raw 0x00 0x02 0x01` | 重置 BMC（cold） |
| `ipmittool raw 0x04 0x2D 0xFF` | 向 `Chassis Power Control` 发送自定义控制码 |
| `ipmittool raw 0x2C 0x02 0xC0` | 读取特定传感器的原始值 |
| `ipmittool raw 0x30 0x0C 0x07` | 设定 2‑FA (如果平台支持) |
| `ipmitool raw 0x2C 0x0E 0x01` | 读取 `Boot Flags`（与 `chassis bootparam get` 等价） |
| `ipmitool raw 0x0C 0x02 0x00` | 读取系统事件日志的头信息 |
| `ipmittool raw 0x2E 0x10 0x01` | 设置自定义 PWM（风扇）阈值（平台特定） |

> **技巧**：  
> - 把 `raw` 命令保存到脚本后运行，可快速实现厂商特有功能  
> - 使用 `ipmitool -v`（verbose）可以看到完整的请求/响应帧，方便调试  

---

## 🛠️ 调试 / 其他

| 命令 | 说明 |
|------|------|
| `ipmitool -v <command>` | 详细输出（包括请求/响应） |
| `ipmitool -vvv <command>` | 更高调试级别（仅在故障排查时使用） |
| `ipmitool -vvv -I lanplus ...` | 查看 LAN+ 握手过程 |
| `ipmitool -d <debugfile>` | 把所有调试信息写入文件 |
| `ipmitool version` | 查看 ipmitool 本身的版本 |
| `ipmitool help` | 列出所有子命令（可配合 `grep` 过滤） |
| `ipmitool -c sensor list` | 以 CSV 形式输出传感器，易于导入 Excel/Sheets |
| `ipmittool -f <file> <command>` | 从文件读取参数（比如批量创建用户） |
| `ipmittool -I <iface> -R <retries> -T <timeout>` | 调整重试次数和超时时间（网络环境不佳时有用） |

---

## 🎯 常用一行脚本示例

| 目标 | 例子 |
|------|------|
| **查询电源状态** | `ipmitool -I lanplus -H $BMC -U $USER -P $PASS chassis power status` |
| **软重启服务器** | `ipmitool -I lanplus -H $BMC -U $USER -P $PASS chassis power cycle` |
| **列出所有传感器（CSV）** | `ipmitool -I lanplus -H $BMC -U $USER -P $PASS -c sensor > sensors.csv` |
| **一次性从 PXE 启动并重启** | `ipmitool -I lanplus -H $BMC -U $USER -P $PASS chassis bootdev pxe; ipmitool -I lanplus -H $BMC -U $USER -P $PASS chassis power reset` |
| **激活 SOL 会话（适配脚本）** | `ipmitool -I lanplus -H $BMC -U $USER -P $PASS sol activate` |
| **读取厂商自定义 FRU** | `ipmitool -I lanplus -H $BMC -U $USER -P $PASS raw 0x2E 0x10 0x00` |

---