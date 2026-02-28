FROM node:22-bookworm

RUN corepack enable

WORKDIR /app
RUN chown node:node /app

# Install deps
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    build-essential procps curl file git ca-certificates \
    sudo \
    gosu \
    python3 \
    unzip jq ripgrep && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Install playwright chromium deps
RUN npx playwright install-deps chromium

# Prepare to install homebrew
RUN userade --create-home linuxbrew && \
    echo 'linuxbrew ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    usermod -aG linuxbrew node && \
    chmod g+w /home/linuxbrew && \
    chmod g+s /home/linuxbrew

# Copy launch script
COPY ./launch.sh /usr/local/bin/launch.sh
RUN chmod +x /usr/local/bin/launch.sh


USER node
WORKDIR /home/node

RUN npm config set prefix '/app'
ENV PATH="/app/bin:${PATH}"

# Install homebrew
RUN NONINTERACTIVE=1 curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH}"

# Install openclaw
RUN npm install -g openclaw@2026.2.26
RUN npm install -g playwright && node /app/lib/node_modules/playwright/cli.js install chromium

# Install plugin
RUN mkdir -p /home/node/.openclaw/extensions
# QQ bot
RUN openclaw plugins install @sliverp/qqbot@latest
# Fei Shu
RUN openclaw plugins enable feishu

EXPOSE 18789 18790
ENTRYPOINT ["/bin/bash", "/usr/local/bin/launch.sh"]
