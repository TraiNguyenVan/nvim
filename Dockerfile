FROM alpine:latest

# 1. Install system dependencies (compilers, git, fzf, lazygit, neovim)
RUN apk update && apk add --no-cache \
    neovim \
    git \
    build-base \
    fzf \
    lazygit \
    bash

# 2. Set up workspace directory and standard non-root user
WORKDIR /workspace

# 3. Copy the Neovim configuration into the container
COPY . /root/.config/nvim

# 4. Pre-download/bake all Neovim plugins during the build phase
# (This runs headless and exits once all plugins are synced so runtime is instant)
RUN nvim --headless -c "Lazy! sync" -c "qa!"

# 5. Launch Neovim directly when starting the container
ENTRYPOINT ["nvim"]
