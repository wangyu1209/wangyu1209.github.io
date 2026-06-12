---
title: frp.md
date: 2026-06-12T08:56:47.846Z
tags:
   - Linux
categories:
  - 常用服务安装
---
## 服务端frps安装

### 一键安装卸载脚本

安装脚本

```bash
wget https://raw.githubusercontent.com/stilleshan/frps/master/frps_linux_install.sh && chmod +x frps_linux_install.sh && ./frps_linux_install.sh
```

卸载脚本

```bash
wget https://raw.githubusercontent.com/stilleshan/frps/master/frps_linux_uninstall.sh && chmod +x frps_linux_uninstall.sh && ./frps_linux_uninstall.sh
```



如现有服务器上已存在 **frps** 服务,请先运行卸载脚本,在运行安装脚本.

安装完成后配置`frps.ini`并重启服务.

```bash
vi /usr/local/frp/frps.ini
# 修改 frps.ini 配置
sudo systemctl restart frps
# 重启 frps 服务即可生效
```

配置参考

```
[common]
bind_addr = 0.0.0.0
bind_port = 7000
bind_udp_port = 7001
kcp_bind_port = 7000
vhost_http_port = 80
vhost_https_port = 443
dashboard_addr = 0.0.0.0
dashboard_port = 7500
dashboard_user = admin
dashboard_pwd = admin         # 这里设置为管理面板配置的密码
log_file = ./frps.log
log_level = info
log_max_days = 3
disable_log_color = false
token = 12345678              # 这里设置为客户端配置的token
allow_ports = 2000-3000,3001,3003,4000-50000
max_pool_count = 5
max_ports_per_client = 0
subdomain_host = frps.com
tcp_mux = true
```



[GitHub官方README.md说明](https://github.com/fatedier/frp/blob/master/README_zh.md)
[GitHub官方frps.ini说明](https://github.com/fatedier/frp/blob/master/conf/frps_full.ini)

### 使用systemctl命令来控制frps

```bash
sudo systemctl start frps
# 启动frps
sudo systemctl enable frps
# 服务器开机自动启动frps
sudo systemctl status frps
# 查看状态
sudo systemctl restart frps
# 重启frps
sudo systemctl stop frps
# 停止frps
```

### 检查服务器端安装情况

输入`http://服务器IP:7500`来查看 frps 服务状态