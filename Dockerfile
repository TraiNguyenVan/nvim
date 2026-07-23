FROM alpine:latest

# 1. Set environment variables
ENV XDG_CONFIG_HOME=/root/.config \
    XDG_DATA_HOME=/root/.local/share

WORKDIR /workspace

# 2. Copy config into the image
COPY . /root/.config/nvim

# 3. Single-layer install, headless plugin sync, and deep cleanup
RUN apk update && apk add --no-cache \
        neovim \
        git \
        build-base \
        fzf \
        lazygit \
    # Sync and install all Neovim plugins headlessly during build
    && nvim --headless -c "Lazy! sync" -c "qa!" \
    # Deep Cleanup (removes hidden git history & caches while keeping all compiled plugins & LSPs intact)
    && find /root/.local/share/nvim/lazy -name ".git" -type d -exec rm -rf {} + \
    && find /root/.local/share/nvim/lazy -type d \( -name "tests" -o -name "doc" -o -name "examples" \) -exec rm -rf {} + \
    && rm -rf /var/cache/apk/* /tmp/* /root/.cache/*

ENTRYPOINT ["nvim"]
