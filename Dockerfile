FROM node:22-bookworm

RUN corepack enable

WORKDIR /app
RUN chown node:node /app

# Install deps
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    build-essential procps curl file git \
    sudo \
    gosu \
    python3 \
    unzip
RUN rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Update npm
RUN npm install -g npm@latest

# Install playwright chromium deps
RUN npx playwright install-deps chromium

# Install homebrew
RUN useradd --create-home linuxbrew
USER linuxbrew
RUN echo 'linuxbrew ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN NONINTERACTIVE=1 curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH}"


USER node
WORKDIR /home/node

RUN npm config set prefix '/app'
ENV PATH="/app/bin:${PATH}"

# Install openclaw
RUN npm install -g openclaw@latest
RUN npm install -g playwright && npx playwright install chromium
RUN npm install -g playwright-extra puppeteer-extra-plugin-stealth

# Install plugin-Xueheng-Li/openclaw-wechat
RUN mkdir -p /home/node/.openclaw/extensions && \
    cd /home/node/.openclaw/extensions && \
    git clone https://github.com/Xueheng-Li/openclaw-wechat.git && \
    cd openclaw-wechat && \
    npm install && \
    openclaw plugins install -l .

COPY ./launch.sh /usr/local/bin/launch.sh
RUN chmod +x /usr/local/bin/launch.sh

EXPOSE 18789 18790
ENTRYPOINT ["/bin/bash", "/usr/local/bin/launch.sh"]
