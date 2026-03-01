# OpenClaw Docker Template

> A Docker template for [OpenClaw](https://github.com/openclaw/openclaw) with pre-installed plugins. Fork this repository to customize your own OpenClaw container.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Features

- Based on Node.js 22 with latest OpenClaw installed
- Pre-installed plugins:
  - QQ Bot (@sliverp/qqbot)
  - Feishu (Feishu/Lark integration)
- Homebrew for additional package management
- Ready-to-use docker-compose example

## Quick Start

### 1. Fork This Repository

Fork this repository to your own GitHub account to create your own version.

### 2. Customize Your Dockerfile

Edit `Dockerfile` to add or remove:
- Pre-installed software packages
- OpenClaw plugins
- Node.js dependencies
- Any other customizations

For example, to add a new plugin:

```dockerfile
RUN openclaw plugins install @your/plugin@latest
```

### 3. Build the Image

Option A: Build locally
```bash
docker build -t openclaw:your-tag .
```

Option B: Use GitHub Actions (see [GitHub Actions](#github-actions) section)

### 4. Run with Docker Compose

Copy the `example/docker-compose.yml` file and customize it:

```bash
cp example/docker-compose.yml docker-compose.yml
```

Edit the `.env` file or modify environment variables in `docker-compose.yml`:

```yaml
environment:
  OPENCLAW_IMAGE: openclaw:your-tag
  OPENCLAW_HOME: /path/to/your/config
  TZ: Your/Timezone
```

Then start the container:

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

### Initial Setup (Onboarding)

When running OpenClaw for the first time, you need to complete the onboarding process:

1. **Start a temporary CLI container** (because onboarding modifies `openclaw.json`, which causes the gateway to restart):

```bash
docker compose run --rm cli
```

2. **Run the onboarding wizard** inside the CLI container:

```bash
openclaw gateway onboard
```

3. **Important**: When prompted for the bind mode, select **`lan`** for proper networking.

4. After onboarding completes, the gateway will restart automatically.

5. Exit the CLI container when done.

### Device Pairing

⚠️ **Important**: Device pairing (for mobile nodes, camera access, etc.) must be performed on the gateway container itself, **NOT** the CLI container. The CLI container doesn't have access to the required network interfaces.

To pair a device:

1. Start a shell in the gateway container:

```bash
docker compose exec gateway bash
```

2. Run the pairing command:

```bash
openclaw gateway pairing
```

3. Follow the on-screen instructions to complete pairing.

## GitHub Actions

This repository includes a GitHub Actions workflow for automatic image building and deployment.

### Building the Image

The workflow triggers when `version.txt` is updated:

1. Update the version in `version.txt`
2. Commit and push to trigger the build

### Deploying to Your Server

To use the automatic deployment job (`Push Image to Server`), configure the following GitHub repository secrets:

| Secret Name | Description |
|-------------|-------------|
| `SSH_HOST` | Your server's IP address or hostname |
| `SSH_PORT` | SSH port (default: 22) |
| `SSH_USERNAME` | SSH username |
| `SSH_PRIVATE_KEY` | SSH private key for authentication |
| `IMAGE_DIR_PATH` | Target directory path on your server for the image file |

Example workflow:
1. Update `version.txt` with the new version
2. Push to the `main` branch
3. GitHub Actions builds the image
4. The image is uploaded to your server
5. Docker Compose on your server automatically updates the gateway container

## Container Architecture

The example docker-compose includes two services:

- **gateway**: The main OpenClaw gateway service (persistent)
- **cli**: A temporary CLI container for running OpenClaw commands (on-demand)

Key volume mappings:
- `/home/node/.openclaw` → Your OpenClaw configuration directory
- `/home/node/.openclaw/extensions` → Anonymous volume (uses pre-installed plugins from image)

## Customization Ideas

- Add your favorite plugins to `Dockerfile`
- Install additional development tools (vim, nano, htop, etc.)
- Configure custom time zones and locales
- Add monitoring tools (Prometheus exporters, etc.)
- Set up log aggregation

## License

[MIT License](LICENSE)

## Contributing

Feel free to submit issues and pull requests if you find bugs or have suggestions for improvements.

## Support

For OpenClaw-related questions, visit:
- [OpenClaw Documentation](https://docs.openclaw.ai)
- [OpenClaw GitHub Repository](https://github.com/openclaw/openclaw)
- [OpenClaw Community Discord](https://discord.gg/clawd)
