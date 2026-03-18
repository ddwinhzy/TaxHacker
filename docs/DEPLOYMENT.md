# TaxHacker 本地部署测试指南

本指南提供 TaxHacker 应用的完整本地部署和测试流程，包括 Docker 部署和本地开发环境搭建两种方式。

## 📋 环境要求

### 最低配置
- **操作系统**: macOS 12+ / Linux / Windows 10+ (WSL2)
- **内存**: 4GB RAM (推荐 8GB+)
- **磁盘空间**: 10GB 可用空间
- **Node.js**: 18.0+ (仅本地开发)
- **PostgreSQL**: 14+ (推荐 17)
- **Docker**: 24.0+ (Docker 部署)

### 必需工具
```bash
# macOS (使用 Homebrew)
brew install node@20 postgresql@17

# Ubuntu/Debian
sudo apt update
sudo apt install -y nodejs npm postgresql postgresql-contrib

# Docker (所有平台)
# 访问 https://docs.docker.com/get-docker/ 安装
```

---

## 🐳 方式一：Docker 部署（推荐）

### 1. 快速启动（使用官方镜像）

```bash
# 创建工作目录
mkdir ~/taxhacker && cd ~/taxhacker

# 下载 docker-compose.yml
curl -O https://raw.githubusercontent.com/vas3k/TaxHacker/main/docker-compose.yml

# 启动服务
docker compose up -d

# 查看日志
docker compose logs -f app
```

服务将在 `http://localhost:7331` 启动。

### 2. 使用自定义配置

创建 `docker-compose.custom.yml`:

```yaml
services:
  app:
    image: ghcr.io/vas3k/taxhacker:latest
    ports:
      - "7331:7331"
    environment:
      - NODE_ENV=production
      - SELF_HOSTED_MODE=true
      - UPLOAD_PATH=/app/data/uploads
      - DATABASE_URL=postgresql://postgres:postgres@postgres:5432/taxhacker
      - BETTER_AUTH_SECRET=your-random-secret-key-min-16-chars
      # AI 配置（可选，也可在界面配置）
      - OPENAI_API_KEY=sk-xxx
      - OPENAI_MODEL_NAME=gpt-4o-mini
    volumes:
      - ./data:/app/data
    restart: unless-stopped
    depends_on:
      - postgres

  postgres:
    image: postgres:17-alpine
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_DB=taxhacker
    volumes:
      - ./pgdata:/var/lib/postgresql/data
    restart: unless-stopped
```

启动自定义配置：
```bash
docker compose -f docker-compose.custom.yml up -d
```

### 3. 从源码构建 Docker 镜像

```bash
# 克隆仓库
git clone https://github.com/vas3k/TaxHacker.git
cd TaxHacker

# 构建本地镜像
docker build -t taxhacker:local .

# 修改 docker-compose.yml 使用本地镜像
# 将 image: ghcr.io/vas3k/taxhacker:latest 改为 image: taxhacker:local

# 启动
docker compose up -d
```

### 4. Docker 常用命令

```bash
# 查看运行状态
docker compose ps

# 查看日志
docker compose logs -f

# 重启服务
docker compose restart

# 停止服务
docker compose down

# 停止并删除数据（⚠️ 谨慎使用）
docker compose down -v
rm -rf ./data ./pgdata

# 更新到最新版本
docker compose pull
docker compose up -d
```

---

## 💻 方式二：本地开发环境

### 1. 克隆代码

```bash
git clone https://github.com/vas3k/TaxHacker.git
cd TaxHacker
```

### 2. 安装依赖

```bash
# 使用 npm
npm install

# 或使用 pnpm（更快）
pnpm install

# 或使用 yarn
yarn install
```

### 3. 安装系统依赖

**macOS:**
```bash
brew install gs graphicsmagick postgresql@17
```

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install -y ghostscript graphicsmagick postgresql postgresql-contrib
```

**Windows (WSL2):**
```bash
# 在 WSL2 中运行
sudo apt update
sudo apt install -y ghostscript graphicsmagick postgresql postgresql-contrib
```

### 4. 配置数据库

**方式 A：使用本地 PostgreSQL**

```bash
# 启动 PostgreSQL
# macOS
brew services start postgresql@17

# Linux
sudo systemctl start postgresql

# 创建数据库和用户
sudo -u postgres psql -c "CREATE DATABASE taxhacker;"
sudo -u postgres psql -c "CREATE USER taxuser WITH PASSWORD 'taxpass';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE taxhacker TO taxuser;"
```

**方式 B：使用 Docker PostgreSQL**

```bash
docker run -d \
  --name taxhacker-db \
  -e POSTGRES_USER=taxuser \
  -e POSTGRES_PASSWORD=taxpass \
  -e POSTGRES_DB=taxhacker \
  -p 5432:5432 \
  -v ~/postgres_data:/var/lib/postgresql/data \
  postgres:17-alpine
```

### 5. 配置环境变量

```bash
cp .env.example .env
```

编辑 `.env` 文件：

```env
# 基础配置
PORT=7331
SELF_HOSTED_MODE=true
DISABLE_SIGNUP=false

# 数据路径
UPLOAD_PATH="./data/uploads"

# 数据库连接（根据你的配置修改）
# 本地 PostgreSQL
DATABASE_URL="postgresql://taxuser:taxpass@localhost:5432/taxhacker"
# Docker PostgreSQL
# DATABASE_URL="postgresql://taxuser:taxpass@localhost:5432/taxhacker"

# AI 配置（至少配置一个）
OPENAI_API_KEY="sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
OPENAI_MODEL_NAME="gpt-4o-mini"

# 可选：Google Gemini
GOOGLE_API_KEY=""
GOOGLE_MODEL_NAME="gemini-2.5-flash"

# 可选：Mistral
MISTRAL_API_KEY=""
MISTRAL_MODEL_NAME="mistral-medium-latest"

# 认证密钥（必需，最少16字符）
BETTER_AUTH_SECRET="your-super-secret-key-here-min-16-chars"
```

### 6. 初始化数据库

```bash
# 生成 Prisma 客户端
npx prisma generate

# 执行数据库迁移
npx prisma migrate dev --name init

# 查看数据库（可选）
npx prisma studio
```

### 7. 启动开发服务器

```bash
# 开发模式（热重载）
npm run dev

# 或使用 pnpm
pnpm dev
```

访问 http://localhost:7331

### 8. 生产构建测试

```bash
# 构建生产版本
npm run build

# 启动生产服务器
npm run start
```

---

## 🧪 功能测试清单

部署完成后，按以下清单进行测试：

### 基础功能测试

- [ ] **应用启动**: 访问 `http://localhost:7331` 正常加载
- [ ] **首次登录**: 自托管模式自动登录或注册新账户
- [ ] **上传文档**: 上传一张收据/发票图片
- [ ] **AI 解析**: 确认 AI 正确提取金额、日期、商家等信息
- [ ] **手动输入**: 创建一笔手动交易记录
- [ ] **分类管理**: 创建自定义分类
- [ ] **项目管理**: 创建项目并分配交易
- [ ] **搜索筛选**: 使用搜索和筛选功能
- [ ] **数据导出**: 导出 CSV 文件

### AI 功能测试

- [ ] **多语言支持**: 测试中文/英文/日文收据
- [ ] **多币种**: 上传外币收据，检查汇率转换
- [ ] **加密货币**: 测试 BTC/ETH 交易记录
- [ ] **自定义字段**: 创建自定义字段并提取特定信息
- [ ] **批量处理**: 上传多个文档批量处理

### 边界测试

- [ ] **大文件**: 上传 >10MB 的 PDF
- [ ] **复杂布局**: 测试手写收据或复杂表格
- [ ] **空数据**: 创建没有附件的交易
- [ ] **特殊字符**: 使用 emoji 或特殊符号
- [ ] **并发上传**: 同时上传多个文件

---

## 🔧 常见问题排查

### 1. 数据库连接失败

**错误信息**: `Can't reach database server`

**解决方案**:
```bash
# 检查 PostgreSQL 是否运行
# macOS
brew services list | grep postgresql

# Linux
sudo systemctl status postgresql

# 测试连接
psql postgresql://taxuser:taxpass@localhost:5432/taxhacker

# 检查端口占用
lsof -i :5432
```

### 2. AI 解析失败

**错误信息**: `AI processing failed` 或 API 错误

**解决方案**:
- 检查 `.env` 中的 API 密钥是否正确
- 确认 API 密钥有余额/未过期
- 检查网络连接（某些地区可能需要代理）
- 查看应用日志获取详细错误

### 3. 文件上传失败

**错误信息**: `Upload failed` 或权限错误

**解决方案**:
```bash
# 检查上传目录权限
ls -la ./data/uploads

# 修复权限
chmod -R 755 ./data
chown -R $USER:$USER ./data

# Docker 部署需检查容器权限
docker compose exec app ls -la /app/data
```

### 4. 端口冲突

**错误信息**: `Port 7331 is already in use`

**解决方案**:
```bash
# 查看占用端口的进程
lsof -i :7331

# 终止进程
kill -9 <PID>

# 或使用其他端口
# 修改 .env 或 docker-compose.yml 中的 PORT
```

### 5. 构建失败

**错误信息**: `npm run build` 失败

**解决方案**:
```bash
# 清除缓存
rm -rf node_modules package-lock.json
npm install

# 检查 Node.js 版本
node --version  # 需要 18+

# 查看详细错误
npm run build 2>&1 | tee build.log
```

### 6. 数据库迁移失败

**错误信息**: `Migration failed`

**解决方案**:
```bash
# 重置数据库（⚠️ 会丢失数据）
npx prisma migrate reset

# 或手动回滚
npx prisma migrate resolve --rolled-back <migration-name>

# 然后重新迁移
npx prisma migrate dev
```

---

## 📊 性能优化

### Docker 部署优化

```yaml
# docker-compose.yml 优化配置
services:
  app:
    deploy:
      resources:
        limits:
          memory: 2G
        reservations:
          memory: 512M
    # 使用健康检查
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:7331/api/health"]
      interval: 30s
      timeout: 10s
      retries: 3
```

### 本地开发优化

```bash
# 使用 SWC 加速编译
npm install @swc/core

# 禁用 sourcemap 加速构建
GENERATE_SOURCEMAP=false npm run build
```

---

## 🛡️ 安全建议

### 生产环境部署

1. **修改默认密码**: 更改 PostgreSQL 默认密码
2. **使用 HTTPS**: 配置反向代理（Nginx/Caddy）
3. **限制访问**: 配置防火墙规则
4. **定期备份**: 设置数据库自动备份
5. **环境变量**: 不要将 `.env` 提交到 Git

### 示例 Nginx 配置

```nginx
server {
    listen 80;
    server_name taxhacker.yourdomain.com;
    
    location / {
        proxy_pass http://localhost:7331;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

---

## 📝 日志查看

### Docker 日志

```bash
# 查看实时日志
docker compose logs -f app

# 查看最近 100 行
docker compose logs --tail 100 app

# 查看特定时间段的日志
docker compose logs --since 2024-01-01T00:00:00 app
```

### 本地开发日志

```bash
# 查看应用日志
tail -f logs/app.log

# 查看 PM2 日志（如使用 PM2）
pm2 logs taxhacker
```

---

## 🔄 更新升级

### Docker 升级

```bash
cd ~/taxhacker

# 拉取最新镜像
docker compose pull

# 重启服务
docker compose up -d

# 查看新版本
docker compose exec app cat package.json | grep version
```

### 本地代码升级

```bash
# 拉取最新代码
git pull origin main

# 更新依赖
npm install

# 执行数据库迁移
npx prisma migrate deploy

# 重新构建
npm run build

# 重启服务
npm run start
```

---

## 📞 获取帮助

- **GitHub Issues**: https://github.com/vas3k/TaxHacker/issues
- **文档**: https://github.com/vas3k/TaxHacker/blob/main/README.md
- **演示视频**: https://taxhacker.app/landing/video.mp4

---

## ✅ 部署检查表

部署完成后，确认以下事项：

- [ ] 应用可以通过浏览器正常访问
- [ ] 数据库连接正常，数据可以读写
- [ ] AI 功能正常工作（至少配置了一个 API 密钥）
- [ ] 文件上传功能正常
- [ ] 数据导出功能正常
- [ ] 环境变量配置正确，无敏感信息泄露
- [ ] 日志记录正常工作
- [ ] 设置了定期备份计划
- [ ] 配置了监控和告警（生产环境）

---

**祝你部署顺利！** 🚀
