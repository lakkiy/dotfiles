#!/usr/bin/env zsh
# lib/host-m3air.sh — host-specific extras for m3air

M3AIR_EMACS_TAP="d12frosted/emacs-plus"
M3AIR_EMACS_FORMULA="d12frosted/emacs-plus/emacs-plus@31"
M3AIR_EMACS_INSTALL_ARGS=(
    --with-compress-install
)
M3AIR_EMACS_SOURCE_REPO_URL="https://github.com/emacs-mirror/emacs"
M3AIR_EMACS_SOURCE_BRANCH="feature/igc3"
M3AIR_EMACS_SOURCE_DIR="/opt/homebrew/Library/Taps/d12frosted/homebrew-emacs-plus@31"

M3AIR_EMACS_REPO_URL="https://github.com/lakkiy/.emacs.d"
M3AIR_EMACS_REPO_DIR="${HOME}/.emacs.d"

M3AIR_RIME_REPO_URL="https://github.com/lakkiy/rime.git"
M3AIR_RIME_REPO_DIR="${HOME}/Library/Rime"
M3AIR_RIME_EMACS_COPY_DIR="${M3AIR_EMACS_REPO_DIR}/rime"

_git_repo_origin_url() {
    local repo_dir="$1"
    git -C "$repo_dir" remote get-url origin 2>/dev/null || true
}

_ensure_git_repo() {
    local repo_url="$1"
    local repo_dir="$2"
    local branch="${3:-}"

    if [[ ! -e "$repo_dir" ]]; then
        ensure_dir "$(dirname "$repo_dir")"
        run git clone "$repo_url" "$repo_dir"
    elif [[ ! -d "$repo_dir/.git" ]]; then
        log_warn "Path exists but is not a git repo, skipping: ${repo_dir}"
        return
    fi

    local current_origin
    current_origin="$(_git_repo_origin_url "$repo_dir")"
    if [[ -n "$current_origin" && "$current_origin" != "$repo_url" ]]; then
        log_info "Updating git remote origin: ${repo_dir}"
        run git -C "$repo_dir" remote set-url origin "$repo_url"
    fi

    if [[ -n "$branch" ]]; then
        local current_branch
        current_branch="$(git -C "$repo_dir" branch --show-current 2>/dev/null || true)"
        if [[ "$current_branch" != "$branch" ]]; then
            if git -C "$repo_dir" show-ref --verify --quiet "refs/heads/${branch}"; then
                run git -C "$repo_dir" switch "$branch"
            elif git -C "$repo_dir" ls-remote --exit-code --heads origin "$branch" >/dev/null 2>&1; then
                run git -C "$repo_dir" fetch origin "$branch"
                run git -C "$repo_dir" switch -c "$branch" --track "origin/${branch}"
            else
                log_warn "Branch not found in origin: ${branch} (${repo_dir})"
            fi
        fi
    fi
}

_m3air_tap_path() {
    if command -v brew &>/dev/null; then
        brew --repository "$M3AIR_EMACS_TAP" 2>/dev/null || true
    else
        echo ""
    fi
}

_m3air_formula_short_name() {
    echo "${M3AIR_EMACS_FORMULA##*/}"
}

_m3air_formula_installed() {
    if brew list --formula "$M3AIR_EMACS_FORMULA" >/dev/null 2>&1; then
        return 0
    fi
    brew list --formula "$(_m3air_formula_short_name)" >/dev/null 2>&1
}

_ensure_m3air_emacs_source_checkout() {
    if [[ ! -e "$M3AIR_EMACS_SOURCE_DIR" ]]; then
        ensure_dir "$(dirname "$M3AIR_EMACS_SOURCE_DIR")"
        run git clone --single-branch --branch "$M3AIR_EMACS_SOURCE_BRANCH" \
            "$M3AIR_EMACS_SOURCE_REPO_URL" "$M3AIR_EMACS_SOURCE_DIR"
        if [[ "${DRY_RUN:-}" == "1" ]]; then
            return 0
        fi
    elif [[ ! -d "${M3AIR_EMACS_SOURCE_DIR}/.git" ]]; then
        log_error "Path exists but is not a git repo: ${M3AIR_EMACS_SOURCE_DIR}"
        return 1
    fi

    local current_origin
    current_origin="$(_git_repo_origin_url "$M3AIR_EMACS_SOURCE_DIR")"
    if [[ -n "$current_origin" && "$current_origin" != "$M3AIR_EMACS_SOURCE_REPO_URL" ]]; then
        log_info "Updating Emacs source origin: ${M3AIR_EMACS_SOURCE_DIR}"
        run git -C "$M3AIR_EMACS_SOURCE_DIR" remote set-url origin "$M3AIR_EMACS_SOURCE_REPO_URL"
    fi

    local current_branch
    current_branch="$(git -C "$M3AIR_EMACS_SOURCE_DIR" branch --show-current 2>/dev/null || true)"
    if [[ "$current_branch" != "$M3AIR_EMACS_SOURCE_BRANCH" ]]; then
        if git -C "$M3AIR_EMACS_SOURCE_DIR" show-ref --verify --quiet "refs/heads/${M3AIR_EMACS_SOURCE_BRANCH}"; then
            run git -C "$M3AIR_EMACS_SOURCE_DIR" switch "$M3AIR_EMACS_SOURCE_BRANCH"
        elif git -C "$M3AIR_EMACS_SOURCE_DIR" ls-remote --exit-code --heads origin "$M3AIR_EMACS_SOURCE_BRANCH" >/dev/null 2>&1; then
            run git -C "$M3AIR_EMACS_SOURCE_DIR" fetch origin "$M3AIR_EMACS_SOURCE_BRANCH"
            run git -C "$M3AIR_EMACS_SOURCE_DIR" switch -c "$M3AIR_EMACS_SOURCE_BRANCH" --track "origin/${M3AIR_EMACS_SOURCE_BRANCH}"
        else
            log_error "Branch not found: ${M3AIR_EMACS_SOURCE_BRANCH} (${M3AIR_EMACS_SOURCE_REPO_URL})"
            return 1
        fi
    fi
}

_preview_m3air_emacs_plus_changes() {
    local changed=0

    if ! command -v brew &>/dev/null; then
        echo "  ! Homebrew not found; emacs-plus step will be skipped"
        return 1
    fi

    local taps
    taps="$(brew tap 2>/dev/null || true)"
    if ! echo "$taps" | grep -Fxq "$M3AIR_EMACS_TAP"; then
        echo "  + brew tap ${M3AIR_EMACS_TAP}"
        changed=1
    fi

    if [[ ! -e "$M3AIR_EMACS_SOURCE_DIR" ]]; then
        echo "  + clone ${M3AIR_EMACS_SOURCE_REPO_URL} (${M3AIR_EMACS_SOURCE_BRANCH}) -> ${M3AIR_EMACS_SOURCE_DIR}"
        changed=1
    elif [[ ! -d "${M3AIR_EMACS_SOURCE_DIR}/.git" ]]; then
        echo "  ! ${M3AIR_EMACS_SOURCE_DIR} exists but is not a git repo"
        changed=1
    else
        local src_branch src_origin
        src_branch="$(git -C "$M3AIR_EMACS_SOURCE_DIR" branch --show-current 2>/dev/null || true)"
        src_origin="$(_git_repo_origin_url "$M3AIR_EMACS_SOURCE_DIR")"
        if [[ -n "$src_origin" && "$src_origin" != "$M3AIR_EMACS_SOURCE_REPO_URL" ]]; then
            echo "  ! unexpected source origin: ${src_origin}"
            changed=1
        fi
        if [[ "$src_branch" != "$M3AIR_EMACS_SOURCE_BRANCH" ]]; then
            echo "  ! source branch should be ${M3AIR_EMACS_SOURCE_BRANCH} (current: ${src_branch})"
            changed=1
        fi
    fi

    if ! _m3air_formula_installed; then
        echo "  + brew install ${M3AIR_EMACS_FORMULA} ${M3AIR_EMACS_INSTALL_ARGS[*]}"
        changed=1
    fi

    if (( changed == 0 )); then
        return 0
    fi
    return 1
}

_sync_m3air_emacs_plus() {
    if ! command -v brew &>/dev/null; then
        log_warn "Homebrew not found; skip emacs-plus setup."
        return 1
    fi

    run brew tap "$M3AIR_EMACS_TAP"
    _ensure_m3air_emacs_source_checkout

    if _m3air_formula_installed; then
        log_info "${M3AIR_EMACS_FORMULA} already installed."
    else
        log_info "Installing ${M3AIR_EMACS_FORMULA}..."
        run brew install "$M3AIR_EMACS_FORMULA" "${M3AIR_EMACS_INSTALL_ARGS[@]}"
    fi
}

_preview_m3air_git_repo_changes() {
    local repo_url="$1"
    local repo_dir="$2"
    local branch="${3:-}"
    local changed=0

    if [[ ! -e "$repo_dir" ]]; then
        echo "  + clone ${repo_url} -> ${repo_dir}"
        changed=1
    elif [[ ! -d "$repo_dir/.git" ]]; then
        echo "  ! ${repo_dir} exists but is not a git repo (manual check needed)"
        changed=1
        return 1
    else
        local current_origin
        current_origin="$(_git_repo_origin_url "$repo_dir")"
        if [[ -n "$current_origin" && "$current_origin" != "$repo_url" ]]; then
            echo "  ~ set origin for ${repo_dir} -> ${repo_url}"
            changed=1
        fi
    fi

    if [[ -n "$branch" && -d "$repo_dir/.git" ]]; then
        local current_branch
        current_branch="$(git -C "$repo_dir" branch --show-current 2>/dev/null || true)"
        if [[ "$current_branch" != "$branch" ]]; then
            echo "  ~ switch ${repo_dir} to ${branch}"
            changed=1
        fi
    fi

    if (( changed == 0 )); then
        return 0
    fi
    return 1
}

_preview_m3air_rime_emacs_copy_changes() {
    # Requested behavior: if emacs already has rime config, do not sync again.
    if [[ -d "$M3AIR_RIME_EMACS_COPY_DIR" ]]; then
        return 0
    fi

    if [[ -d "$M3AIR_EMACS_REPO_DIR" || ! -e "$M3AIR_EMACS_REPO_DIR" ]]; then
        if [[ -d "$M3AIR_RIME_REPO_DIR" ]]; then
            echo "  + sync ${M3AIR_RIME_REPO_DIR} -> ${M3AIR_RIME_EMACS_COPY_DIR}"
            return 1
        fi
    fi
    return 0
}

_sync_m3air_config_repos() {
    _ensure_git_repo "$M3AIR_EMACS_REPO_URL" "$M3AIR_EMACS_REPO_DIR"
    _ensure_git_repo "$M3AIR_RIME_REPO_URL" "$M3AIR_RIME_REPO_DIR"

    if [[ -d "$M3AIR_RIME_EMACS_COPY_DIR" ]]; then
        log_info "Existing emacs rime config detected, skip sync: ${M3AIR_RIME_EMACS_COPY_DIR}"
        return
    fi

    if [[ -d "$M3AIR_EMACS_REPO_DIR" && -d "$M3AIR_RIME_REPO_DIR" ]]; then
        ensure_dir "$M3AIR_RIME_EMACS_COPY_DIR"
        log_info "Syncing Rime config into emacs: ${M3AIR_RIME_EMACS_COPY_DIR}"
        run rsync -a --delete --exclude ".git/" "${M3AIR_RIME_REPO_DIR}/" "${M3AIR_RIME_EMACS_COPY_DIR}/"
    else
        log_warn "Skip emacs/rime copy: emacs or Rime directory missing."
    fi
}

preview_host_extras_changes() {
    log_section "m3air extras (diff)"

    local changed=0

    if ! _preview_m3air_emacs_plus_changes; then
        changed=1
    fi
    if ! _preview_m3air_git_repo_changes "$M3AIR_EMACS_REPO_URL" "$M3AIR_EMACS_REPO_DIR"; then
        changed=1
    fi
    if ! _preview_m3air_git_repo_changes "$M3AIR_RIME_REPO_URL" "$M3AIR_RIME_REPO_DIR"; then
        changed=1
    fi
    if ! _preview_m3air_rime_emacs_copy_changes; then
        changed=1
    fi

    if (( changed == 0 )); then
        log_info "No m3air extra changes."
        return 0
    fi
    return 1
}

sync_host_extras() {
    log_section "m3air extras"
    _sync_m3air_emacs_plus
    _sync_m3air_config_repos
}
