# OpenClaw Docker 模板

> [OpenClaw](https://github.com/openclaw/openclaw) 的 Docker 模板，预装了常用插件。Fork 本仓库即可自定义你的 OpenClaw 容器。

[English](README_EN.md)

## 特性

- 基于 Node.js 22，安装了最新版 OpenClaw
- 预装插件：
  - QQ Bot (@sliverp/qqbot)
  - 飞书 (Feishu/Lark 内置)
- 集成 Homebrew 用于额外软件包管理
- 提供即用型 docker-compose 示例

## 快速开始

### 1. 复刻本仓库

Fork，或者Clone：

```bash
git clone https://github.com/Fanccy315/openclaw-docker.git
cd openclaw-docker
```

### 2. 自定义 Dockerfile

编辑 `Dockerfile` 来添加或删除插件或软件包。

### 3. 构建镜像

方式 A：本地构建

```bash
docker build -t openclaw:your-tag .
```

方式 B：使用 GitHub Actions（见 [GitHub Actions](#github-actions) 章节）

### 4. 使用 Docker Compose 运行

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

### 初始化配置

首次运行 OpenClaw 前，需要完成初始化配置：

1. 在临时 CLI 容器内执行初始化：

```bash
docker compose run --rm cli onboard --no-install-daemon
```

2. 当提示选择绑定模式（bind mode）时，请选择 **`lan`** 以确保正确的网络配置。

> 使用 CLI 容器是因为初始化中途会多次修改 `openclaw.json`，导致 gateway 容器自动重启。

### 设备配对

设备配对必须在 gateway 容器上执行：

1. 进入 gateway 容器的 shell：

```bash
docker exec -u node -it openclaw-gateway-1 /bin/bash
```

2. 获取请求id：

```bash
openclaw devices list
```

3. 配对设备

```bash
openclaw devices approve <request id>
```

> 不使用 CLI 容器是因为设备配对只能在本机（gateway 容器）上运行

## GitHub Actions

本仓库包含 GitHub Actions 工作流，用于自动构建和部署镜像。

### 构建镜像

当 `version.txt` 更新时，工作流会自动触发：

1. 在 `version.txt` 中更新版本号
2. 提交并推送以触发构建

你也可以手动触发该工作流。

### 部署到你的服务器

要使用自动部署任务，需要配置以下 GitHub 仓库密钥（Actions secrets）：

| 密钥名称          | 描述                               |
| ----------------- | ---------------------------------- |
| `SSH_HOST`        | 你的服务器 IP 地址或主机名         |
| `SSH_PORT`        | SSH 端口（默认：22）               |
| `SSH_USERNAME`    | SSH 用户名                         |
| `SSH_PRIVATE_KEY` | 用于认证的 SSH 私钥                |
| `IMAGE_DIR_PATH`  | 服务器上存放镜像文件的目标目录路径 |

## 容器架构

示例 docker-compose 包含两个服务：

- **gateway**：主要的 OpenClaw gateway 服务（持久运行）
- **cli**：临时 CLI 容器，用于执行 OpenClaw 命令（按需使用）

关键卷映射：

- `/home/node/.openclaw` → 你的 OpenClaw 配置目录
- `/home/node/.openclaw/extensions` → 匿名卷（使用镜像中预装的插件）

## 许可证

[MIT](LICENSE)

## 贡献

如果你发现 Bug 或有改进建议，欢迎提交 Issue 和 Pull Request。

## 支持

关于 OpenClaw 的相关问题，请访问：

- [OpenClaw 文档](https://docs.openclaw.ai)
- [OpenClaw GitHub 仓库](https://github.com/openclaw/openclaw)
- [OpenClaw 社区 Discord](https://discord.gg/clawd)
