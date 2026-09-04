# =============================================================================
# Slim & Complete LazyVim — Alpine-based, full features, low size
# Keeps EVERY feature working: clangd, gdb, python, lazygit, stylua, fzf, rg, fd
# Target: ~550-700 MB (vs 2.09 GB Debian fullsize, vs 394 MB old minimal)
# =============================================================================
FROM alpine:latest

LABEL maintainer="heodocker" \
      description="Slim LazyVim for C/C++/Python — Alpine, full toolchain, baked plugins" \
      org.opencontainers.image.source="https://github.com/TraiNguyenVan/nvim"

ENV XDG_CONFIG_HOME=/root/.config \
    XDG_DATA_HOME=/root/.local/share \
    XDG_STATE_HOME=/root/.local/state \
    XDG_CACHE_HOME=/root/.cache \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

WORKDIR /workspace

# Copy config first (better layer caching if only workspace changes)
COPY . /root/.config/nvim

# ─────────────────────────────────────────────────────────────────────────────
# Single-layer install + plugin bake + light cleanup
# - Uses Alpine apk (neovim 0.12.2, lazygit 0.48, stylua 2.5.2, ripgrep, fd, fzf)
# - Keeps full toolchain; only prunes lazy .git / tests / docs & apk/pip caches
# - NO binary stripping, NO *.a deletion — DAP/LSP keeps working
# ─────────────────────────────────────────────────────────────────────────────
RUN apk update && apk add --no-cache \
        # ── Core ─────────────────────────────────────────────────────────
        neovim \
        git \
        git-lfs \
        openssh-client \
        curl \
        wget \
        unzip \
        zip \
        tar \
        gzip \
        ca-certificates \
        bash \
        zsh \
        sudo \
        # ── C/C++ toolchain ──────────────────────────────────────────────
        build-base \
        cmake \
        ninja \
        pkgconfig \
        gdb \
        clang \
        clang-extra-tools \
        bear \
        valgrind \
        # ── Python ───────────────────────────────────────────────────────
        python3 \
        py3-pip \
        python3-dev \
        # ── Node (for markdown/ts LSPs) ──────────────────────────────────
        nodejs \
        npm \
        # ── Search / TUI helpers (LazyVim deps) ──────────────────────────
        ripgrep \
        fd \
        fzf \
        tree \
        less \
        jq \
        htop \
        ncurses-terminfo \
        # ── Formatters / linters ─────────────────────────────────────────
        shellcheck \
        shfmt \
        stylua \
        lazygit \
        # ── File watching ────────────────────────────────────────────────
        inotify-tools \
        entr \
    # Python tools (no cache to keep size low, but keep functionality)
    && pip3 install --no-cache-dir --break-system-packages \
        flake8 \
        black \
        isort \
        debugpy \
        pynvim \
    || pip3 install --no-cache-dir flake8 black isort debugpy pynvim \
    # Sanity: verify toolchain present (fail early if apk renamed)
    && nvim --version | head -1 \
    && clangd --version | head -1 \
    && gdb --version | head -1 \
    && rg --version | head -1 \
    && fzf --version | head -1 \
    && lazygit --version | head -1 \
    && stylua --version | head -1 \
    && python3 --version \
    # Bake ALL Lazy plugins headlessly so container starts instantly
    && nvim --headless -c "Lazy! sync" -c "qa" \
    && echo "Lazy plugins baked successfully" \
    # Light pruning ONLY: remove lazy .git + tests/docs/examples (keeps compiled plugins)
    && find /root/.local/share/nvim/lazy -name ".git" -type d -exec rm -rf {} + 2>/dev/null || true \
    && find /root/.local/share/nvim/lazy -type d \( -name "tests" -o -name "test" -o -name "doc" -o -name "docs" -o -name "examples" -o -name ".github" \) -exec rm -rf {} + 2>/dev/null || true \
    # Drop apk + pip + tmp caches (biggest size win, zero feature loss)
    && rm -rf /var/cache/apk/* /tmp/* /root/.cache/* /root/.local/state/* 2>/dev/null || true \
    && ls -lh /root/.local/share/nvim/lazy 2>/dev/null | head -30 || true

ENTRYPOINT ["nvim"]
CMD []

# Usage:
#   docker build -t nvim-cpp-env .
#   docker run -it --rm -v $(pwd):/workspace nvim-cpp-env
#   docker run -it --rm -v $(pwd):/workspace nvim-cpp-env file.cpp
#   ./docker-run.sh -- file.cpp
