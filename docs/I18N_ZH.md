# TaxHacker 中文本地化分支 (i18n/zh)

本分支基于 [vas3k/TaxHacker](https://github.com/vas3k/TaxHacker) 添加了简体中文 (Simplified Chinese) 界面支持。

## 分支说明

- **分支名**: `i18n/zh`
- **上游**: `https://github.com/vas3k/TaxHacker.git`
- **支持语言**: English (默认), 简体中文

## 快速开始

### 1. 克隆本分支

```bash
git clone -b i18n/zh https://github.com/ddwinhzy/TaxHacker.git
cd TaxHacker
npm install
```

### 2. 配置环境变量

复制 `.env.example` 为 `.env` 并配置必要的环境变量:

```bash
cp .env.example .env
```

至少需要配置:
- `BETTER_AUTH_SECRET` - 至少 32 个字符的随机字符串
- `DATABASE_URL` - PostgreSQL 数据库连接字符串

### 3. 启动开发服务器

```bash
npm run dev
```

访问 http://localhost:7331

### 4. 切换语言

在侧边栏用户菜单中点击语言切换器即可在 EN/中文 之间切换。

## 同步上游更新

当上游 (vas3k/TaxHacker) 有新更新时，运行同步脚本:

```bash
# 交互模式 (使用 merge)
./scripts/sync-i18n.sh

# 使用 rebase 模式
./scripts/sync-i18n.sh --rebase

# 预览模式 (查看将要同步的内容，不实际更改)
./scripts/sync-i18n.sh --dry-run
```

### 同步脚本功能

1. **自动添加上游远程仓库** (如果不存在)
2. **获取上游最新更改**
3. **合并/变基到当前分支**
4. **备份中文翻译文件**
5. **解决冲突时保留中文翻译**
6. **自动恢复中文翻译文件**
7. **验证构建是否成功**

### 同步后操作

1. 如果有冲突，手动解决后运行:
   ```bash
   git add .
   git commit
   ```

2. 推送更新:
   ```bash
   git push
   ```

## 翻译文件说明

```
messages/
├── en.json    # 英文翻译 (上游原始)
└── zh.json    # 中文翻译 (本分支维护)

i18n/
└── request.ts  # next-intl 配置

routing.ts        # 路由配置
```

## 添加新的翻译

### 1. 在翻译文件中添加 key

**messages/zh.json**:
```json
{
  "nav": {
    "home": "首页"
  }
}
```

**messages/en.json**:
```json
{
  "nav": {
    "home": "Home"
  }
}
```

### 2. 在组件中使用

**客户端组件**:
```tsx
import { useTranslations } from "next-intl"

function MyComponent() {
  const t = useTranslations("nav")
  return <span>{t("home")}</span>
}
```

**服务端组件**:
```tsx
import { getTranslations } from "next-intl/server"

async function MyServerComponent() {
  const t = await getTranslations("nav")
  return <span>{t("home")}</span>
}
```

### 3. 翻译命名空间 (namespaces)

| 命名空间 | 用途 |
|---------|------|
| `common` | 通用词汇 (Save, Cancel, Loading 等) |
| `nav` | 导航菜单 |
| `auth` | 登录/认证相关 |
| `dashboard` | 仪表盘 |
| `transactions` | 交易记录 |
| `settings` | 设置页面 |
| `subscription` | 订阅相关 |
| `welcome` | 欢迎消息 |
| `forms` | 表单相关 |
| `pagination` | 分页 |
| `errors` | 错误消息 |
| `fileUpload` | 文件上传 |

## 技术栈

- **框架**: Next.js 15 + React 19
- **国际化**: next-intl
- **UI**: shadcn/ui + Tailwind CSS
- **认证**: Better Auth
- **数据库**: PostgreSQL + Prisma

## 许可证

跟随上游项目 [vas3k/TaxHacker](https://github.com/vas3k/TaxHacker) 的许可证。
