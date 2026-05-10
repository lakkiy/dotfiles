#!/usr/bin/env zsh
# lib/zsh.sh — Sync zsh plugin files from URL list with state tracking

_zsh_plugin_file_from_spec() {
    local spec="$1"
    echo "${spec%%|*}"
}

_zsh_plugin_url_from_spec() {
    local spec="$1"
    echo "${spec#*|}"
}

sync_zsh_plugins() {
    if ! typeset -p ZSH_PLUGIN_SOURCES &>/dev/null; then
        return
    fi

    local -a wanted
    wanted=("${ZSH_PLUGIN_SOURCES[@]}")
    if [[ ${#wanted[@]} -eq 0 ]]; then
        return
    fi

    log_section "Zsh plugins"
    ensure_dir "$STATE_DIR"

    local plugins_dir="${HOME}/.config/zsh/plugins"
    ensure_dir "$plugins_dir"

    local state_file="${STATE_DIR}/zsh_plugins.txt"
    local spec file url target

    for spec in "${wanted[@]}"; do
        file="$(_zsh_plugin_file_from_spec "$spec")"
        url="$(_zsh_plugin_url_from_spec "$spec")"
        target="${plugins_dir}/${file}"

        if [[ -z "$file" || -z "$url" || "$spec" != *"|"* ]]; then
            log_warn "Invalid ZSH_PLUGIN_SOURCES entry, skipping: ${spec}"
            continue
        fi

        if [[ "${DRY_RUN:-}" == "1" ]]; then
            log_dry "curl -fsSL ${url} -o ${target}"
        else
            log_info "Sync plugin: ${file}"
            curl -fsSL "$url" -o "$target"
        fi
    done

    if [[ -f "$state_file" ]]; then
        local -a prev_plugins
        prev_plugins=()
        while IFS= read -r line || [[ -n "$line" ]]; do
            prev_plugins+=("$line")
        done < "$state_file"

        local prev found prev_file
        for prev in "${prev_plugins[@]}"; do
            found=0
            for spec in "${wanted[@]}"; do
                [[ "$prev" == "$spec" ]] && found=1 && break
            done

            if [[ $found -eq 0 ]]; then
                prev_file="$(_zsh_plugin_file_from_spec "$prev")"
                if [[ -n "$prev_file" && -e "${plugins_dir}/${prev_file}" ]]; then
                    log_info "Removing old plugin: ${plugins_dir}/${prev_file}"
                    run rm -f "${plugins_dir}/${prev_file}"
                fi
            fi
        done
    fi

    if [[ "${DRY_RUN:-}" != "1" ]]; then
        printf '%s\n' "${wanted[@]}" > "$state_file"
    fi
}
