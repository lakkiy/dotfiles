#!/usr/bin/env zsh
# lib/utils.sh — Logging, colors, and helper utilities

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

log_info()    { echo -e "${GREEN}==>${NC} ${BOLD}$*${NC}"; }
log_warn()    { echo -e "${YELLOW}==> WARN:${NC} $*"; }
log_error()   { echo -e "${RED}==> ERROR:${NC} $*" >&2; }
log_section() { echo -e "\n${BLUE}${BOLD}--- $* ---${NC}"; }
log_dry()     { echo -e "${YELLOW}[dry-run]${NC} $*"; }

# Run or print depending on DRY_RUN flag
run() {
    if [[ "${DRY_RUN:-}" == "1" ]]; then
        log_dry "$*"
    else
        "$@"
    fi
}

# Ensure a directory exists
ensure_dir() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        run mkdir -p "$dir"
    fi
}
