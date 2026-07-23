#!/usr/bin/env bash

# Stop on error
set -e

IMAGE_NAME="nvim-cpp-env"

echo "🔨 Building the lightweight Neovim Docker image..."
docker build -t "$IMAGE_NAME" .

echo "🚀 Launching containerized Neovim..."
echo "📂 Mounting current host directory to /workspace"

# Runs the container interactively, mounts the current working directory, and removes container on exit
docker run -it --rm \
    -v "$(pwd):/workspace" \
    "$IMAGE_NAME"
