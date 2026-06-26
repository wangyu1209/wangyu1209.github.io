---
title: Nginx_Archive_passwd
copyrighr: true
date: 2026-06-26 17:13:22
tags:
  - Linux
  - Nginx
categories:
  - 常用服务安装
---

# CentOS 7：Nginx 下载站（带登录功能）

## 目录结构

```
/var/www/
├── download-site/
│   ├── index.html          ← 主页面（需要登录）
│   └── login.html          ← 登录页面（渐变色背景）
└── files/                  ← 你要分享的文件放这里
    ├── Documents/
    ├── Software/
    ├── Images/
    └── ...
```

---

## 第一步：安装 Nginx（官方最新版）

CentOS 7 默认仓库的 Nginx 版本较老，建议使用官方仓库获取支持 `autoindex_format json` 的新版本：

```bash
# 创建 Nginx 官方仓库
sudo tee /etc/yum.repos.d/nginx.repo > /dev/null << 'EOF'
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/7/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
EOF

# 安装
sudo yum install -y nginx
nginx -v
```

---

## 第二步：创建目录

```bash
sudo mkdir -p /var/www/download-site
sudo mkdir -p /var/www/files
sudo chown -R nginx:nginx /var/www
```

把你想要分享的文件放入 `/var/www/files/` 目录下。

---

## 第三步：上传文件

将以下文件上传到服务器：

1. `login.html` → `/var/www/download-site/login.html`
2. `index.html` → `/var/www/download-site/index.html`

```bash
# 设置权限
sudo chown nginx:nginx /var/www/download-site/login.html
sudo chown nginx:nginx /var/www/download-site/index.html
```

---

## 第四步：Nginx 配置

```bash
sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
sudo tee /etc/nginx/conf.d/download.conf > /dev/null << 'EOF'
server {
    listen 8080;
    server_name _;
    charset utf-8;

    # 安全头
    add_header X-Content-Type-Options nosniff;
    add_header X-Frame-Options DENY;

    # 大文件上传支持 (可选)
    client_max_body_size 1024m;

    # ── 登录页面 ──
    location = /login {
        root /var/www/download-site;
        index login.html;
        try_files /login.html =404;
    }

    location = /login.html {
        root /var/www/download-site;
    }

    # ── 前端页面 ──
    location = / {
        root /var/www/download-site;
        index index.html;
        try_files /index.html =404;
    }

    location = /index.html {
        root /var/www/download-site;
    }

    # ── 目录列表 API (JSON) ──
    location /api/ {
        alias /var/www/files/;
        autoindex on;
        autoindex_format json;
        autoindex_localtime on;
        add_header Cache-Control "no-cache, no-store";
        add_header Access-Control-Allow-Origin *;
    }

    # ── 文件下载 ──
    location /dl/ {
        alias /var/www/files/;
        autoindex off;
        add_header Content-Disposition 'attachment';
    }

    # ── 静态资源 ──
    location ~* \.(css|js|png|jpg|jpeg|gif|ico|svg)$ {
        root /var/www/download-site;
        expires 7d;
        add_header Cache-Control "public, immutable";
    }
}
EOF
```

验证配置并启动：

```bash
sudo nginx -t
sudo systemctl start nginx
sudo systemctl enable nginx
```

---

## 第五步：登录页面

将下面的完整 HTML 写入 `/var/www/download-site/login.html`：

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Archive — 登录</title>
  <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>🔐</text></svg>">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
  <style>
    *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }

    :root {
      --gradient-1: #059669;
      --gradient-2: #10b981;
      --gradient-3: #34d399;
      --gradient-4: #6ee7b7;
      --surface: rgba(255, 255, 255, 0.95);
      --surface-hover: rgba(255, 255, 255, 1);
      --text: #111827;
      --text-2: #4b5563;
      --text-3: #9ca3af;
      --border: rgba(255, 255, 255, 0.2);
      --shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
      --radius: 20px;
      --sans: 'DM Sans', sans-serif;
      --serif: 'Outfit', sans-serif;
    }

    html, body {
      height: 100%;
      font-family: var(--sans);
      -webkit-font-smoothing: antialiased;
    }

    body {
      display: flex;
      align-items: center;
      justify-content: center;
      background: linear-gradient(135deg, #064e3b 0%, #065f46 25%, #047857 50%, #059669 75%, #10b981 100%);
      background-size: 400% 400%;
      animation: gradientShift 15s ease infinite;
      position: relative;
      overflow: hidden;
    }

    @keyframes gradientShift {
      0% { background-position: 0% 50%; }
      50% { background-position: 100% 50%; }
      100% { background-position: 0% 50%; }
    }

    /* 动态背景元素 */
    .bg-element {
      position: absolute;
      border-radius: 50%;
      filter: blur(80px);
      opacity: 0.4;
      animation: float 20s ease-in-out infinite;
    }

    .bg-element:nth-child(1) {
      width: 600px;
      height: 600px;
      background: radial-gradient(circle, rgba(52, 211, 153, 0.5) 0%, transparent 70%);
      top: -200px;
      left: -200px;
      animation-delay: 0s;
    }

    .bg-element:nth-child(2) {
      width: 500px;
      height: 500px;
      background: radial-gradient(circle, rgba(110, 231, 183, 0.4) 0%, transparent 70%);
      bottom: -150px;
      right: -150px;
      animation-delay: -5s;
    }

    .bg-element:nth-child(3) {
      width: 400px;
      height: 400px;
      background: radial-gradient(circle, rgba(167, 243, 208, 0.3) 0%, transparent 70%);
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      animation-delay: -10s;
    }

    @keyframes float {
      0%, 100% { transform: translateY(0) rotate(0deg); }
      33% { transform: translateY(-30px) rotate(5deg); }
      66% { transform: translateY(20px) rotate(-5deg); }
    }

    /* 登录容器 */
    .login-container {
      position: relative;
      z-index: 10;
      width: 100%;
      max-width: 420px;
      padding: 20px;
    }

    .login-card {
      background: var(--surface);
      backdrop-filter: blur(20px);
      border-radius: var(--radius);
      padding: 48px 40px;
      box-shadow: var(--shadow), 0 0 0 1px rgba(255, 255, 255, 0.1);
      animation: cardAppear 0.6s ease-out;
    }

    @keyframes cardAppear {
      from {
        opacity: 0;
        transform: translateY(30px) scale(0.95);
      }
      to {
        opacity: 1;
        transform: translateY(0) scale(1);
      }
    }

    /* Logo */
    .logo {
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 12px;
      margin-bottom: 32px;
    }

    .logo-icon {
      width: 56px;
      height: 56px;
      display: flex;
      align-items: center;
      justify-content: center;
      background: linear-gradient(135deg, var(--gradient-1), var(--gradient-3));
      border-radius: 16px;
      color: white;
      box-shadow: 0 8px 24px rgba(5, 150, 105, 0.3);
      transition: transform 0.3s ease, box-shadow 0.3s ease;
    }

    .logo-icon:hover {
      transform: scale(1.05) rotate(5deg);
      box-shadow: 0 12px 32px rgba(5, 150, 105, 0.4);
    }

    .logo-icon svg {
      width: 28px;
      height: 28px;
    }

    .logo-text {
      font-family: var(--serif);
      font-size: 1.8rem;
      font-weight: 600;
      color: var(--text);
      letter-spacing: -0.5px;
    }

    /* 表单 */
    .form-group {
      margin-bottom: 24px;
    }

    .form-label {
      display: block;
      font-size: 0.85rem;
      font-weight: 500;
      color: var(--text-2);
      margin-bottom: 8px;
    }

    .form-input {
      width: 100%;
      padding: 14px 16px;
      background: #f9fafb;
      border: 2px solid #e5e7eb;
      border-radius: 12px;
      font-size: 1rem;
      color: var(--text);
      transition: all 0.2s ease;
      outline: none;
    }

    .form-input::placeholder {
      color: var(--text-3);
    }

    .form-input:focus {
      border-color: var(--gradient-2);
      background: white;
      box-shadow: 0 0 0 4px rgba(16, 185, 129, 0.1);
    }

    .form-input:hover:not(:focus) {
      border-color: #d1d5db;
    }

    /* 密码输入框 */
    .password-wrapper {
      position: relative;
    }

    .password-toggle {
      position: absolute;
      right: 12px;
      top: 50%;
      transform: translateY(-50%);
      background: none;
      border: none;
      color: var(--text-3);
      cursor: pointer;
      padding: 8px;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: color 0.2s ease;
    }

    .password-toggle:hover {
      color: var(--gradient-1);
    }

    .password-toggle svg {
      width: 20px;
      height: 20px;
    }

    /* 记住我 */
    .remember-row {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 28px;
    }

    .checkbox-wrapper {
      display: flex;
      align-items: center;
      gap: 8px;
      cursor: pointer;
    }

    .checkbox-wrapper input[type="checkbox"] {
      width: 18px;
      height: 18px;
      accent-color: var(--gradient-1);
      cursor: pointer;
    }

    .checkbox-label {
      font-size: 0.85rem;
      color: var(--text-2);
      user-select: none;
    }

    .forgot-link {
      font-size: 0.85rem;
      color: var(--gradient-1);
      text-decoration: none;
      font-weight: 500;
      transition: color 0.2s ease;
    }

    .forgot-link:hover {
      color: var(--gradient-2);
      text-decoration: underline;
    }

    /* 提交按钮 */
    .submit-btn {
      width: 100%;
      padding: 14px 24px;
      background: linear-gradient(135deg, var(--gradient-1), var(--gradient-2));
      color: white;
      border: none;
      border-radius: 12px;
      font-size: 1rem;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
      position: relative;
      overflow: hidden;
    }

    .submit-btn::before {
      content: '';
      position: absolute;
      top: 0;
      left: -100%;
      width: 100%;
      height: 100%;
      background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
      transition: left 0.5s ease;
    }

    .submit-btn:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 24px rgba(5, 150, 105, 0.4);
    }

    .submit-btn:hover::before {
      left: 100%;
    }

    .submit-btn:active {
      transform: translateY(0);
    }

    .submit-btn:disabled {
      opacity: 0.7;
      cursor: not-allowed;
      transform: none;
    }

    /* 错误消息 */
    .error-message {
      display: none;
      padding: 12px 16px;
      background: #fef2f2;
      border: 1px solid #fecaca;
      border-radius: 10px;
      color: #dc2626;
      font-size: 0.85rem;
      margin-bottom: 20px;
      animation: shake 0.5s ease;
    }

    .error-message.show {
      display: flex;
      align-items: center;
      gap: 8px;
    }

    @keyframes shake {
      0%, 100% { transform: translateX(0); }
      20%, 60% { transform: translateX(-5px); }
      40%, 80% { transform: translateX(5px); }
    }

    /* 页脚 */
    .login-footer {
      text-align: center;
      margin-top: 24px;
      font-size: 0.8rem;
      color: var(--text-3);
    }

    /* 加载动画 */
    .spinner {
      display: none;
      width: 20px;
      height: 20px;
      border: 2px solid rgba(255, 255, 255, 0.3);
      border-top-color: white;
      border-radius: 50%;
      animation: spin 0.8s linear infinite;
      margin: 0 auto;
    }

    .submit-btn.loading .btn-text {
      display: none;
    }

    .submit-btn.loading .spinner {
      display: block;
    }

    @keyframes spin {
      to { transform: rotate(360deg); }
    }

    /* 响应式 */
    @media (max-width: 480px) {
      .login-card {
        padding: 36px 28px;
      }

      .logo-text {
        font-size: 1.5rem;
      }

      .logo-icon {
        width: 48px;
        height: 48px;
      }

      .logo-icon svg {
        width: 24px;
        height: 24px;
      }
    }
  </style>
</head>
<body>
  <!-- 动态背景 -->
  <div class="bg-element"></div>
  <div class="bg-element"></div>
  <div class="bg-element"></div>

  <div class="login-container">
    <div class="login-card">
      <!-- Logo -->
      <div class="logo">
        <div class="logo-icon">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/>
            <polyline points="3.27 6.96 12 12.01 20.73 6.96"/>
            <line x1="12" y1="22.08" x2="12" y2="12"/>
          </svg>
        </div>
        <span class="logo-text">Archive</span>
      </div>

      <!-- 错误消息 -->
      <div class="error-message" id="error-message">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <circle cx="12" cy="12" r="10"/>
          <line x1="12" y1="8" x2="12" y2="12"/>
          <line x1="12" y1="16" x2="12.01" y2="16"/>
        </svg>
        <span id="error-text">用户名或密码错误</span>
      </div>

      <!-- 登录表单 -->
      <form id="login-form">
        <div class="form-group">
          <label class="form-label" for="username">用户名</label>
          <input type="text" class="form-input" id="username" name="username" placeholder="请输入用户名" autocomplete="username" required>
        </div>

        <div class="form-group">
          <label class="form-label" for="password">密码</label>
          <div class="password-wrapper">
            <input type="password" class="form-input" id="password" name="password" placeholder="请输入密码" autocomplete="current-password" required>
            <button type="button" class="password-toggle" id="password-toggle" tabindex="-1">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                <circle cx="12" cy="12" r="3"/>
              </svg>
            </button>
          </div>
        </div>

        <div class="remember-row">
          <label class="checkbox-wrapper">
            <input type="checkbox" id="remember" name="remember">
            <span class="checkbox-label">记住我</span>
          </label>
          <a href="#" class="forgot-link" onclick="alert('请联系管理员重置密码'); return false;">忘记密码?</a>
        </div>

        <button type="submit" class="submit-btn" id="submit-btn">
          <span class="btn-text">登 录</span>
          <div class="spinner"></div>
        </button>
      </form>

      <div class="login-footer">
        <p>Secure access to Archive file service</p>
      </div>
    </div>
  </div>

  <script>
    (() => {
      'use strict';

      // 默认用户（生产环境请改为后端验证）
      const VALID_USERS = {
        'admin': 'admin123',
        'user': 'user123'
      };

      const TOKEN_KEY = 'archive_auth_token';
      const USER_KEY = 'archive_username';

      // DOM 元素
      const form = document.getElementById('login-form');
      const usernameInput = document.getElementById('username');
      const passwordInput = document.getElementById('password');
      const passwordToggle = document.getElementById('password-toggle');
      const submitBtn = document.getElementById('submit-btn');
      const errorMessage = document.getElementById('error-message');
      const errorText = document.getElementById('error-text');
      const rememberCheckbox = document.getElementById('remember');

      // 检查是否已登录
      function checkAuth() {
        const token = localStorage.getItem(TOKEN_KEY);
        const username = localStorage.getItem(USER_KEY);
        if (token && username) {
          const validToken = btoa(username + ':' + Date.now());
          if (token === validToken.split(':').slice(0, -1).join(':') || 
              localStorage.getItem('archive_remember') === 'true') {
            window.location.href = '/';
            return true;
          }
        }
        return false;
      }

      // 生成 Token
      function generateToken(username) {
        return btoa(username + ':' + Date.now());
      }

      // 显示错误
      function showError(message) {
        errorText.textContent = message;
        errorMessage.classList.add('show');
        form.style.animation = 'none';
        form.offsetHeight;
        form.style.animation = 'shake 0.5s ease';
      }

      // 隐藏错误
      function hideError() {
        errorMessage.classList.remove('show');
      }

      // 切换密码可见性
      passwordToggle.addEventListener('click', () => {
        const type = passwordInput.type === 'password' ? 'text' : 'password';
        passwordInput.type = type;
        
        if (type === 'text') {
          passwordToggle.innerHTML = `
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/>
              <line x1="1" y1="1" x2="23" y2="23"/>
            </svg>
          `;
        } else {
          passwordToggle.innerHTML = `
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
              <circle cx="12" cy="12" r="3"/>
            </svg>
          `;
        }
      });

      // 表单提交
      form.addEventListener('submit', async (e) => {
        e.preventDefault();
        hideError();

        const username = usernameInput.value.trim();
        const password = passwordInput.value;
        const remember = rememberCheckbox.checked;

        if (!username || !password) {
          showError('请输入用户名和密码');
          return;
        }

        submitBtn.classList.add('loading');
        submitBtn.disabled = true;

        await new Promise(resolve => setTimeout(resolve, 800));

        if (VALID_USERS[username] && VALID_USERS[username] === password) {
          const token = generateToken(username);
          localStorage.setItem(TOKEN_KEY, token);
          localStorage.setItem(USER_KEY, username);
          
          if (remember) {
            localStorage.setItem('archive_remember', 'true');
          } else {
            localStorage.removeItem('archive_remember');
          }

          window.location.href = '/';
        } else {
          showError('用户名或密码错误');
          submitBtn.classList.remove('loading');
          submitBtn.disabled = false;
          passwordInput.value = '';
          passwordInput.focus();
        }
      });

      // 输入时清除错误
      usernameInput.addEventListener('input', hideError);
      passwordInput.addEventListener('input', hideError);

      // 键盘快捷键
      document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') {
          passwordInput.value = '';
          usernameInput.focus();
        }
      });

      // 检查登录状态
      checkAuth();
    })();
  </script>
</body>
</html>
```

---

## 第六步：主页面（带登录验证）

将下面的完整 HTML 写入 `/var/www/download-site/index.html`：

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Archive — 文件服务</title>
  <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>🌿</text></svg>">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&family=DM+Sans:wght@300;400;500&family=JetBrains+Mono:wght@300;400&display=swap" rel="stylesheet">
  <style>
    *, *::before, *::after { margin:0; padding:0; box-sizing:border-box; }

    :root {
      --bg:          #f2f7f5;
      --bg-alt:      #e9f0ec;
      --surface:     #ffffff;
      --surface-2:   #f8fbfa;
      --border:      #d8e4de;
      --border-light:#e4ede8;
      --accent:      #059669;
      --accent-h:    #047857;
      --accent-bg:   #ecfdf5;
      --accent-bg-2: #d1fae5;
      --folder:      #d97706;
      --folder-bg:   #fffbeb;
      --text:        #111827;
      --text-2:      #4b5563;
      --text-3:      #9ca3af;
      --white:       #ffffff;
      --radius:      14px;
      --radius-sm:   10px;
      --radius-xs:   7px;
      --shadow:      0 1px 3px rgba(0,0,0,0.05), 0 1px 2px rgba(0,0,0,0.03);
      --shadow-md:   0 4px 16px rgba(0,0,0,0.06), 0 1px 3px rgba(0,0,0,0.04);
      --shadow-lg:   0 8px 30px rgba(0,0,0,0.08);
      --sans:        'DM Sans', sans-serif;
      --serif:       'Outfit', sans-serif;
      --mono:        'JetBrains Mono', monospace;
      --transition:  0.2s cubic-bezier(0.4, 0, 0.2, 1);
    }

    html { font-size: 15px; }

    body {
      font-family: var(--sans);
      background: var(--bg);
      background-image:
        radial-gradient(ellipse at 25% -10%, rgba(16,185,129,0.07) 0%, transparent 50%),
        radial-gradient(ellipse at 85% 110%, rgba(59,130,246,0.05) 0%, transparent 45%);
      color: var(--text);
      min-height: 100vh;
      -webkit-font-smoothing: antialiased;
    }

    a { color: var(--accent); text-decoration: none; }
    a:hover { text-decoration: underline; }
    ::selection { background: var(--accent-bg-2); color: var(--accent-h); }
    ::-webkit-scrollbar { width: 5px; }
    ::-webkit-scrollbar-track { background: transparent; }
    ::-webkit-scrollbar-thumb { background: var(--border); border-radius: 3px; }

    .app {
      max-width: 1100px;
      margin: 0 auto;
      padding: 0 28px;
      display: flex;
      flex-direction: column;
      min-height: 100vh;
    }

    /* ─── Header ─── */
    .header {
      display: flex;
      align-items: center;
      gap: 18px;
      padding: 24px 0 20px;
    }

    .nav-group {
      display: flex;
      align-items: center;
      gap: 6px;
    }

    .logo-back {
      display: none;
      width: 34px; height: 34px;
      align-items: center; justify-content: center;
      background: var(--surface);
      border: 1.5px solid var(--border);
      border-radius: var(--radius-xs);
      color: var(--text-3);
      cursor: pointer;
      transition: all var(--transition);
      box-shadow: var(--shadow);
    }
    .logo-back svg { width: 16px; height: 16px; }
    .logo-back:hover {
      border-color: var(--accent);
      color: var(--accent);
      background: var(--accent-bg);
    }
    .nav-group.has-parent .logo-back {
      display: flex;
    }

    .logo {
      display: flex;
      align-items: center;
      gap: 10px;
      font-family: var(--serif);
      font-size: 1.55rem;
      font-weight: 600;
      color: var(--text);
      white-space: nowrap;
      user-select: none;
      text-decoration: none;
    }
    .logo:hover { text-decoration: none; color: var(--text); }

    .logo-icon {
      width: 34px; height: 34px;
      display: flex; align-items: center; justify-content: center;
      background: var(--accent-bg);
      border-radius: var(--radius-xs);
      color: var(--accent);
      transition: all var(--transition);
    }
    .logo-icon svg { width: 20px; height: 20px; }
    .logo:hover .logo-icon { background: var(--accent-bg-2); transform: scale(1.05); }

    .search-wrap {
      flex: 1;
      position: relative;
      max-width: 380px;
      margin-left: auto;
    }
    .search-wrap svg {
      position: absolute;
      left: 14px; top: 50%; transform: translateY(-50%);
      width: 16px; height: 16px;
      color: var(--text-3);
      pointer-events: none;
    }
    .search {
      width: 100%;
      padding: 10px 14px 10px 40px;
      background: var(--surface);
      border: 1.5px solid var(--border);
      border-radius: var(--radius-sm);
      color: var(--text);
      font: 400 0.87rem var(--sans);
      outline: none;
      transition: all var(--transition);
      box-shadow: var(--shadow);
    }
    .search::placeholder { color: var(--text-3); }
    .search:focus {
      border-color: var(--accent);
      box-shadow: 0 0 0 3px rgba(5,150,105,0.1), var(--shadow);
    }

    .header-actions {
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .view-btns { display: flex; gap: 4px; }
    .view-btn {
      width: 38px; height: 38px;
      display: flex; align-items: center; justify-content: center;
      background: var(--surface);
      border: 1.5px solid var(--border);
      border-radius: var(--radius-xs);
      cursor: pointer;
      color: var(--text-3);
      transition: all var(--transition);
      box-shadow: var(--shadow);
    }
    .view-btn:hover { color: var(--text-2); }
    .view-btn.active {
      color: var(--accent);
      border-color: var(--accent);
      background: var(--accent-bg);
    }
    .view-btn svg { width: 18px; height: 18px; }

    /* 用户菜单 */
    .user-menu {
      position: relative;
    }

    .user-btn {
      width: 38px; height: 38px;
      display: flex; align-items: center; justify-content: center;
      background: var(--surface);
      border: 1.5px solid var(--border);
      border-radius: var(--radius-xs);
      cursor: pointer;
      color: var(--text-2);
      transition: all var(--transition);
      box-shadow: var(--shadow);
    }

    .user-btn:hover {
      border-color: var(--accent);
      color: var(--accent);
      background: var(--accent-bg);
    }

    .user-btn svg { width: 18px; height: 18px; }

    .user-dropdown {
      position: absolute;
      top: calc(100% + 8px);
      right: 0;
      background: var(--surface);
      border: 1.5px solid var(--border);
      border-radius: var(--radius-sm);
      box-shadow: var(--shadow-lg);
      min-width: 160px;
      opacity: 0;
      visibility: hidden;
      transform: translateY(-8px);
      transition: all 0.2s ease;
      z-index: 100;
    }

    .user-dropdown.show {
      opacity: 1;
      visibility: visible;
      transform: translateY(0);
    }

    .user-dropdown-item {
      display: flex;
      align-items: center;
      gap: 10px;
      padding: 10px 14px;
      font-size: 0.85rem;
      color: var(--text-2);
      cursor: pointer;
      transition: all 0.15s ease;
    }

    .user-dropdown-item:first-child {
      border-radius: var(--radius-sm) var(--radius-sm) 0 0;
    }

    .user-dropdown-item:last-child {
      border-radius: 0 0 var(--radius-sm) var(--radius-sm);
    }

    .user-dropdown-item:hover {
      background: var(--accent-bg);
      color: var(--accent);
    }

    .user-dropdown-item svg {
      width: 16px;
      height: 16px;
    }

    .user-dropdown-divider {
      height: 1px;
      background: var(--border-light);
      margin: 4px 0;
    }

    .user-dropdown-item.danger {
      color: #dc2626;
    }

    .user-dropdown-item.danger:hover {
      background: #fef2f2;
      color: #dc2626;
    }

    /* ─── Breadcrumb ─── */
    .breadcrumb {
      display: flex;
      align-items: center;
      gap: 0;
      padding: 14px 0 12px;
      font-size: .82rem;
      flex-wrap: wrap;
    }
    .crumb {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      padding: 4px 10px;
      border-radius: 20px;
      color: var(--text-3);
      transition: all var(--transition);
    }
    .crumb:hover { background: var(--accent-bg); color: var(--accent); text-decoration: none; }
    .crumb.current { background: var(--accent-bg); color: var(--accent); font-weight: 500; }
    .crumb-sep { color: var(--text-3); font-size: .7rem; opacity: .4; margin: 0 2px; }

    /* ─── File Card ─── */
    .file-card {
      background: var(--surface);
      border: 1.5px solid var(--border);
      border-radius: var(--radius);
      box-shadow: var(--shadow-md);
      overflow: hidden;
      flex: 1;
      display: flex;
      flex-direction: column;
    }

    .list-header {
      display: grid;
      grid-template-columns: 1fr 110px 170px 44px;
      gap: 12px;
      padding: 10px 20px;
      font-size: .72rem;
      font-weight: 500;
      letter-spacing: .05em;
      text-transform: uppercase;
      color: var(--text-3);
      background: var(--surface-2);
      border-bottom: 1.5px solid var(--border-light);
      cursor: pointer;
      user-select: none;
    }
    .list-header span:hover { color: var(--text-2); }
    .list-header .sort-icon { font-size: .55rem; margin-left: 3px; opacity: .5; }
    .grid-header { display: none; }

    .file-list { flex: 1; display: flex; flex-direction: column; }

    .file-row {
      display: grid;
      grid-template-columns: 1fr 110px 170px 44px;
      gap: 12px;
      padding: 10px 20px;
      align-items: center;
      border-bottom: 1px solid var(--border-light);
      transition: background var(--transition);
      cursor: pointer;
      opacity: 0;
      animation: fadeUp .35s ease forwards;
    }
    .file-row:last-child { border-bottom: none; }
    .file-row:hover { background: var(--accent-bg); }

    .file-name {
      display: flex;
      align-items: center;
      gap: 12px;
      min-width: 0;
      color: var(--text);
    }
    .file-name .name-text {
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }
    .file-icon {
      width: 36px; height: 36px; flex-shrink: 0;
      display: flex; align-items: center; justify-content: center;
      border-radius: var(--radius-xs);
      transition: transform var(--transition);
    }
    .file-row:hover .file-icon { transform: scale(1.08); }
    .file-icon svg { width: 18px; height: 18px; }
    .file-size { font: 300 .8rem var(--mono); color: var(--text-2); }
    .file-date { font: 300 .8rem var(--mono); color: var(--text-3); }
    .file-actions { display: flex; justify-content: center; }

    .btn-copy {
      width: 32px; height: 32px;
      display: flex; align-items: center; justify-content: center;
      background: transparent; border: 1.5px solid transparent;
      cursor: pointer; color: var(--text-3);
      border-radius: var(--radius-xs);
      transition: all var(--transition);
    }
    .btn-copy:hover { color: var(--accent); background: var(--accent-bg); border-color: var(--accent-bg-2); }
    .btn-copy.copied { color: var(--accent); }
    .btn-copy svg { width: 15px; height: 15px; }

    .file-icon.type-folder  { background: var(--folder-bg); color: var(--folder); }
    .file-icon.type-image   { background: #fef2f2; color: #ef4444; }
    .file-icon.type-archive { background: #f5f3ff; color: #8b5cf6; }
    .file-icon.type-code    { background: #ecfdf5; color: #10b981; }
    .file-icon.type-doc     { background: #eff6ff; color: #3b82f6; }
    .file-icon.type-audio   { background: #fffbeb; color: #f59e0b; }
    .file-icon.type-video   { background: #fdf2f8; color: #ec4899; }
    .file-icon.type-text    { background: #f8fafc; color: #64748b; }
    .file-icon.type-file    { background: #f8fafc; color: #94a3b8; }

    /* ─── Grid View ─── */
    .app.grid-mode .list-header { display: none; }
    .app.grid-mode .grid-header {
      display: block;
      padding: 10px 20px 14px;
      font-size: .78rem;
      color: var(--text-3);
      background: var(--surface-2);
      border-bottom: 1.5px solid var(--border-light);
    }
    .app.grid-mode .file-list {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(175px, 1fr));
      gap: 14px;
      padding: 18px;
    }
    .app.grid-mode .file-row {
      display: flex; flex-direction: column; align-items: center;
      gap: 8px; padding: 22px 14px 16px;
      background: var(--surface-2);
      border: 1.5px solid var(--border-light);
      border-radius: var(--radius-sm);
      text-align: center; position: relative;
    }
    .app.grid-mode .file-row:hover {
      border-color: var(--accent);
      background: var(--accent-bg);
      box-shadow: var(--shadow-md);
    }
    .app.grid-mode .file-icon { width: 50px; height: 50px; border-radius: var(--radius-sm); }
    .app.grid-mode .file-icon svg { width: 24px; height: 24px; }
    .app.grid-mode .file-name { flex-direction: column; gap: 2px; }
    .app.grid-mode .file-name .name-text { max-width: 100%; font-size: .82rem; }
    .app.grid-mode .file-size { font-size: .72rem; }
    .app.grid-mode .file-date { display: none; }
    .app.grid-mode .file-actions { position: absolute; top: 8px; right: 8px; }

    /* ─── Footer ─── */
    .footer {
      padding: 18px 0;
      margin-top: auto;
      font-size: .78rem;
      color: var(--text-3);
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .footer-tag {
      display: inline-flex; align-items: center; gap: 5px;
      padding: 3px 10px;
      background: var(--accent-bg);
      color: var(--accent);
      border-radius: 20px;
      font-size: .7rem;
      font-weight: 500;
    }
    .footer-tag svg { width: 12px; height: 12px; }

    /* ─── States ─── */
    .state {
      flex: 1; display: flex; flex-direction: column;
      align-items: center; justify-content: center;
      gap: 10px; padding: 80px 20px; text-align: center;
    }
    .state-icon {
      width: 64px; height: 64px;
      display: flex; align-items: center; justify-content: center;
      background: var(--accent-bg);
      border-radius: 50%;
      font-size: 1.8rem;
    }
    .state.error .state-icon { background: #fef2f2; }
    .state-title { font-family: var(--serif); font-size: 1.2rem; font-weight: 500; color: var(--text-2); }
    .state-text { font-size: .85rem; color: var(--text-3); max-width: 320px; line-height: 1.5; }

    .loader { display: none; }
    .loader.show { display: flex; }
    .loader-bar {
      width: 100%; max-width: 180px; height: 3px;
      background: var(--border); border-radius: 2px; overflow: hidden;
    }
    .loader-bar::after {
      content:''; display:block; width:35%; height:100%;
      background: linear-gradient(90deg, var(--accent), #34d399);
      border-radius: 2px;
      animation: slide .9s ease-in-out infinite;
    }
    @keyframes slide { 0%{transform:translateX(-120%)} 100%{transform:translateX(400%)} }

    .toast {
      position:fixed; bottom:30px; left:50%;
      transform:translateX(-50%) translateY(60px);
      padding:10px 22px; background:var(--surface);
      border:1.5px solid var(--border); border-radius:var(--radius-sm);
      font-size:.82rem; font-weight:500; color:var(--accent);
      box-shadow:var(--shadow-lg); opacity:0;
      transition:all .3s ease; z-index:1000; pointer-events:none;
    }
    .toast.show { opacity:1; transform:translateX(-50%) translateY(0); }

    @keyframes fadeUp {
      from { opacity:0; transform:translateY(10px); }
      to   { opacity:1; transform:translateY(0); }
    }

    @media (max-width:700px) {
      .app { padding: 0 16px; }
      .header { flex-wrap: wrap; gap: 10px; }
      .search-wrap { max-width: 100%; order: 3; flex-basis: 100%; }
      .list-header { display: none; }
      .file-row {
        display: grid;
        grid-template-columns: 1fr auto;
        gap: 8px; padding: 12px 16px;
      }
      .file-date, .file-actions { display: none; }
      .app.grid-mode .file-list {
        grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
        padding: 12px;
      }
    }
  </style>
</head>
<body>
  <div class="app" id="app">
    <header class="header">
      <div class="nav-group" id="nav-group">
        <button class="logo-back" id="logo-back" title="返回上级目录">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"/></svg>
        </button>
        <a class="logo" id="logo-btn" href="#/" title="返回根目录">
          <div class="logo-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/><polyline points="3.27 6.96 12 12.01 20.73 6.96"/><line x1="12" y1="22.08" x2="12" y2="12"/></svg>
          </div>
          <span>Archive</span>
        </a>
      </div>

      <div class="search-wrap">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
        <input type="text" class="search" id="search" placeholder="搜索文件..." autocomplete="off">
      </div>

      <div class="header-actions">
        <div class="view-btns">
          <button class="view-btn active" id="btn-list" title="列表视图">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="8" y1="6" x2="21" y2="6"/><line x1="8" y1="12" x2="21" y2="12"/><line x1="8" y1="18" x2="21" y2="18"/><line x1="3" y1="6" x2="3.01" y2="6"/><line x1="3" y1="12" x2="3.01" y2="12"/><line x1="3" y1="18" x2="3.01" y2="18"/></svg>
          </button>
          <button class="view-btn" id="btn-grid" title="网格视图">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
          </button>
        </div>

        <!-- 用户菜单 -->
        <div class="user-menu">
          <button class="user-btn" id="user-btn" title="用户菜单">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
              <circle cx="12" cy="7" r="4"/>
            </svg>
          </button>
          <div class="user-dropdown" id="user-dropdown">
            <div class="user-dropdown-item" id="user-info">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                <circle cx="12" cy="7" r="4"/>
              </svg>
              <span id="username-display">用户</span>
            </div>
            <div class="user-dropdown-divider"></div>
            <div class="user-dropdown-item danger" id="logout-btn">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>
                <polyline points="16 17 21 12 16 7"/>
                <line x1="21" y1="12" x2="9" y2="12"/>
              </svg>
              <span>退出登录</span>
            </div>
          </div>
        </div>
      </div>
    </header>

    <nav class="breadcrumb" id="breadcrumb"></nav>

    <div class="file-card">
      <div class="list-header" id="list-header">
        <span data-sort="name">名称 <span class="sort-icon"></span></span>
        <span data-sort="size">大小 <span class="sort-icon"></span></span>
        <span data-sort="date">修改时间 <span class="sort-icon"></span></span>
        <span></span>
      </div>
      <div class="grid-header" id="grid-header"></div>
      <div class="file-list" id="file-list"></div>
    </div>

    <div class="state loader" id="loader">
      <div class="loader-bar"></div>
    </div>

    <div class="state error" id="error" style="display:none">
      <div class="state-icon">&#9888;</div>
      <div class="state-title" id="error-title">加载失败</div>
      <div class="state-text" id="error-text"></div>
    </div>

    <div class="state" id="empty" style="display:none">
      <div class="state-icon">&#128193;</div>
      <div class="state-title">空文件夹</div>
      <div class="state-text">这个目录下还没有任何文件</div>
    </div>

    <footer class="footer" id="footer"></footer>
  </div>

  <div class="toast" id="toast"></div>

  <script>
  (() => {
    'use strict';

    const API = '/api';
    const DL  = '/dl';
    const TOKEN_KEY = 'archive_auth_token';
    const USER_KEY = 'archive_username';

    /* ─── 登录验证 ─── */
    function checkAuth() {
      const token = localStorage.getItem(TOKEN_KEY);
      const username = localStorage.getItem(USER_KEY);
      if (!token || !username) {
        window.location.href = '/login';
        return false;
      }
      return true;
    }

    function logout() {
      localStorage.removeItem(TOKEN_KEY);
      localStorage.removeItem(USER_KEY);
      localStorage.removeItem('archive_remember');
      window.location.href = '/login';
    }

    function getUsername() {
      return localStorage.getItem(USER_KEY) || '用户';
    }

    /* ─── Icons ─── */
    const ICONS = {
      folder:  `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"/></svg>`,
      file:    `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M13 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V9z"/><polyline points="13 2 13 9 20 9"/></svg>`,
      image:   `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg>`,
      archive: `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M21 8v13H3V8"/><rect x="1" y="3" width="22" height="5"/><line x1="10" y1="12" x2="14" y2="12"/></svg>`,
      code:    `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><polyline points="16 18 22 12 16 6"/><polyline points="8 6 2 12 8 18"/></svg>`,
      doc:     `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/></svg>`,
      audio:   `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M9 18V5l12-2v13"/><circle cx="6" cy="18" r="3"/><circle cx="18" cy="16" r="3"/></svg>`,
      video:   `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><polygon points="23 7 16 12 23 17 23 7"/><rect x="1" y="5" width="15" height="14" rx="2"/></svg>`,
      text:    `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/></svg>`,
    };
    const COPY_ICON = `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>`;

    const TYPE_MAP = {
      image:   ['jpg','jpeg','png','gif','webp','svg','bmp','ico','tiff','avif'],
      archive: ['zip','tar','gz','bz2','xz','7z','rar','tgz','zst'],
      code:    ['js','ts','py','java','c','cpp','h','go','rs','rb','php','html','css','json','xml','yaml','yml','toml','sh','bash','sql','vue','jsx','tsx','swift','kt'],
      doc:     ['pdf','doc','docx','xls','xlsx','ppt','pptx','odt','ods','odp','rtf'],
      audio:   ['mp3','wav','flac','aac','ogg','wma','m4a'],
      video:   ['mp4','mkv','avi','mov','wmv','flv','webm','m4v'],
      text:    ['txt','md','log','csv','ini','conf','cfg','env','gitignore','dockerignore'],
    };

    function getFileType(name) {
      const ext = name.split('.').pop().toLowerCase();
      for (const [type, exts] of Object.entries(TYPE_MAP)) {
        if (exts.includes(ext)) return type;
      }
      return 'file';
    }

    function getIcon(item) {
      if (item.type === 'directory') return { icon: ICONS.folder, cls: 'type-folder' };
      const t = getFileType(item.name);
      return { icon: ICONS[t] || ICONS.file, cls: 'type-' + t };
    }

    function esc(s) {
      const d = document.createElement('div');
      d.textContent = s;
      return d.innerHTML;
    }

    function fmtSize(bytes) {
      if (bytes == null) return '—';
      if (bytes === 0) return '0 B';
      const u = ['B','KB','MB','GB','TB'];
      const i = Math.floor(Math.log(bytes) / Math.log(1024));
      return (bytes / Math.pow(1024, i)).toFixed(i > 0 ? 1 : 0) + ' ' + u[i];
    }

    function fmtDate(iso) {
      if (!iso) return '—';
      const d = new Date(iso);
      const pad = n => String(n).padStart(2, '0');
      return `${d.getFullYear()}-${pad(d.getMonth()+1)}-${pad(d.getDate())} ${pad(d.getHours())}:${pad(d.getMinutes())}`;
    }

    function toast(msg) {
      const el = document.getElementById('toast');
      el.textContent = msg;
      el.classList.add('show');
      clearTimeout(el._t);
      el._t = setTimeout(() => el.classList.remove('show'), 2000);
    }

    /* ─── State ─── */
    let state = {
      path: '/',
      files: [],
      sortKey: 'name',
      sortAsc: true,
      view: 'list',
      query: '',
    };

    /* ─── DOM ─── */
    const $app      = document.getElementById('app');
    const $list     = document.getElementById('file-list');
    const $bread    = document.getElementById('breadcrumb');
    const $footer   = document.getElementById('footer');
    const $loader   = document.getElementById('loader');
    const $error    = document.getElementById('error');
    const $empty    = document.getElementById('empty');
    const $search   = document.getElementById('search');
    const $listHead = document.getElementById('list-header');
    const $gridHead = document.getElementById('grid-header');
    const $navGroup = document.getElementById('nav-group');
    const $logoBack = document.getElementById('logo-back');
    const $logoBtn  = document.getElementById('logo-btn');
    const $userBtn  = document.getElementById('user-btn');
    const $userDropdown = document.getElementById('user-dropdown');
    const $usernameDisplay = document.getElementById('username-display');
    const $logoutBtn = document.getElementById('logout-btn');

    /* ─── Path helpers ─── */
    function getPath() {
      let h = location.hash.slice(1) || '/';
      if (!h.startsWith('/')) h = '/' + h;
      if (!h.endsWith('/')) h += '/';
      return h;
    }

    function getParentPath(path) {
      const parts = path.split('/').filter(Boolean);
      if (parts.length === 0) return '/';
      parts.pop();
      return '/' + (parts.length ? parts.join('/') + '/' : '');
    }

    function isRoot() {
      return state.path === '/' || state.path === '';
    }

    /* ─── Navigate ─── */
    function navigate(path) {
      if (state.path === path) {
        load();
        return;
      }
      state.path = path;
      location.hash = '#' + path;
      load();
    }

    /* ─── Update header state ─── */
    function updateNavState() {
      if (isRoot()) {
        $navGroup.classList.remove('has-parent');
        $logoBtn.title = 'Archive';
      } else {
        $navGroup.classList.add('has-parent');
        $logoBtn.title = '返回根目录';
      }
    }

    /* ─── Fetch & Load ─── */
    async function load() {
      $list.innerHTML = '';
      $error.style.display = 'none';
      $empty.style.display = 'none';
      $loader.classList.add('show');
      updateNavState();

      try {
        const resp = await fetch(API + state.path);
        if (!resp.ok) throw new Error(`HTTP ${resp.status}`);
        let data = await resp.json();
        if (!Array.isArray(data)) data = [];
        state.files = data;
        render();
      } catch (e) {
        $error.style.display = 'flex';
        document.getElementById('error-title').textContent = '无法加载目录';
        document.getElementById('error-text').textContent = e.message;
      } finally {
        $loader.classList.remove('show');
      }
    }

    /* ─── Render ─── */
    function render() {
      renderBread();
      renderFiles();
      renderFooter();
      updateSortIndicators();
    }

    function renderBread() {
      const parts = state.path.split('/').filter(Boolean);
      let html = '';

      if (parts.length === 0) {
        html = `<span class="crumb current">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/></svg>
          Archive
        </span>`;
      } else {
        html = `<a class="crumb" href="#/">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/></svg>
          Archive
        </a>`;
      }

      let cumPath = '/';
      for (let i = 0; i < parts.length; i++) {
        cumPath += parts[i] + '/';
        html += `<span class="crumb-sep">›</span>`;
        if (i === parts.length - 1) {
          html += `<span class="crumb current">${esc(parts[i])}</span>`;
        } else {
          html += `<a class="crumb" href="#${cumPath}">${esc(parts[i])}</a>`;
        }
      }
      $bread.innerHTML = html;
    }

    function getFiltered() {
      let files = [...state.files];
      if (state.query) {
        const q = state.query.toLowerCase();
        files = files.filter(f => f.name.toLowerCase().includes(q));
      }
      files.sort((a, b) => {
        if (a.type === 'directory' && b.type !== 'directory') return -1;
        if (a.type !== 'directory' && b.type === 'directory') return 1;
        let va, vb;
        switch (state.sortKey) {
          case 'size': va = a.size || 0; vb = b.size || 0; break;
          case 'date': va = a.mtime || ''; vb = b.mtime || ''; break;
          default:     va = a.name.toLowerCase(); vb = b.name.toLowerCase();
        }
        if (va < vb) return state.sortAsc ? -1 : 1;
        if (va > vb) return state.sortAsc ? 1 : -1;
        return 0;
      });
      return files;
    }

    function renderFiles() {
      const filtered = getFiltered();

      if (state.files.length === 0) {
        $empty.style.display = 'flex';
        $empty.querySelector('.state-title').textContent = '空文件夹';
        $empty.querySelector('.state-text').textContent = '这个目录下还没有任何文件';
        $list.innerHTML = '';
        return;
      }
      if (filtered.length === 0) {
        $list.innerHTML = '';
        $empty.style.display = 'flex';
        $empty.querySelector('.state-title').textContent = '无匹配结果';
        $empty.querySelector('.state-text').textContent = `没有找到包含 "${state.query}" 的文件`;
        return;
      }
      $empty.style.display = 'none';

      let html = '';
      filtered.forEach((item, i) => {
        const { icon, cls } = getIcon(item);
        const isFolder = item.type === 'directory';
        const href = isFolder
          ? `#${state.path}${item.name}/`
          : `${DL}${state.path}${encodeURIComponent(item.name)}`;

        html += `
          <div class="file-row"
               style="animation-delay:${i * 0.025}s"
               data-href="${esc(href)}"
               data-folder="${isFolder}">
            <div class="file-name">
              <div class="file-icon ${cls}">${icon}</div>
              <span class="name-text" title="${esc(item.name)}">${esc(item.name)}</span>
            </div>
            <div class="file-size">${isFolder ? '—' : fmtSize(item.size)}</div>
            <div class="file-date">${fmtDate(item.mtime)}</div>
            <div class="file-actions">
              ${isFolder ? '' : `<button class="btn-copy" data-link="${esc(href)}" title="复制下载链接">${COPY_ICON}</button>`}
            </div>
          </div>`;
      });
      $list.innerHTML = html;
      $gridHead.textContent = `${filtered.length} 个项目`;
    }

    function renderFooter() {
      const total = state.files.reduce((s, f) => s + (f.size || 0), 0);
      const dirs  = state.files.filter(f => f.type === 'directory').length;
      const files = state.files.length - dirs;
      let parts = [];
      if (dirs)  parts.push(`${dirs} 个文件夹`);
      if (files) parts.push(`${files} 个文件`);
      if (total) parts.push(fmtSize(total));
      $footer.innerHTML = `
        <span>${parts.join(' · ') || '空目录'}</span>
        <span class="footer-tag">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
          Cloudflare Tunnel
        </span>`;
    }

    function updateSortIndicators() {
      document.querySelectorAll('.list-header span[data-sort]').forEach(el => {
        const key = el.dataset.sort;
        const icon = el.querySelector('.sort-icon');
        icon.textContent = (key === state.sortKey) ? (state.sortAsc ? '↑' : '↓') : '';
      });
    }

    /* ─── Events ─── */
    $logoBtn.addEventListener('click', e => {
      e.preventDefault();
      navigate('/');
    });

    $logoBack.addEventListener('click', e => {
      e.preventDefault();
      e.stopPropagation();
      navigate(getParentPath(state.path));
    });

    $list.addEventListener('click', e => {
      const btn = e.target.closest('.btn-copy');
      if (btn) {
        e.stopPropagation();
        const link = location.origin + btn.dataset.link;
        navigator.clipboard.writeText(link).then(() => {
          btn.classList.add('copied');
          toast('链接已复制到剪贴板');
          setTimeout(() => btn.classList.remove('copied'), 1500);
        });
        return;
      }
      const row = e.target.closest('.file-row');
      if (!row) return;
      if (row.dataset.folder === 'true') {
        navigate(row.dataset.href.slice(1));
      } else {
        const a = document.createElement('a');
        a.href = row.dataset.href;
        a.download = '';
        a.click();
      }
    });

    $search.addEventListener('input', () => {
      state.query = $search.value.trim();
      renderFiles();
    });

    $listHead.addEventListener('click', e => {
      const col = e.target.closest('[data-sort]');
      if (!col) return;
      const key = col.dataset.sort;
      if (state.sortKey === key) { state.sortAsc = !state.sortAsc; }
      else { state.sortKey = key; state.sortAsc = true; }
      renderFiles();
      updateSortIndicators();
    });

    document.getElementById('btn-list').addEventListener('click', () => {
      state.view = 'list';
      $app.classList.remove('grid-mode');
      document.getElementById('btn-list').classList.add('active');
      document.getElementById('btn-grid').classList.remove('active');
    });
    document.getElementById('btn-grid').addEventListener('click', () => {
      state.view = 'grid';
      $app.classList.add('grid-mode');
      document.getElementById('btn-grid').classList.add('active');
      document.getElementById('btn-list').classList.remove('active');
    });

    // 用户菜单
    $userBtn.addEventListener('click', (e) => {
      e.stopPropagation();
      $userDropdown.classList.toggle('show');
    });

    document.addEventListener('click', () => {
      $userDropdown.classList.remove('show');
    });

    $logoutBtn.addEventListener('click', () => {
      logout();
    });

    document.addEventListener('keydown', e => {
      if (e.key === '/' && document.activeElement !== $search) {
        e.preventDefault();
        $search.focus();
      }
      if (e.key === 'Escape') {
        $search.value = '';
        state.query = '';
        $search.blur();
        renderFiles();
      }
      if (e.key === 'Backspace' && document.activeElement !== $search) {
        e.preventDefault();
        const parent = getParentPath(state.path);
        if (parent !== state.path) navigate(parent);
      }
    });

    window.addEventListener('hashchange', () => {
      const newPath = getPath();
      if (newPath !== state.path) {
        state.path = newPath;
        load();
      }
    });

    /* ─── Init ─── */
    if (!checkAuth()) {
      return;
    }

    $usernameDisplay.textContent = getUsername();
    state.path = getPath();
    load();
  })();
  </script>
</body>
</html>
```

---

## 第七步：添加文件和持续管理

往下载目录放文件：

```bash
# 放一个示例文件
echo "Hello World" > /var/www/files/hello.txt
mkdir -p /var/www/files/Software
mkdir -p /var/www/files/Documents

# 确保权限正确
sudo chown -R nginx:nginx /var/www/files
sudo chmod -R 755 /var/www/files
```

### 防止 Nginx 进程意外退出

```bash
crontab -e
```

添加：

```bash
*/5 * * * * pgrep -x nginx || systemctl restart nginx
```

---

## 默认账号

| 用户名 | 密码 |
|--------|------|
| admin  | admin123 |
| user   | user123 |

**注意**: 这是前端验证，生产环境建议使用后端验证。

---

## 效果说明

### 登录页面
- **渐变色动态背景**：绿色系渐变动画，3个模糊光球浮动
- **毛玻璃效果**：登录卡片半透明磨砂玻璃效果
- **密码切换**：点击眼睛图标显示/隐藏密码
- **记住我**：勾选后保持登录状态
- **错误提示**：红色提示框 + 抖动动画

### 主页面
- **登录保护**：未登录自动跳转到 `/login`
- **用户菜单**：右上角显示用户名，支持退出登录
- **清新绿色主题**：薄荷白底 + 翡翠绿点缀
- **自适应布局**：桌面端表格视图，移动端自动切换为紧凑卡片
- **列表 / 网格切换**：右上角按钮一键切换
- **文件图标**：按类型自动分配颜色
- **搜索过滤**：实时搜索当前目录
- **排序**：点击表头按名称、大小、修改时间排序
- **面包屑导航**：支持逐级跳转
- **一键复制链接**：每行文件右侧复制按钮
- **零依赖**：单个 HTML 文件，仅从 Google Fonts 加载字体