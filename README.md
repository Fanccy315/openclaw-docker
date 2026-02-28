# OpenClaw Docker

这是一个用于 OpenClaw 的 Docker 模板项目，你可以 fork 本仓库并根据需求自行编辑 `Dockerfile`，决定预安装哪些软件包、插件等等。

## 功能特点

- 基于 Node.js 22 官方镜像
- 预装 Playwright Chromium（用于浏览器自动化）
- 预装 Homebrew（包管理器）
- 预装 OpenClaw 及其插件（QQ Bot、飞书等）
- 提供 `docker-compose.yml` 示例配置

## GitHub Actions 自动构建

本仓库已配置 GitHub Actions 工作流，可自动构建并部署 Docker 镜像到服务器。

### 触发构建

构建会在以下情况触发：
- 修改 `version.txt` 文件并推送到 `main` 分支
- 手动触发（在 GitHub Actions 页面选择 `workflow_dispatch`）

### 配置 Secrets（用于自动部署）

如需使用 `Push Image to Server` 功能，需要在仓库设置中配置以下 Secrets：

| Secret 名称 | 说明 | 示例 |
|-----------|------|------|
| `IMAGE_DIR_PATH` | 服务器上镜像保存的目录路径 | `/path/to/docker/images` |
| `SSH_HOST` | SSH 服务器地址 | `192.168.1.100` 或 `example.com` |
| `SSH_PORT` | SSH 端口 | `22` |
| `SSH_USERNAME` | SSH 用户名 | `root` 或 `ubuntu` |
| `SSH_PRIVATE_KEY` | SSH 私钥（完整内容） | `-----BEGIN OPENSSH PRIVATE KEY-----\\n...` |

配置路径：`Settings` → `Secrets and variables` → `Actions` → `New repository secret`

### 工作流说明

工作流包含两个 Job：
1. **Build**: 构建 Docker 镜像并导出为 `.tar` 文件
2. **Deploy**: 将镜像上传到服务器并自动重启 docker compose


## 快速开始

### 1. 克隆或 Fork 本仓库

```bash
git clone https://github.com/Fanccy315/openclaw-docker.git
cd openclaw-docker
```

### 2. 编辑 Dockerfile（可选）

根据你的需求修改 `Dockerfile`，添加或删除需要预安装的软件包和插件。

### 3. 构建镜像

```bash
docker build -t openclaw .
```

### 4. 配置并启动

```bash
cd example
cp .env.example .env  # 如有需要，编辑 .env 文件
docker compose up -d
```

## 注意事项

### Homebrew 镜像配置

`example/docker-compose.yml` 中默认配置了中科大（USTC）的 Homebrew 镜像源：

```yaml
environment:
  HOMEBREW_BREW_GIT_REMOTE: https://mirrors.ustc.edu.cn/brew.git
  HOMEBREW_API_DOMAIN: https://mirrors.ustc.edu.cn/homebrew-bottles/api
  HOMEBREW_BOTTLE_DOMAIN: https://mirrors.ustc.edu.cn/homebrew-bottles
```

请根据你的地理位置自行更改。

### 首次初始化（Onboarding）

首次使用时，需要执行 OpenClaw 的初始化流程：

#### 1. 使用 CLI 容器执行 onboard

```bash
docker compose run --rm cli onboard
```

> **为什么使用 CLI 容器？**
>
> `onboard` 命令执行时会中途修改 `openclaw.json` 配置文件，这可能导致 gateway 容器自动重启。为了避免中断，我们使用临时 CLI 容器来执行初始化。

#### 2. 选择 bind 模式
- 在执行过程中，请注意 **bind 模式选择 `lan`**

### 设备配对

进行设备配对（如手机节点、通知等）时：

**不能使用 CLI 容器**，必须直接在 gateway 容器上运行：

```bash
docker compose exec gateway openclaw <配对命令>
```

> **原因**：设备配对只能在本机（运行 gateway 的容器）上运行，无法通过网络共享到 CLI 容器。

## 许可证

本项目采用 [MIT License](LICENSE) 开源协议。

## 英文文档

[English Documentation](README_EN.md)
