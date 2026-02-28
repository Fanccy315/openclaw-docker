# OpenClaw Docker

这是一个用于 OpenClaw 的 Docker 模板项目，你可以 fork 本仓库并根据需求自行编辑 `Dockerfile`，决定预安装哪些软件包、插件等等。

## 功能特点

- 基于 Node.js 22 官方镜像
- 预装 Playwright Chromium（用于浏览器自动化）
- 预装 Homebrew（包管理器）
- 预装 OpenClaw 及其插件（QQ Bot、飞书等）
- 提供 `docker-compose.yml` 示例配置

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
