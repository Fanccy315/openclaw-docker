# OpenClaw Docker Template

> A Docker template for [OpenClaw](https://github.com/openclaw/openclaw) with pre-installed plugins. Fork this repository to customize your own OpenClaw container.

[中文](README.md)

## Features

- Based on Node.js 22 with latest OpenClaw installed
- Pre-installed plugins:
  - QQ Bot (@sliverp/qqbot)
  - Feishu (Feishu/Lark built-in)
- Homebrew for additional package management
- Ready-to-use docker-compose example

## Quick Start

### 1. Fork This Repository

Fork, or Clone:

```bash
git clone https://github.com/Fanccy315/openclaw-docker.git
cd openclaw-docker
```

### 2. Customize Your Dockerfile

Edit `Dockerfile` to add or remove plugins or software packages.

### 3. Build the Image

Option A: Build locally

```bash
docker build -t openclaw:your-tag .
```

Option B: Use GitHub Actions (see [GitHub Actions](#github-actions) section)

### 4. Run with Docker Compose

```bash
docker compose up -d gateway
```

## Important Notes

### Homebrew Mirror Configuration

The example `docker-compose.yml` is configured with USTC mirrors for Homebrew. If you're not in China or prefer different mirrors, remove or modify these environment variables:

```yaml
environment:
  HOMEBREW_BREW_GIT_REMOTE: https://mirrors.ustc.edu.cn/brew.git
  HOMEBREW_API_DOMAIN: https://mirrors.ustc.edu.cn/homebrew-bottles/api
  HOMEBREW_BOTTLE_DOMAIN: https://mirrors.ustc.edu.cn/homebrew-bottles
```

### Initial Setup

Before running OpenClaw for the first time, complete the initial setup:

1. Run initial setup in a temporary CLI container:

```bash
docker compose run --rm cli onboard --no-install-daemon
```

2. When prompted for the bind mode, select **`lan`** for proper networking.

> Use the CLI container because the setup process modifies `openclaw.json` multiple times, causing the gateway container to restart automatically.

### Device Pairing

Device pairing must be performed on the gateway container:

1. Enter the gateway container shell:

```bash
docker exec -u node -it openclaw-gateway-1 /bin/bash
```

2. Get the request id:

```bash
openclaw devices list
```

3. Approve the device

```bash
openclaw devices approve <request id>
```

> Do not use the CLI container because device pairing can only run on the local machine (gateway container).

## GitHub Actions

This repository includes a GitHub Actions workflow for automatic image building and deployment.

### Building the Image

The workflow triggers when `version.txt` is updated:

1. Update the version in `version.txt`
2. Commit and push to trigger the build

You can also manually trigger this workflow.

### Deploying to Your Server

To use the automatic deployment job, configure the following GitHub repository secrets (Actions secrets):

| Secret Name       | Description                                                  |
| ----------------- | ------------------------------------------------------------ |
| `SSH_HOST`        | Your server's IP address or hostname                        |
| `SSH_PORT`        | SSH port (default: 22)                                      |
| `SSH_USERNAME`    | SSH username                                                |
| `SSH_PRIVATE_KEY` | SSH private key for authentication                          |
| `IMAGE_DIR_PATH`  | Target directory path on your server for the image file     |

## Container Architecture

The example docker-compose includes two services:

- **gateway**: The main OpenClaw gateway service (persistent)
- **cli**: A temporary CLI container for running OpenClaw commands (on-demand)

Key volume mappings:

- `/home/node/.openclaw` → Your OpenClaw configuration directory
- `/home/node/.openclaw/extensions` → Anonymous volume (uses pre-installed plugins from image)

## License

[MIT](LICENSE)

## Contributing

Feel free to submit issues and pull requests if you find bugs or have suggestions for improvements.

## Support

For OpenClaw-related questions, visit:

- [OpenClaw Documentation](https://docs.openclaw.ai)
- [OpenClaw GitHub Repository](https://github.com/openclaw/openclaw)
- [OpenClaw Community Discord](https://discord.gg/clawd)
