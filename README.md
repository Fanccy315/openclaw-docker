# OpenClaw Docker 模板

> [OpenClaw](https://github.com/openclaw/openclaw) 的 Docker 模板，预装了常用插件。Fork 本仓库即可自定义你的 OpenClaw 容器。

[![License: MIT](https://img.shshield.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 特性

- 基于 Node.js 22，安装了最新版 OpenClaw
- 预装插件：
  - QQ Bot (@sliverp/qqbot)
  - 飞书 (Feishu/Lark 集成)
- 集成 Homebrew 用于额外软件包管理
- 提供即用型 docker-compose 示例

## 快速开始

### 1. Fork 本仓库

将本仓库 Fork 到你自己的 GitHub 账号，创建你自己的版本。

### 2. 自定义 Dockerfile

编辑 `Dockerfile` 来添加或删除：
- 预安装的软件包
- OpenClaw 插件
- Node.js 依赖
- 任何其他自定义配置

例如，要添加一个新插件：

```dockerfile
RUN openclaw plugins install @your/plugin@latest
```

### 3. 构建镜像

方式 A：本地构建
```bash
docker build -t openclaw:your-tag .
```

方式 B：使用 GitHub Actions（见 [GitHub Actions](#github-actions) 章节）

### 4. 使用 Docker Compose 运行

复制 `example/docker-compose.yml` 文件并进行自定义：

```bash
cp example/docker-compose.yml docker-compose.yml
```

编辑 `.env` 文件或修改 `docker-compose.yml` 中的环境变量：

```yaml
environment:
  OPENCLAW_IMAGE: openclaw:your-tag
  OPENCLAW_HOME: /path/to/your/config
  TZ: Your/Timezone
```

然后启动容器：

```bash
docker compose up -d gateway
```

## 重要提示

### Homebrew 镜像配置

示例 `docker-compose.yml` 配置了中科大（USTC）的 Homebrew 镜像。如果你不在中国大陆或想使用其他镜像源，请移除或修改这些环境变量：

```yaml
environment:
  HOMEBREW_BREW_GIT_REMOTE: https://mirrors.ustc.edu.cn/brew.git
  HOMEBREW_API_DOMAIN: https://mirrors.ustc.edu.cn/homebrew-bottles/api
  HOMEBREW_BOTTLE_DOMAIN: https://mirrors.ustc.edu.cn/homebrew-bottles
```

### 初始化配置（Onboarding）

首次运行 OpenClaw 时，需要完成初始化配置：

1. **启动临时 CLI 容器**（因为 onboarding 会修改 `openclaw.json`，导致 gateway 重启）：

```bash
docker compose run --rm cli
```

2. **在 CLI 容器内运行初始化向导**：

```bash
openclaw gateway onboard
```

3. **重要**：当提示选择绑定模式（bind mode）时，请选择 **`lan`** 以确保正确的网络配置。

4. 初始化完成后，gateway 会自动重启。

5. 完成后退出 CLI 容器。

### 设备配对

⚠️ **重要**：设备配对（用于移动节点、相机访问等）必须在 gateway 容器上执行，**不能**使用 CLI 容器。CLI 容器无法访问所需的网络接口。

配对设备的步骤：

1. 进入 gateway 容器的 shell：

```bash
docker compose exec gateway bash
```

2. 运行配对命令：

```bash
openclaw gateway pairing
```

3. 按照屏幕提示完成配对。

## GitHub Actions

本仓库包含 GitHub Actions 工作流，用于自动构建和部署镜像。

### 构建镜像

当 `version.txt` 更新时，工作流会自动触发：

1. 在 `version.txt` 中更新版本号
2. 提交并推送以触发构建

### 部署到你的服务器

要使用自动部署任务（Push Image to Server），需要配置以下 GitHub 仓库密钥（secrets）：

| 密钥名称 | 描述 |
|---------|------|
| `SSH_HOST` | 你的服务器 IP 地址或主机名 |
| `SSH_PORT` | SSH 端口（默认：22） |
| `SSH_USERNAME` | SSH 用户名 |
| `SSH_PRIVATE_KEY` | 用于认证的 SSH 私钥 |
| `IMAGE_DIR_PATH` | 服务器上存放镜像文件的目标目录路径 |

工作流程示例：
1. 在 `version.txt` 中更新版本号
2. 推送到 `main` 分支
3. GitHub Actions 构建镜像
4. 镜像上传到你的服务器
5. 服务器上的 Docker Compose 自动更新 gateway 容器

## 容器架构

示例 docker-compose 包含两个服务：

- **gateway**：主要的 OpenClaw gateway 服务（持久运行）
- **cli**：临时 CLI 容器，用于执行 OpenClaw 命令（按需使用）

关键卷映射：
- `/home/node/.openclaw` → 你的 OpenClaw 配置目录
- `/home/node/.openclaw/extensions` → 匿名卷（使用镜像中预装的插件）

## 自定义建议

- 在 `Dockerfile` 中添加你喜欢的插件
- 安装额外的开发工具（vim、nano、htop 等）
- 配置自定义时区和语言环境
- 添加监控工具（Prometheus exporter 等）
- 设置日志聚合

## 许可证

[MIT 许可证](LICENSE)

## 贡献

如果你发现 Bug 或有改进建议，欢迎提交 Issue 和 Pull Request。

## 支持

关于 OpenClaw 的相关问题，请访问：
- [OpenClaw 文档](https://docs.openclaw.ai)
- [OpenClaw GitHub 仓库](https://github.com/openclaw/openclaw)
- [OpenClaw 社区 Discord](https://discord.gg/clawd)
