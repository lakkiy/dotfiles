#!/usr/bin/env zsh
# lib/host-m3air.sh — host-specific extras for m3air

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
    _sync_m3air_config_repos
}
