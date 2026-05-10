#!/usr/bin/env zsh
# lib/pacman.sh — Arch Linux pacman (+ optional yay) package management
# Uses a state file to track previously installed packages and remove stale ones

if [[ -z "${SETUP_DIR:-}" ]]; then
    _lib_path="$0"
    if [[ -n "${BASH_SOURCE[0]:-}" ]]; then
        _lib_path="${BASH_SOURCE[0]}"
    elif [[ -n "${funcfiletrace[1]:-}" ]]; then
        _lib_path="${funcfiletrace[1]%:*}"
    fi
    SETUP_DIR="$(cd "$(dirname "${_lib_path}")/.." && pwd)"
fi

sync_pacman_packages() {
    log_section "Pacman packages"
    ensure_dir "$STATE_DIR"

    local state_file="${STATE_DIR}/packages.txt"
    local aur_state_file="${STATE_DIR}/aur_packages.txt"

    # Official repo packages
    if [[ ${#PACKAGES[@]} -gt 0 ]]; then
        _sync_pkg_set "$state_file" "pacman" "${PACKAGES[@]}"
    fi

    # AUR packages (optional — only if AUR_PACKAGES is set and yay is available)
    if [[ ${#AUR_PACKAGES[@]} -gt 0 ]]; then
        if command -v yay &>/dev/null; then
            _sync_pkg_set "$aur_state_file" "yay" "${AUR_PACKAGES[@]}"
        else
            log_warn "yay not found; skipping AUR packages. Install yay manually."
        fi
    fi
}

# _sync_pkg_set <state_file> <tool: pacman|yay> <packages...>
_sync_pkg_set() {
    local state_file="$1"
    local tool="$2"
    shift 2
    local -a wanted
    wanted=("$@")

    # Install / skip already-installed packages
    log_info "Syncing ${tool} packages..."
    if [[ "${DRY_RUN:-}" == "1" ]]; then
        log_dry "sudo ${tool} -S --needed ${wanted[*]}"
    else
        sudo "$tool" -S --needed --noconfirm "${wanted[@]}"
    fi

    # Remove packages present in last run but not in current list
    if [[ -f "$state_file" ]]; then
        local -a prev_pkgs
        prev_pkgs=()
        while IFS= read -r line || [[ -n "$line" ]]; do
            prev_pkgs+=("$line")
        done < "$state_file"
        local -a to_remove
        to_remove=()
        if [[ ${#prev_pkgs[@]} -gt 0 ]]; then
            for pkg in "${prev_pkgs[@]}"; do
                local found=0
                for w in "${wanted[@]}"; do
                    [[ "$pkg" == "$w" ]] && found=1 && break
                done
                [[ $found -eq 0 ]] && to_remove+=("$pkg")
            done
        fi
        if [[ ${#to_remove[@]} -gt 0 ]]; then
            log_info "Removing unlisted ${tool} packages: ${to_remove[*]}"
            if [[ "${DRY_RUN:-}" == "1" ]]; then
                log_dry "sudo pacman -Rns ${to_remove[*]}"
            else
                sudo pacman -Rns --noconfirm "${to_remove[@]}" || \
                    log_warn "Some packages could not be removed (may already be absent)"
            fi
        fi
    fi

    # Write new state
    if [[ "${DRY_RUN:-}" != "1" ]]; then
        printf '%s\n' "${wanted[@]}" > "$state_file"
    fi
}

sync_systemd_services() {
    log_section "Systemd services"
    # SERVICES array declared in host file: "name:action"
    if [[ ${#SERVICES[@]} -gt 0 ]]; then
        for entry in "${SERVICES[@]}"; do
            local svc="${entry%%:*}"
            local action="${entry##*:}"
            log_info "${action} service: ${svc}"
            if [[ "${DRY_RUN:-}" != "1" ]]; then
                case "$action" in
                    enable)  sudo systemctl enable --now "$svc" ;;
                    disable) sudo systemctl disable --now "$svc" ;;
                    start)   sudo systemctl start "$svc" ;;
                    stop)    sudo systemctl stop "$svc" ;;
                    *) log_warn "Unknown action '${action}' for service '${svc}'" ;;
                esac
            else
                log_dry "sudo systemctl ${action} ${svc}"
            fi
        done
    fi
}
