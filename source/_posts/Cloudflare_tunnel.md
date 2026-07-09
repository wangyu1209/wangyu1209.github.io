---
title: Cloudflare_tunnel
copyrighr: true
date: 2026-07-09 15:05:07
tags:
  - Linux
  - Cloudflare
categories:
  - 常用服务安装
---

# CentOS 7 部署 Cloudflare Tunnel（cloudflared）

---

## 一、Cloudflare Tunnel 简介与工作原理

### 1.1 什么是 Cloudflare Tunnel

Cloudflare Tunnel 是 Cloudflare 提供的免费内网穿透方案，能够将内网服务安全暴露到公网，无需公网 IP、无需路由器端口映射、无需域名备案。相比传统方案如 frp、花生壳等，它具有以下核心优势：

- **完全免费**，无流量限制
- **无需公网 IP**，无需路由器端口映射
- 自动签发 **HTTPS 证书**，自带 **DDoS 防护**
- 流量经过 Cloudflare 全球 CDN 网络，真实 IP 不会暴露
- 延迟比传统方案低 40% 以上

### 1.2 工作原理

与传统内网穿透工具不同，Cloudflare Tunnel 采用**"由内向外"主动握手**的机制：

```
[内网服务器 (运行 cloudflared)] 
    ──(主动向外建立 HTTPS 连接)──► [Cloudflare 全球边缘节点]
                                            ▲
                                            │
                                    [互联网用户通过域名访问]
```

cloudflared 客户端在你的服务器上运行后，会主动向 Cloudflare 边缘节点发起多条安全的双向连接。当外网用户访问你的专属域名时，Cloudflare 将流量通过这条安全隧道转发给你。这种架构带来两个关键优势：一是无需配置路由器端口转发，二是天然防御了 DDoS 攻击。

---

## 二、前置准备

### 2.1 系统环境

- **操作系统**：CentOS 7（x86_64 架构）
- **网络**：服务器可正常访问互联网
- **本地服务**：至少有一个运行中的 Web 服务（如 Nginx、Apache、Node.js 等）

验证系统架构：

```bash
uname -m
# 输出 x86_64 表示 64 位系统，选择 amd64 版本
```

### 2.2 域名与 Cloudflare 账号

**你需要拥有一个域名，并将其 DNS 托管到 Cloudflare**。这是使用命名隧道（Named Tunnel）的前提条件。

#### 2.2.1 注册 Cloudflare 账号

访问 Cloudflare 控制台（https://dash.cloudflare.com/sign-up），使用邮箱注册账号并完成验证。

#### 2.2.2 购买域名（如已有域名可跳过）

推荐选择 `.com`、`.net`、`.org` 等主流后缀，小众后缀可能出现 DNS 生效缓慢的问题。域名可在阿里云、腾讯云、Namecheap 等平台购买。

#### 2.2.3 将域名托管到 Cloudflare

1. 登录 Cloudflare 控制台，点击 **"添加站点"（Add a Site）**，输入你的域名
2. 选择 **Free 免费套餐**，点击继续
3. Cloudflare 会分配两个 NS（域名服务器）地址，例如：

```
alice.ns.cloudflare.com
bob.ns.cloudflare.com
```

4. 前往你的域名注册商（阿里云、腾讯云等），将 DNS 服务器修改为 Cloudflare 提供的地址
5. 等待 DNS 生效，通常 **5 分钟至 24 小时**

验证 DNS 是否已切换成功：

```bash
dig NS yourdomain.com
```

当返回结果中包含 `cloudflare.com` 时，说明托管成功。

#### 2.2.4 验证内网服务可用性

确保你的本地服务正常运行，例如：

```bash
curl http://localhost:80
# 应能正常返回页面内容
```

---

## 三、安装 cloudflared

### 3.1 方法一：RPM 包直接安装（推荐）

这是 CentOS 7 下最简便的安装方式：

```bash
# 下载最新版 RPM 包
sudo rpm -ivh https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-x86_64.rpm
```

如果网络访问 GitHub 较慢，可以先下载再安装：

```bash
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-x86_64.rpm
sudo rpm -ivh cloudflared-linux-x86_64.rpm
```

### 3.2 方法二：直接下载二进制文件

适用于 RPM 安装失败或需要手动管理的情况：

```bash
# 下载二进制文件
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64

# 移动到系统路径并赋予执行权限
sudo mv cloudflared-linux-amd64 /usr/local/bin/cloudflared
sudo chmod +x /usr/local/bin/cloudflared
```

验证架构兼容性：

```bash
file /usr/local/bin/cloudflared
# 输出应包含 "ELF 64-bit LSB pie executable, x86-64"
```

### 3.3 验证安装

```bash
cloudflared --version
```

输出版本号即代表安装成功。

---

## 四、快速体验：临时隧道（Quick Tunnel）

如果你只是想快速测试或临时演示，可以使用临时隧道模式，**无需登录、无需域名、无需任何配置**：

```bash
cloudflared tunnel --url http://localhost:80
```

启动后终端会输出类似地址：

```
https://xxxx-yyyy-zzzz.trycloudflare.com
```

这个链接就是你的公网访问地址，任何人都可以通过它访问你本地的服务。

**常用端口示例**：

```bash
# 代理到 8080 端口
cloudflared tunnel --url http://localhost:8080

# 代理到 3000 端口（如 Node.js 应用）
cloudflared tunnel --url http://localhost:3000

# 代理到 HTTPS 服务
cloudflared tunnel --url https://localhost:8443 --no-tls-verify
```

> **注意**：临时模式的域名每次重启都会变化，且关闭终端后隧道自动断开。适用于开发调试，不适合生产环境。接下来介绍持久化部署方案。

---

## 五、持久化部署：命名隧道（Named Tunnel）

### 5.1 登录 Cloudflare 授权

执行授权命令：

```bash
cloudflared tunnel login
```

终端会输出一个授权链接，复制该链接到浏览器中打开。登录 Cloudflare 账号，选择你的域名，点击 **"Authorize"** 进行授权。

授权成功后，会在 `~/.cloudflared/` 目录下生成 `cert.pem` 凭证文件：

```bash
ls ~/.cloudflared/
# 输出: cert.pem
```

> **重要**：`cert.pem` 是账号授权凭证，不要删除或手动修改。

### 5.2 创建隧道

使用自定义名称创建隧道：

```bash
cloudflared tunnel create my-tunnel
```

执行成功后会输出：

```
Tunnel my-tunnel created with ID: 33a4639c-e92c-4bdb-8952-xxxxxxxxxxxx
```

同时在 `~/.cloudflared/` 目录下生成与 Tunnel ID 同名的 JSON 凭证文件：

```bash
ls ~/.cloudflared/
# 输出: cert.pem  33a4639c-e92c-4bdb-8952-xxxxxxxxxxxx.json
```

**务必记录 Tunnel ID，并妥善保管 JSON 凭证文件**。

> **注意**：不要手动重命名这个 JSON 文件，改名会导致隧道鉴权失败。

查看已创建的隧道列表，确认创建成功：

```bash
cloudflared tunnel list
```

### 5.3 编写配置文件

创建配置文件：

```bash
sudo mkdir -p /etc/cloudflared
sudo nano /etc/cloudflared/config.yml
```

写入以下内容，替换占位符为你的实际信息：

```yaml
# 替换为你的隧道 ID
tunnel: 33a4639c-e92c-4bdb-8952-xxxxxxxxxxxx

# 替换为凭证文件的完整路径
credentials-file: /root/.cloudflared/33a4639c-e92c-4bdb-8952-xxxxxxxxxxxx.json

# 流量转发规则
ingress:
  # 将域名映射到本地服务
  - hostname: app.yourdomain.com
    service: http://localhost:80

  # 必须保留的兜底规则，放在最后
  - service: http_status:404
```

**配置文件说明**：

| 字段 | 说明 |
|------|------|
| `tunnel` | 你的隧道 UUID |
| `credentials-file` | JSON 凭证文件的完整路径 |
| `ingress` | 入站规则列表 |
| `hostname` | 公网访问的域名 |
| `service` | 本地服务地址（支持 http://、https://、ssh://、tcp:// 等） |
| `http_status:404` | 兜底规则，必须放在最后 |

校验配置文件语法：

```bash
cloudflared tunnel ingress validate --config /etc/cloudflared/config.yml
```

输出 `Validation passed` 代表配置无误。

### 5.4 绑定域名到隧道

将域名与隧道关联，Cloudflare 会自动添加 CNAME 解析记录：

```bash
cloudflared tunnel route dns my-tunnel app.yourdomain.com
```

执行成功后会输出 `Added CNAME`，表示绑定成功。无需手动到 Cloudflare 控制台添加 DNS 记录。

> **如果遇到 code:1003 报错**（同名 A/CNAME 记录已存在），需要先到 Cloudflare 控制台的 DNS 记录列表中删除冲突的旧记录，然后重新执行绑定命令。

### 5.5 启动隧道

#### 5.5.1 临时前台启动（调试用）

```bash
cloudflared tunnel --config /etc/cloudflared/config.yml run my-tunnel
```

看到日志输出 `Connection registered successfully`，代表本地客户端成功连上 Cloudflare 边缘节点。

此时在浏览器访问 `https://app.yourdomain.com`，即可公网访问你的本地服务，自动带 HTTPS 安全锁。

#### 5.5.2 注册为 systemd 服务（生产环境推荐）

创建 systemd 服务文件：

```bash
sudo tee /etc/systemd/system/cloudflared.service > /dev/null << 'EOF'
[Unit]
Description=Cloudflare Tunnel Agent
After=network.target

[Service]
Type=simple
User=root
ExecStart=/usr/local/bin/cloudflared --config /etc/cloudflared/config.yml tunnel run
Restart=always
RestartSec=5
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF
```

> 如果你是通过 RPM 安装的，`cloudflared` 路径可能是 `/usr/bin/cloudflared`，可以用 `which cloudflared` 确认。

也可以使用 cloudflared 内置的服务安装命令：

```bash
sudo cloudflared service install --config /etc/cloudflared/config.yml
```

启用并启动服务：

```bash
sudo systemctl daemon-reload
sudo systemctl enable cloudflared
sudo systemctl start cloudflared
```

查看服务状态：

```bash
sudo systemctl status cloudflared
```

输出中应显示 `active (running)` 且无报错日志。

查看公网域名：

```bash
sudo journalctl -u cloudflared --no-pager | grep -oE 'https://[a-z0-9-]+\.[a-z]+\.[a-z]+' | head -1
```

---

## 六、单隧道发布多个服务

无需创建多条隧道，同一条隧道可以通过 ingress 规则按子域名分流，同时转发多个本地端口服务。

### 6.1 多子域名配置

修改 `config.yml`，追加多条 hostname 规则：

```yaml
tunnel: 33a4639c-e92c-4bdb-8952-xxxxxxxxxxxx
credentials-file: /root/.cloudflared/33a4639c-e92c-4bdb-8952-xxxxxxxxxxxx.json

ingress:
  # 服务1：主站
  - hostname: www.yourdomain.com
    service: http://localhost:80

  # 服务2：后台管理
  - hostname: admin.yourdomain.com
    service: http://localhost:8080

  # 服务3：API 接口
  - hostname: api.yourdomain.com
    service: http://localhost:3000

  # 兜底规则
  - service: http_status:404
```

每个新增子域名都需要执行 DNS 绑定：

```bash
cloudflared tunnel route dns my-tunnel www.yourdomain.com
cloudflared tunnel route dns my-tunnel admin.yourdomain.com
cloudflared tunnel route dns my-tunnel api.yourdomain.com
```

### 6.2 同域名路径分流

如果不想创建多个子域名，可以通过 URL 路径区分后端服务：

```yaml
tunnel: 33a4639c-e92c-4bdb-8952-xxxxxxxxxxxx
credentials-file: /root/.cloudflared/33a4639c-e92c-4bdb-8952-xxxxxxxxxxxx.json

ingress:
  - hostname: app.yourdomain.com
    path: /admin
    service: http://localhost:8080

  - hostname: app.yourdomain.com
    path: /api
    service: http://localhost:3000

  - hostname: app.yourdomain.com
    service: http://localhost:80

  - service: http_status:404
```

访问规则：
- `https://app.yourdomain.com` → 本机 80 端口
- `https://app.yourdomain.com/admin` → 本机 8080 端口
- `https://app.yourdomain.com/api` → 本机 3000 端口

### 6.3 使用 Nginx 反向代理优化

当需要暴露多个服务时，建议在本地用 Nginx 做反向代理，Cloudflare 隧道只配置一个入口点：

```nginx
server {
    listen 80;
    server_name app.yourdomain.com;

    location /admin {
        proxy_pass http://localhost:8080;
    }

    location /api {
        proxy_pass http://localhost:3000;
    }

    location / {
        proxy_pass http://localhost:80;
    }
}
```

然后 `config.yml` 只需配置一条规则：

```yaml
ingress:
  - hostname: app.yourdomain.com
    service: http://localhost:80
  - service: http_status:404
```

这样既减少了隧道配置复杂度，又方便统一管理证书。

---

## 七、SSH 隧道配置

Cloudflare Tunnel 不仅支持 HTTP/HTTPS，还支持 TCP 协议转发，包括 SSH。

### 7.1 配置 SSH 隧道

在 `config.yml` 中添加 SSH 规则：

```yaml
tunnel: 33a4639c-e92c-4bdb-8952-xxxxxxxxxxxx
credentials-file: /root/.cloudflared/33a4639c-e92c-4bdb-8952-xxxxxxxxxxxx.json

ingress:
  - hostname: ssh.yourdomain.com
    service: ssh://localhost:22

  - hostname: app.yourdomain.com
    service: http://localhost:80

  - service: http_status:404
```

执行 DNS 绑定：

```bash
cloudflared tunnel route dns my-tunnel ssh.yourdomain.com
```

### 7.2 外网客户端配置

在外网电脑上也需安装 cloudflared，然后配置 SSH。

编辑 `~/.ssh/config` 文件，添加以下内容：

```
Host ssh.yourdomain.com
    ProxyCommand cloudflared access ssh --hostname %h
```

之后即可直接 SSH 登录：

```bash
ssh username@ssh.yourdomain.com
```

首次连接会弹出浏览器要求登录 Cloudflare 进行身份认证。

---

## 八、网络协议问题排查

### 8.1 QUIC/UDP 被拦截

国内运营商和企业网络大概率会拦截 UDP 7844 端口，导致默认的 QUIC 协议反复重连报错。日志会持续打印 `context canceled` 错误。

**解决方案**：强制切换为 HTTP/2 协议启动。

修改 systemd 服务文件中的启动命令：

```bash
sudo nano /etc/systemd/system/cloudflared.service
```

将 `ExecStart` 行修改为：

```ini
ExecStart=/usr/local/bin/cloudflared --protocol http2 --config /etc/cloudflared/config.yml tunnel run
```

或者在 `config.yml` 中添加协议配置：

```yaml
protocol: http2
```

重载服务：

```bash
sudo systemctl daemon-reload
sudo systemctl restart cloudflared
```

### 8.2 常见错误排查

| 错误现象 | 核心原因 | 解决方法 |
|----------|----------|----------|
| `502 Bad Gateway` | 本地服务未启动或端口错误 | 检查本地服务是否正常运行，执行 `curl http://localhost:端口` 测试 |
| `ERR_CONNECTION_REFUSED` | 隧道已连通但本地服务未启动 | 确认本地服务监听端口正确，检查防火墙是否放行 |
| `ERR_TUNNEL_DNS_ERROR` | 域名解析问题 | 检查 NS 是否已生效，尝试 `nslookup yourdomain.com` |
| `ERR_TIMED_OUT` | 网络连接问题 | 尝试使用 `--protocol http2` 参数启动 |
| `Failed to get tunnel` | 凭证文件路径错误或文件名被修改 | 确保 JSON 文件未被重命名，路径配置正确 |
| `code:1003` | DNS 记录冲突 | 到 Cloudflare 控制台删除同名旧记录后重新绑定 |
| 连接器状态非 HEALTHY | Token/凭证失效或网络不通 | 重新创建隧道，检查服务器网络连通性 |

### 8.3 查看日志

```bash
# 实时查看 cloudflared 日志
sudo journalctl -u cloudflared -f

# 查看最近 100 行日志
sudo journalctl -u cloudflared -n 100

# 查看服务状态
sudo systemctl status cloudflared
```

### 8.4 保持稳定运行

设置定时检测进程，如果隧道断开则自动重启：

```bash
crontab -e
```

添加以下内容（每 5 分钟检测一次）：

```bash
*/5 * * * * pgrep -x cloudflared || systemctl restart cloudflared
```

---

## 九、完整操作流程总结

以下是 CentOS 7 下从零开始的完整命令汇总：

```bash
# ===== 1. 安装 cloudflared =====
sudo rpm -ivh https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-x86_64.rpm
cloudflared --version

# ===== 2. 登录授权 =====
cloudflared tunnel login
# 按提示在浏览器中完成授权

# ===== 3. 创建隧道 =====
cloudflared tunnel create my-tunnel
# 记录输出的 Tunnel ID

# ===== 4. 创建配置文件 =====
sudo mkdir -p /etc/cloudflared
sudo tee /etc/cloudflared/config.yml > /dev/null << 'EOF'
tunnel: <你的Tunnel-ID>
credentials-file: /root/.cloudflared/<你的Tunnel-ID>.json
ingress:
  - hostname: app.yourdomain.com
    service: http://localhost:80
  - service: http_status:404
EOF

# ===== 5. 绑定域名 =====
cloudflared tunnel route dns my-tunnel app.yourdomain.com

# ===== 6. 校验配置 =====
cloudflared tunnel ingress validate --config /etc/cloudflared/config.yml

# ===== 7. 安装为系统服务 =====
sudo cloudflared service install --config /etc/cloudflared/config.yml
sudo systemctl daemon-reload
sudo systemctl enable cloudflared
sudo systemctl start cloudflared

# ===== 8. 验证运行 =====
sudo systemctl status cloudflared
# 在浏览器访问 https://app.yourdomain.com 测试
```

---

## 十、Cloudflare Tunnel 与其他方案对比

| 特性 | Cloudflare Tunnel | ngrok | frp/花生壳 |
|------|-------------------|-------|------------|
| 免费 | 完全免费 | 免费版有限制 | 需自建或付费 |
| 警告页 | 无 | 免费版有 | 无 |
| 需要注册 | 不需要临时模式 | 需要 | 需要 |
| 固定域名 | 需 Cloudflare 账号 | 需付费 | 需自建 |
| 速度 | 较快（Cloudflare CDN） | 一般 | 取决于服务器 |
| 国内可用性 | 良好 | 不稳定 | 取决于配置 |
| 安全性 | 流量加密 + DDoS 防护 | 基础加密 | 需自行配置 |

---

## 十一、适用场景与局限性

### 适用场景

- 本地开发项目的公网演示和调试
- 微信小程序、第三方支付回调等需要公网回调地址的场景
- 内网 NAS、个人博客等小站点的长期公网部署
- 客户演示、远程调试等临时需求

### 局限性

- 临时隧道域名每次重启会变化（命名隧道可解决）
- 主要针对 HTTP/HTTPS 服务，TCP/SSH 需要额外配置
- 免费版 CDN 节点访问速度受运营商线路影响
- 国内网络可能需要使用 HTTP/2 协议替代默认的 QUIC

---