FROM node:21-slim

# Update and install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /workspace

# Copy package.json and install dependencies
# This step can be modified based on your specific project needs
COPY package.json ./
COPY .devcontainer/start-sync.sh ./
RUN npm install