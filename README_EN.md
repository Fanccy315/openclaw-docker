# OpenClaw Docker

This is a Docker template project for OpenClaw. You can fork this repository and edit the `Dockerfile` as needed to decide which software packages and plugins to pre-install.

## Features

- Based on official Node.js 22 image
- Pre-installed Playwright Chromium (for browser automation)
- Pre-installed Homebrew (package manager)
- Pre-installed OpenClaw and its plugins (QQ Bot, Feishu, etc.)
- Example `docker-compose.yml` configuration provided

## Quick Start

### 1. Clone or Fork This Repository

```bash
git clone https://github.com/Fanccy315/openclaw-docker.git
cd openclaw-docker
```

### 2. Edit Dockerfile (Optional)

Modify the `Dockerfile` according to your needs to add or remove pre-installed software packages and plugins.

### 3. Build the Image

```bash
docker build -t openclaw .
```

### 4. Configure and Start

```bash
cd example
cp .env.example .env  # Edit .env file if needed
docker compose up -d
```

## Important Notes

### Homebrew Mirror Configuration

The `example/docker-compose.yml` is configured with the USTC (University of Science and Technology of China) Homebrew mirror by default:

```yaml
environment:
  HOMEBREW_BREW_GIT_REMOTE: https://mirrors.ustc.edu.cn/brew.git
  HOMEBREW_API_DOMAIN: https://mirrors.ustc.edu.cn/homebrew-bottles/api
  HOMEBREW_BOTTLE_DOMAIN: https://mirrors.ustc.edu.cn/homebrew-bottles
```

Please change it according to your geographic location.

### First-Time Initialization (Onboarding)

For first-time use, execute the OpenClaw initialization process:

#### 1. Use the CLI Container for Onboarding

```bash
docker compose run --rm cli onboard
```

> **Why use the CLI container?**
>
> The `onboard` command modifies the `openclaw.json` configuration file during execution, which may cause the gateway container to restart automatically. To avoid interruption, we use a temporary CLI container to perform initialization.

#### 2. Select Bind Mode
- During the process, please ensure **bind mode is set to `lan`**

### Device Pairing

When performing device pairing (such as mobile nodes, notifications, etc.):

**Do not use the CLI container**. You must run directly on the gateway container:

```bash
docker compose exec gateway openclaw <pairing_command>
```

> **Reason**: Device pairing must run on the local machine (the gateway container) and cannot be shared to the CLI container over the network.

## License

This project is licensed under the [MIT License](LICENSE).

## 中文文档

[中文文档](README.md)
