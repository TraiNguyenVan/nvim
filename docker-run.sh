#!/usr/bin/env bash
# Fullsize LazyVim runner — auto-detects docker / podman, handles SELinux, TTY, and workspace mount.
set -e

IMAGE_NAME="${IMAGE_NAME:-nvim-cpp-env}"
DOCKERFILE="${DOCKERFILE:-Dockerfile}"
WORKSPACE_DIR="${WORKSPACE_DIR:-$(pwd)}"

# ── Detect runtime ──────────────────────────────────────────────────────────
if command -v podman &>/dev/null && command -v docker &>/dev/null; then
    # Prefer podman on Fedora / systems where both exist, unless DOCKER env forces docker
    if [[ "${CONTAINER_RUNTIME:-}" == "docker" ]]; then
        RUNTIME="docker"
    else
        RUNTIME="podman"
    fi
elif command -v podman &>/dev/null; then
    RUNTIME="podman"
elif command -v docker &>/dev/null; then
    RUNTIME="docker"
else
    echo "Error: neither 'docker' nor 'podman' found in PATH." >&2
    exit 1
fi

# ── Flags ───────────────────────────────────────────────────────────────────
BUILD=1
PULL=0
NO_CACHE=0
EXTRA_ARGS=()

usage() {
    cat <<EOF
Usage: $(basename "$0") [options] [-- nvim_args...]

Options:
  --no-build      Skip docker build, just run existing image
  --rebuild       Force rebuild without cache
  --pull          Pull base image before build
  --podman        Force podman runtime
  --docker        Force docker runtime
  -h, --help      Show this help

Env:
  IMAGE_NAME      Image name (default: nvim-cpp-env)
  CONTAINER_RUNTIME  Force runtime: docker|podman

Examples:
  ./docker-run.sh
  ./docker-run.sh -- file.cpp
  ./docker-run.sh --no-build -- main.cpp
  IMAGE_NAME=my-nvim ./docker-run.sh
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --no-build) BUILD=0; shift ;;
        --rebuild) NO_CACHE=1; shift ;;
        --pull) PULL=1; shift ;;
        --podman) RUNTIME="podman"; shift ;;
        --docker) RUNTIME="docker"; shift ;;
        -h|--help) usage; exit 0 ;;
        --) shift; EXTRA_ARGS+=("$@"); break ;;
        -*) echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
        *) EXTRA_ARGS+=("$1"); shift ;;
    esac
done

# ── SELinux / volume suffix ─────────────────────────────────────────────────
VOL_SUFFIX=""
if [[ "$RUNTIME" == "podman" ]]; then
    # Podman on Fedora needs :Z to relabel; Docker ignores it but warns, so only add for podman
    VOL_SUFFIX=":Z"
fi

# ── Build ───────────────────────────────────────────────────────────────────
if [[ "$BUILD" -eq 1 ]]; then
    echo "🔨 Building FULLSIZE Neovim image with ${RUNTIME}..."
    echo "   Image: ${IMAGE_NAME}"
    echo "   Context: ${WORKSPACE_DIR}"
    BUILD_ARGS=()
    [[ "$NO_CACHE" -eq 1 ]] && BUILD_ARGS+=(--no-cache)
    [[ "$PULL" -eq 1 ]] && BUILD_ARGS+=(--pull)
    $RUNTIME build "${BUILD_ARGS[@]}" -f "${DOCKERFILE}" -t "${IMAGE_NAME}" "${WORKSPACE_DIR}"
fi

# ── Run ─────────────────────────────────────────────────────────────────────
echo "🚀 Launching containerized Neovim (${RUNTIME})..."
echo "📂 Mounting ${WORKSPACE_DIR} → /workspace${VOL_SUFFIX}"

# Ensure TTY; fallback to non-TTY if not interactive (e.g. CI)
TTY_ARGS=("-it")
if [[ ! -t 0 ]] || [[ ! -t 1 ]]; then
    TTY_ARGS=("-i")
fi

exec $RUNTIME run --rm "${TTY_ARGS[@]}" \
    -v "${WORKSPACE_DIR}:/workspace${VOL_SUFFIX}" \
    -w /workspace \
    -e TERM="${TERM:-xterm-256color}" \
    -e COLORTERM="${COLORTERM:-truecolor}" \
    "${IMAGE_NAME}" "${EXTRA_ARGS[@]}"
