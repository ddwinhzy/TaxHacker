<div align="center"><a name="readme-top"></a>

<img src="public/logo/512.png" alt="" width="320">

<br>

# TaxHacker — 自托管 AI 记账助手

[![GitHub Stars](https://img.shields.io/github/stars/vas3k/TaxHacker?color=ffcb47&labelColor=black&style=flat-square)](https://github.com/vas3k/TaxHacker/stargazers)
[![License](https://img.shields.io/badge/license-MIT-ffcb47?labelColor=black&style=flat-square)](https://github.com/vas3k/TaxHacker/blob/main/LICENSE)
[![GitHub Issues](https://img.shields.io/github/issues/vas3k/TaxHacker?color=ff80eb&labelColor=black&style=flat-square)](https://github.com/vas3k/TaxHacker/issues)
[![Donate](https://img.shields.io/badge/-Donate-f04f88?logo=githubsponsors&logoColor=white&style=flat-square)](https://vas3k.com/donate/)

</div>

TaxHacker 是一款自托管的记账应用，专为自由职业者、独立开发者和中小企业打造，利用现代 AI 的力量帮你节省时间，自动化管理支出和收入。

上传收据照片、发票或 PDF 文件，TaxHacker 会自动识别并提取记账所需的所有重要数据：商品名称、金额、明细、日期、商家、税费，并将它们保存到结构化的类 Excel 数据库中。你甚至可以创建自定义字段，使用你自己的 AI 提示词来提取所需的任何特定信息。

该应用支持基于交易日期历史汇率的自动货币转换（包括加密货币！）。内置筛选功能、多项目支持、导入/导出功能和自定义分类，TaxHacker 让报表生成更简单，报税更轻松。

> 🎥 [观看演示视频](https://taxhacker.app/landing/video.mp4)

![仪表盘](public/landing/main-page.webp)

> \[!IMPORTANT]
>
> 本项目仍处于早期开发阶段。请自行承担使用风险！**为我们加星** 以获取新功能和错误修复的通知 ⭐️

## ✨ 功能特性

### `1` 使用 AI 分析照片和发票

![货币转换](public/landing/ai-scanner-big.webp)

拍摄任何收据照片或上传发票 PDF，TaxHacker 会自动识别、提取、分类并存储所有信息到结构化数据库中。

- **上传和整理文档**：将多个文档存放在"未分类"区域，直到你准备好手动处理或使用 AI 协助
- **AI 数据提取**：使用 AI 自动提取关键信息，如日期、金额、供应商和明细项目
- **自动分类**：根据内容自动将交易分类到相关类别
- **项目拆分**：从发票中提取单个项目，并在需要时拆分为单独的交易
- **结构化存储**：所有内容都保存在有组织的数据库中，便于筛选和检索
- **可定制的 AI 提供商**：可选择 OpenAI、Google Gemini 或 Mistral（本地 LLM 支持即将推出）

TaxHacker 支持多种文档类型，包括商店收据、餐厅账单、发票、银行对账单、信件，甚至手写收据。它能轻松处理任何语言和任何货币。

### `2` 多币种支持，自动转换（甚至包括加密货币！）

![货币转换](public/landing/multi-currency.webp)

TaxHacker 自动检测文档中的货币，并使用历史汇率转换为你设定的基础货币。

- **外币检测**：自动识别任何文档中使用的货币
- **历史汇率**：获取交易当天的实际汇率
- **全球覆盖**：支持 170+ 世界货币和 14 种热门加密货币（BTC、ETH、LTC、DOT 等）
- **灵活输入**：手动输入始终可用，以备你需要更多控制权

### `3` 使用完全可定制的分类、项目和字段组织交易

![交易表格](public/landing/transactions-big.webp)

通过无限的自定义选项，使 TaxHacker 适应你的独特需求。创建自定义字段、项目和分类，更好地满足你的特定需求、行业标准或国家要求。

- **自定义分类和项目**：创建你自己的分类和项目，以任何方便的方式分组交易
- **自定义字段**：你可以创建无限数量的自定义字段，从发票中提取更多信息（就像创建额外的 Excel 列）
- **全文搜索**：搜索已识别文档的实际内容
- **高级筛选**：使用搜索和筛选选项准确找到所需内容
- **AI 驱动提取**：编写自己的提示词，从文档中提取任何自定义信息
- **批量操作**：一次处理多个文档或交易

### `4` 自定义任何 LLM 提示词。包括系统提示词

![自定义分类](public/landing/custom-llm.webp)

完全掌控 TaxHacker 的 AI 如何处理你的文档。为字段、分类和项目编写自定义 AI 提示词，或修改内置提示词以匹配你的特定需求。

- **可自定义系统提示词**：在设置中修改通用提示词模板以适应你的业务
- **字段或项目特定提示词**：为行业特定文档创建自定义提取规则
- **完全控制**：调整字段提取优先级和命名约定以匹配你的工作流程
- **行业优化**：微调 AI 以理解你特定类型的业务文档
- **完全透明**：AI 提取过程的每个方面都在你的控制之下，可以在设置中直接更改

TaxHacker 100% 可适应和可调优，以满足你的独特需求——无论你需要从文档中提取电子邮件、地址、项目代码还是任何其他自定义信息。

### `5` 灵活的数据筛选和导出

![数据导出](public/landing/export.webp)

文档处理完成后，你可以轻松查看、筛选并完全按需导出完整的交易历史。

- **高级筛选**：按日期范围、分类、项目、金额和任何自定义字段筛选
- **灵活导出**：将筛选后的交易导出为 CSV，包含所有附件文档
- **税务就绪报表**：为会计师或税务顾问生成综合报表
- **数据可移植性**：下载完整数据档案以迁移到其他服务——你的数据永远属于你

### `6` 自托管模式确保数据隐私

![自托管](docs/screenshots/exported_archive.png)

通过本地存储和自托管选项，完全掌控你的财务数据。TaxHacker 尊重你的隐私，让你完全拥有自己的信息。

- **家用服务器就绪**：在你自己的基础设施上托管，以获得最大的隐私和控制权
- **原生 Docker 支持**：通过提供的 Docker 容器和 Compose 文件实现简单设置
- **数据所有权**：你的财务文档永远不会离开你的控制
- **无供应商锁定**：随时导出所有内容并迁移
- **透明操作**：完全访问源代码和完整的运营透明度

## 🛳 部署和自托管

TaxHacker 可以轻松自托管在你自己的基础设施上，以完全掌控你的数据和应用环境。我们提供了 [Docker 镜像](./Dockerfile) 和 [Docker Compose](./docker-compose.yml) 配置，使部署变得简单：

```bash
curl -O https://raw.githubusercontent.com/vas3k/TaxHacker/main/docker-compose.yml

docker compose up
```

Docker Compose 配置包括：

- TaxHacker 应用容器
- PostgreSQL 17 数据库（或连接到你现有的数据库）
- 启动时自动执行数据库迁移
- 用于持久化数据存储的卷挂载
- 生产就绪的配置

每次发布新版本时，Docker 镜像都会自动构建和发布。你可以使用特定的版本标签（例如 `v1.0.0`）或 `latest` 获取最新版本。

对于高级设置，你可以自定义 Docker Compose 配置以适应你的基础设施。默认配置使用 GitHub 容器注册表中预构建的镜像，但你也可以使用提供的 [Dockerfile](./Dockerfile) 在本地构建。

自定义配置示例：

```yaml
services:
  app:
    image: ghcr.io/vas3k/taxhacker:latest
    ports:
      - "7331:7331"
    environment:
      - SELF_HOSTED_MODE=true
      - UPLOAD_PATH=/app/data/uploads
      - DATABASE_URL=postgresql://postgres:postgres@localhost:5432/taxhacker
    volumes:
      - ./data:/app/data
    restart: unless-stopped
```

### 环境变量

使用这些环境变量配置 TaxHacker 以满足你的特定需求：

| 变量 | 必需 | 说明 | 示例 |
|----------|----------|-------------|---------|
| `UPLOAD_PATH` | 是 | 文件上传和存储的本地目录 | `./data/uploads` |
| `DATABASE_URL` | 是 | PostgreSQL 连接字符串 | `postgresql://user@localhost:5432/taxhacker` |
| `PORT` | 否 | 应用运行的端口 | `7331`（默认） |
| `BASE_URL` | 否 | 应用的基础 URL | `http://localhost:7331` |
| `SELF_HOSTED_MODE` | 否 | 设置为 "true" 以启用自托管：启用自动登录、自定义 API 密钥和其他功能 | `true` |
| `DISABLE_SIGNUP` | 否 | 在你的实例上禁用新用户注册 | `false` |
| `BETTER_AUTH_SECRET` | 是 | 身份验证的密钥（最少 16 个字符） | `your-secure-random-key` |

你也可以在应用中或通过环境变量配置 LLM 提供商设置：

- **OpenAI**：`OPENAI_MODEL_NAME` 和 `OPENAI_API_KEY`
- **Google Gemini**：`GOOGLE_MODEL_NAME` 和 `GOOGLE_API_KEY`
- **Mistral**：`MISTRAL_MODEL_NAME` 和 `MISTRAL_API_KEY`

## ⌨️ 本地开发

我们使用：

- **Next.js 15+** 用于前端和 API
- **Prisma** 用于数据库模型和迁移
- **PostgreSQL** 作为数据库（推荐使用 PostgreSQL 17+）
- **Ghostscript 和 GraphicsMagick** 用于 PDF 处理（在 macOS 上通过 `brew install gs graphicsmagick` 安装）

设置你的本地开发环境：

```bash
# 克隆仓库
git clone https://github.com/vas3k/TaxHacker.git
cd TaxHacker

# 安装依赖
npm install

# 设置环境变量
cp .env.example .env

# 编辑 .env 文件配置
# 确保将 DATABASE_URL 设置为你的 PostgreSQL 连接字符串
# 示例：postgresql://user@localhost:5432/taxhacker

# 初始化数据库
npx prisma generate && npx prisma migrate dev

# 启动开发服务器
npm run dev
```

访问 `http://localhost:7331` 查看你的本地 TaxHacker 实例。

对于生产构建，请使用以下命令代替 `npm run dev`：

```bash
# 构建应用
npm run build

# 启动生产服务器
npm run start
```

## 🤝 贡献

我们欢迎对 TaxHacker 的贡献！你可以通过以下方式帮助我们做得更好：

- **🐛 错误报告**：遇到问题请提交详细的 issue
- **💡 功能请求**：分享你对新功能和改进的想法
- **🔧 代码贡献**：提交 pull request 改进应用
- **📚 文档**：帮助改进文档和指南
- **🎥 内容创作**：视频、教程和评测帮助我们触达更多用户！

所有开发都在 GitHub 上通过 issues 和 pull requests 进行。我们感谢任何帮助。

[![PRs Welcome](https://img.shields.io/badge/🤯_PRs-welcome-ffcb47?labelColor=black&style=for-the-badge)](https://github.com/vas3k/TaxHacker/pulls)

## ❤️ 支持项目

如果 TaxHacker 帮助你节省了时间或更好地管理了财务，请考虑支持其持续开发！你的捐赠帮助我们维护项目、添加新功能并保持其免费和开源。每一份贡献都有助于确保我们可以继续为社区改进和维护这个工具。

[![感谢 TaxHacker 开发者](https://img.shields.io/badge/❤️-donate%20to%20Taxhacker%20devs-f08080?labelColor=black&style=for-the-badge)](https://vas3k.com/donate/)

## 📄 许可

TaxHacker 采用 [MIT 许可证](LICENSE) 授权。

---

[English](README.en.md) | 中文
