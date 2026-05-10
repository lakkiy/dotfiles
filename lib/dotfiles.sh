#!/usr/bin/env zsh
# lib/dotfiles.sh — Declarative symlink management with state tracking

if [[ -z "${SETUP_DIR:-}" ]]; then
    _lib_path="$0"
    if [[ -n "${BASH_SOURCE[0]:-}" ]]; then
        _lib_path="${BASH_SOURCE[0]}"
    elif [[ -n "${funcfiletrace[1]:-}" ]]; then
        _lib_path="${funcfiletrace[1]%:*}"
    fi
    SETUP_DIR="$(cd "$(dirname "${_lib_path}")/.." && pwd)"
fi
DOTFILES_DIR="${SETUP_DIR}/config"

preview_dotfiles_changes() {
    log_section "Dotfiles (diff)"

    local state_file="${STATE_DIR}/dotfiles.txt"
    local -a prev_files wanted
    prev_files=()
    if [[ -f "$state_file" ]]; then
        local line
        while IFS= read -r line || [[ -n "$line" ]]; do
            prev_files+=("$line")
        done < "$state_file"
    fi
    wanted=("${DOTFILES[@]}")

    local changed=0
    local rel target src found w

    for rel in "${prev_files[@]}"; do
        found=0
        for w in "${wanted[@]}"; do
            [[ "$rel" == "$w" ]] && found=1 && break
        done
        [[ $found -eq 1 ]] && continue

        target="$HOME/$rel"
        if [[ -L "$target" ]]; then
            (( changed == 0 )) && log_info "Pending dotfile changes:"
            echo "  - unlink ${target}"
            changed=1
        fi
    done

    for rel in "${wanted[@]}"; do
        src="${DOTFILES_DIR}/${rel}"
        target="$HOME/$rel"

        if [[ ! -e "$src" ]]; then
            (( changed == 0 )) && log_info "Pending dotfile changes:"
            echo "  ! missing source: ${src}"
            changed=1
            continue
        fi

        if [[ -L "$target" ]]; then
            local current_link
            current_link="$(readlink "$target")"
            if [[ "$current_link" == "$src" ]]; then
                continue
            fi
            (( changed == 0 )) && log_info "Pending dotfile changes:"
            echo "  ~ relink ${target} -> ${src}"
            changed=1
        elif [[ -e "$target" ]]; then
            (( changed == 0 )) && log_info "Pending dotfile changes:"
            echo "  ~ backup ${target} to ${target}.bak, then link"
            changed=1
        else
            (( changed == 0 )) && log_info "Pending dotfile changes:"
            echo "  + link ${target} -> ${src}"
            changed=1
        fi
    done

    if (( changed == 0 )); then
        log_info "No dotfile link changes."
        return 0
    fi
    return 1
}

sync_dotfiles() {
    log_section "Dotfiles"
    ensure_dir "$STATE_DIR"

    local state_file="${STATE_DIR}/dotfiles.txt"
    local -a prev_files
    prev_files=()
    if [[ -f "$state_file" ]]; then
        while IFS= read -r line || [[ -n "$line" ]]; do
            prev_files+=("$line")
        done < "$state_file"
    fi

    # DOTFILES array is declared in the host file (relative paths, e.g. ".zshrc")
    local -a wanted
    wanted=("${DOTFILES[@]}")

    # Remove symlinks that were managed before but are no longer listed
    if [[ ${#prev_files[@]} -gt 0 ]]; then
        for rel in "${prev_files[@]}"; do
            local found=0
            if [[ ${#wanted[@]} -gt 0 ]]; then
                for w in "${wanted[@]}"; do
                    [[ "$rel" == "$w" ]] && found=1 && break
                done
            fi
            if [[ $found -eq 0 ]]; then
                local target="$HOME/$rel"
                if [[ -L "$target" ]]; then
                    log_info "Removing old symlink: $target"
                    run rm "$target"
                fi
            fi
        done
    fi

    # Create / update symlinks for current list
    if [[ ${#wanted[@]} -gt 0 ]]; then
        for rel in "${wanted[@]}"; do
            local src="${DOTFILES_DIR}/${rel}"
            local target="$HOME/$rel"

            if [[ ! -e "$src" ]]; then
                log_warn "Source not found, skipping: $src"
                continue
            fi

            # Ensure parent directory exists
            ensure_dir "$(dirname "$target")"

            if [[ -L "$target" ]]; then
                local current_link
                current_link="$(readlink "$target")"
                if [[ "$current_link" == "$src" ]]; then
                    log_info "Already linked: $target"
                    continue
                else
                    log_info "Updating symlink: $target -> $src"
                    run rm "$target"
                fi
            elif [[ -e "$target" ]]; then
                log_warn "Backing up existing file: $target -> ${target}.bak"
                run mv "$target" "${target}.bak"
            fi

            log_info "Linking: $target -> $src"
            run ln -s "$src" "$target"
        done
    fi

    # Persist new state
    if [[ "${DRY_RUN:-}" != "1" ]]; then
        if [[ ${#wanted[@]} -gt 0 ]]; then
            printf '%s\n' "${wanted[@]}" > "$state_file"
        else
            : > "$state_file"
        fi
    fi
}
