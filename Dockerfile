FROM alpine:latest

# 1. Set environment variables
ENV XDG_CONFIG_HOME=/root/.config \
    XDG_DATA_HOME=/root/.local/share

WORKDIR /workspace

# 2. Copy config into the image
COPY . /root/.config/nvim

# 3. Single-layer install, headless plugin sync, and extreme micro-pruning
RUN apk update && apk add --no-cache \
        neovim \
        git \
        build-base \
        fzf \
        lazygit \
    # Sync and install all Neovim plugins headlessly during build
    && nvim --headless -c "Lazy! sync" -c "qa!" \
    # Deep Cleanup: removes hidden git history, docs, tests, and caches
    && find /root/.local/share/nvim/lazy -name ".git" -type d -exec rm -rf {} + \
    && find /root/.local/share/nvim/lazy -type d \( -name "tests" -o -name "doc" -o -name "examples" \) -exec rm -rf {} + \
    # Micro-Pruning: remove static libraries, man pages, docs, locales, and strip binaries
    && find /usr/lib /lib -name "*.a" -delete \
    && rm -rf /usr/share/man /usr/share/doc /usr/share/info /usr/share/locale /var/cache/apk/* /tmp/* /root/.cache/* \
    && (strip /usr/bin/nvim /usr/bin/gcc /usr/bin/g++ /usr/bin/git /usr/bin/lazygit 2>/dev/null || true)

ENTRYPOINT ["nvim"]
