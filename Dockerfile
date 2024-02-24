FROM node:21-slim

RUN apt-get update && apt-get install -y \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Check if the project already has a .vscode folder and if not, copy the included .vscode folder to the root of the project
COPY .vscode /root/.vscode
WORKDIR /workspace
RUN if [ ! -d "./.vscode" ]; then \
        cp -r /root/.vscode ./; \
    fi

COPY package.json ./