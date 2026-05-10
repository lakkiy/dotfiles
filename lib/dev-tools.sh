#!/usr/bin/env zsh
# lib/dev-tools.sh — language tool installers (go / uv / pnpm)

_array_contains() {
    local needle="$1"
    shift || true
    local item
    for item in "$@"; do
        [[ "$item" == "$needle" ]] && return 0
    done
    return 1
}

_prepend_path() {
    local dir="$1"
    [[ -z "$dir" ]] && return
    case ":${PATH}:" in
        *":${dir}:"*) ;;
        *) export PATH="${dir}:${PATH}" ;;
    esac
}

_persist_profile_line_if_missing() {
    local profile="$1"
    local line="$2"

    if [[ "${DRY_RUN:-}" == "1" ]]; then
        log_dry "append '${line}' to ${profile} (if missing)"
        return
    fi

    touch "$profile"
    if ! grep -Fqx "$line" "$profile"; then
        printf '%s\n' "$line" >> "$profile"
    fi
}

setup_dev_tool_env() {
    log_section "Dev tool env"

    local profile="${HOME}/.zprofile"

    export GO_GOPATH="${GO_GOPATH:-${HOME}/.go}"
    export GOPATH="${GOPATH:-${GO_GOPATH}}"

    export UV_TOOL_BIN_DIR="${UV_TOOL_BIN_DIR:-${HOME}/.local/bin}"

    export PNPM_HOME="${PNPM_HOME:-${HOME}/.local/share/pnpm}"

    _prepend_path "${GOPATH}/bin"
    _prepend_path "${UV_TOOL_BIN_DIR}"
    _prepend_path "${PNPM_HOME}"

    ensure_dir "${GOPATH}/bin"
    ensure_dir "${UV_TOOL_BIN_DIR}"
    ensure_dir "${PNPM_HOME}"

    _persist_profile_line_if_missing "$profile" "export GOPATH=\"${GOPATH}\""
    _persist_profile_line_if_missing "$profile" "export UV_TOOL_BIN_DIR=\"${UV_TOOL_BIN_DIR}\""
    _persist_profile_line_if_missing "$profile" "export PNPM_HOME=\"${PNPM_HOME}\""
    _persist_profile_line_if_missing "$profile" "export PATH=\"\$GOPATH/bin:\$PATH\""
    _persist_profile_line_if_missing "$profile" "export PATH=\"\$UV_TOOL_BIN_DIR:\$PATH\""
    _persist_profile_line_if_missing "$profile" "export PATH=\"\$PNPM_HOME:\$PATH\""
}

_go_tool_module_from_spec() {
    local spec="$1"
    local module="${spec%%:*}"
    if [[ "$module" != *@* ]]; then
        module="${module}@latest"
    fi
    echo "$module"
}

_go_tool_binary_from_spec() {
    local spec="$1"
    if [[ "$spec" == *:* ]]; then
        echo "${spec##*:}"
        return
    fi

    local module="${spec%%@*}"
    echo "${module##*/}"
}

sync_go_install_tools() {
    if ! typeset -p GO_INSTALL_TOOLS &>/dev/null; then
        return
    fi

    local -a wanted
    wanted=("${GO_INSTALL_TOOLS[@]}")
    if [[ ${#wanted[@]} -eq 0 ]]; then
        return
    fi

    log_section "Go install tools"
    ensure_dir "$STATE_DIR"

    if ! command -v go &>/dev/null; then
        log_warn "go not found; skipping go tool sync."
        return
    fi

    local gopath gobin
    gopath="${GO_GOPATH:-${GOPATH:-$HOME/.go}}"
    gobin="$(go env GOBIN 2>/dev/null || true)"
    [[ -z "$gobin" ]] && gobin="${gopath}/bin"
    ensure_dir "$gobin"

    local state_file="${STATE_DIR}/go_install_tools.txt"
    local -a prev_tools
    prev_tools=()
    if [[ -f "$state_file" ]]; then
        while IFS= read -r line || [[ -n "$line" ]]; do
            prev_tools+=("$line")
        done < "$state_file"
    fi

    local spec module bin
    for spec in "${wanted[@]}"; do
        module="$(_go_tool_module_from_spec "$spec")"
        bin="$(_go_tool_binary_from_spec "$spec")"

        if _array_contains "$spec" "${prev_tools[@]}" && [[ -x "${gobin}/${bin}" ]]; then
            log_info "Go tool already installed: ${module}"
            continue
        fi

        log_info "Installing/updating go tool: ${module}"
        run env GOPATH="$gopath" go install "$module"
    done

    local -a wanted_bins
    wanted_bins=()
    for spec in "${wanted[@]}"; do
        wanted_bins+=("$(_go_tool_binary_from_spec "$spec")")
    done

    local prev found keep wbin
    for prev in "${prev_tools[@]}"; do
        found=0
        for spec in "${wanted[@]}"; do
            [[ "$prev" == "$spec" ]] && found=1 && break
        done
        [[ $found -eq 1 ]] && continue

        bin="$(_go_tool_binary_from_spec "$prev")"
        keep=0
        for wbin in "${wanted_bins[@]}"; do
            [[ "$bin" == "$wbin" ]] && keep=1 && break
        done

        if [[ $keep -eq 0 && -n "$bin" && -e "${gobin}/${bin}" ]]; then
            log_info "Removing go tool binary: ${gobin}/${bin}"
            run rm -f "${gobin}/${bin}"
        fi
    done

    if [[ "${DRY_RUN:-}" != "1" ]]; then
        printf '%s\n' "${wanted[@]}" > "$state_file"
    fi
}

_uv_package_from_spec() {
    local spec="$1"
    echo "${spec%%:*}"
}

_uv_binary_from_spec() {
    local spec="$1"
    if [[ "$spec" == *:* ]]; then
        echo "${spec##*:}"
        return
    fi

    local pkg
    pkg="$(_uv_package_from_spec "$spec")"
    pkg="${pkg##*/}"
    pkg="${pkg%%[*<>=!@ ]*}"
    echo "$pkg"
}

_uv_uninstall_name_from_spec() {
    local spec="$1"
    local pkg
    pkg="$(_uv_package_from_spec "$spec")"
    if [[ "$pkg" == git+* || "$pkg" == http://* || "$pkg" == https://* ]]; then
        echo ""
        return
    fi
    echo "${pkg%%[*<>=!@ ]*}"
}

sync_uv_tools() {
    if ! typeset -p UV_TOOLS &>/dev/null; then
        return
    fi

    local -a wanted
    wanted=("${UV_TOOLS[@]}")
    if [[ ${#wanted[@]} -eq 0 ]]; then
        return
    fi

    log_section "uv tools"
    ensure_dir "$STATE_DIR"

    if ! command -v uv &>/dev/null; then
        log_warn "uv not found; skipping UV_TOOLS sync."
        return
    fi

    local uv_bin="${UV_TOOL_BIN_DIR:-${HOME}/.local/bin}"
    ensure_dir "$uv_bin"

    local state_file="${STATE_DIR}/uv_tools.txt"
    local -a prev_tools
    prev_tools=()
    if [[ -f "$state_file" ]]; then
        while IFS= read -r line || [[ -n "$line" ]]; do
            prev_tools+=("$line")
        done < "$state_file"
    fi

    local spec pkg bin
    for spec in "${wanted[@]}"; do
        pkg="$(_uv_package_from_spec "$spec")"
        bin="$(_uv_binary_from_spec "$spec")"

        if _array_contains "$spec" "${prev_tools[@]}" && [[ -x "${uv_bin}/${bin}" ]]; then
            log_info "uv tool already installed: ${pkg}"
            continue
        fi

        log_info "Installing/updating uv tool: ${pkg}"
        run uv tool install "$pkg"
    done

    local -a wanted_bins
    wanted_bins=()
    for spec in "${wanted[@]}"; do
        wanted_bins+=("$(_uv_binary_from_spec "$spec")")
    done

    local prev found keep wbin uninstall_name
    for prev in "${prev_tools[@]}"; do
        found=0
        for spec in "${wanted[@]}"; do
            [[ "$prev" == "$spec" ]] && found=1 && break
        done
        [[ $found -eq 1 ]] && continue

        bin="$(_uv_binary_from_spec "$prev")"
        keep=0
        for wbin in "${wanted_bins[@]}"; do
            [[ "$bin" == "$wbin" ]] && keep=1 && break
        done
        [[ $keep -eq 1 ]] && continue

        uninstall_name="$(_uv_uninstall_name_from_spec "$prev")"
        if [[ -z "$uninstall_name" ]]; then
            log_warn "Cannot infer uv uninstall target from: ${prev}"
            continue
        fi

        log_info "Removing uv tool: ${uninstall_name}"
        run uv tool uninstall "$uninstall_name"
    done

    if [[ "${DRY_RUN:-}" != "1" ]]; then
        printf '%s\n' "${wanted[@]}" > "$state_file"
    fi
}

sync_pnpm_global_packages() {
    if ! typeset -p PNPM_GLOBAL_PACKAGES &>/dev/null; then
        return
    fi

    local -a wanted
    wanted=("${PNPM_GLOBAL_PACKAGES[@]}")
    if [[ ${#wanted[@]} -eq 0 ]]; then
        return
    fi

    log_section "pnpm global packages"
    ensure_dir "$STATE_DIR"

    if ! command -v pnpm &>/dev/null; then
        log_warn "pnpm not found; skipping PNPM_GLOBAL_PACKAGES sync."
        return
    fi

    if ! command -v node &>/dev/null; then
        log_warn "node not found; skipping PNPM_GLOBAL_PACKAGES sync."
        return
    fi

    ensure_dir "${PNPM_HOME:-${HOME}/Library/pnpm}"

    if [[ "${DRY_RUN:-}" == "1" ]]; then
        log_dry "pnpm config set global-bin-dir ${PNPM_HOME}"
    else
        pnpm config set global-bin-dir "${PNPM_HOME}" >/dev/null 2>&1 || true
    fi

    local global_root=""
    if [[ "${DRY_RUN:-}" != "1" ]]; then
        global_root="$(pnpm root -g 2>/dev/null || true)"
        if [[ -z "$global_root" ]]; then
            log_warn "Could not resolve pnpm global root; will still try installs."
        fi
    fi

    local state_file="${STATE_DIR}/pnpm_global_packages.txt"
    local -a prev_packages
    prev_packages=()
    if [[ -f "$state_file" ]]; then
        while IFS= read -r line || [[ -n "$line" ]]; do
            prev_packages+=("$line")
        done < "$state_file"
    fi

    local pkg
    for pkg in "${wanted[@]}"; do
        if _array_contains "$pkg" "${prev_packages[@]}" && \
           [[ -n "$global_root" && -d "${global_root}/${pkg}" ]]; then
            log_info "pnpm package already installed: ${pkg}"
            continue
        fi

        log_info "Installing/updating pnpm package: ${pkg}"
        run pnpm add -g "$pkg"
    done

    local prev found
    for prev in "${prev_packages[@]}"; do
        found=0
        for pkg in "${wanted[@]}"; do
            [[ "$prev" == "$pkg" ]] && found=1 && break
        done
        [[ $found -eq 1 ]] && continue

        log_info "Removing pnpm package: ${prev}"
        run pnpm remove -g "$prev"
    done

    if [[ "${DRY_RUN:-}" != "1" ]]; then
        printf '%s\n' "${wanted[@]}" > "$state_file"
    fi
}

sync_git_lfs() {
    if ! command -v git-lfs &>/dev/null; then
        return
    fi

    log_section "Git LFS"
    if [[ "${DRY_RUN:-}" == "1" ]]; then
        log_dry "git lfs install --skip-repo"
    else
        git lfs install --skip-repo >/dev/null
    fi
}

_read_state_items() {
    local state_file="$1"
    if [[ -f "$state_file" ]]; then
        cat "$state_file"
    fi
}

_preview_go_install_tools_changes() {
    if ! typeset -p GO_INSTALL_TOOLS &>/dev/null; then
        return 0
    fi

    local -a wanted prev_tools wanted_bins
    wanted=("${GO_INSTALL_TOOLS[@]}")
    [[ ${#wanted[@]} -eq 0 ]] && return 0

    local state_file="${STATE_DIR}/go_install_tools.txt"
    prev_tools=()
    local line
    while IFS= read -r line || [[ -n "$line" ]]; do
        prev_tools+=("$line")
    done < <(_read_state_items "$state_file")

    if ! command -v go &>/dev/null; then
        echo "  - go tools: go not found (will skip)"
        return 0
    fi

    local gopath gobin spec module bin prev found keep wbin
    gopath="${GO_GOPATH:-${GOPATH:-$HOME/.go}}"
    gobin="$(go env GOBIN 2>/dev/null || true)"
    [[ -z "$gobin" ]] && gobin="${gopath}/bin"

    wanted_bins=()
    for spec in "${wanted[@]}"; do
        wanted_bins+=("$(_go_tool_binary_from_spec "$spec")")
    done

    local changed=0
    for spec in "${wanted[@]}"; do
        module="$(_go_tool_module_from_spec "$spec")"
        bin="$(_go_tool_binary_from_spec "$spec")"
        if _array_contains "$spec" "${prev_tools[@]}" && [[ -x "${gobin}/${bin}" ]]; then
            continue
        fi
        (( changed == 0 )) && echo "  - go tools:"
        echo "      + install ${module}"
        changed=1
    done

    for prev in "${prev_tools[@]}"; do
        found=0
        for spec in "${wanted[@]}"; do
            [[ "$prev" == "$spec" ]] && found=1 && break
        done
        [[ $found -eq 1 ]] && continue

        bin="$(_go_tool_binary_from_spec "$prev")"
        keep=0
        for wbin in "${wanted_bins[@]}"; do
            [[ "$bin" == "$wbin" ]] && keep=1 && break
        done
        if [[ $keep -eq 0 && -n "$bin" && -e "${gobin}/${bin}" ]]; then
            (( changed == 0 )) && echo "  - go tools:"
            echo "      - remove ${bin}"
            changed=1
        fi
    done

    if (( changed == 0 )); then
        return 0
    fi
    return 1
}

_preview_uv_tools_changes() {
    if ! typeset -p UV_TOOLS &>/dev/null; then
        return 0
    fi

    local -a wanted prev_tools wanted_bins
    wanted=("${UV_TOOLS[@]}")
    [[ ${#wanted[@]} -eq 0 ]] && return 0

    local state_file="${STATE_DIR}/uv_tools.txt"
    prev_tools=()
    local line
    while IFS= read -r line || [[ -n "$line" ]]; do
        prev_tools+=("$line")
    done < <(_read_state_items "$state_file")

    if ! command -v uv &>/dev/null; then
        echo "  - uv tools: uv not found (will skip)"
        return 0
    fi

    local uv_bin="${UV_TOOL_BIN_DIR:-${HOME}/.local/bin}"
    local spec pkg bin prev found keep wbin uninstall_name
    local changed=0

    wanted_bins=()
    for spec in "${wanted[@]}"; do
        wanted_bins+=("$(_uv_binary_from_spec "$spec")")
    done

    for spec in "${wanted[@]}"; do
        pkg="$(_uv_package_from_spec "$spec")"
        bin="$(_uv_binary_from_spec "$spec")"
        if _array_contains "$spec" "${prev_tools[@]}" && [[ -x "${uv_bin}/${bin}" ]]; then
            continue
        fi
        (( changed == 0 )) && echo "  - uv tools:"
        echo "      + install ${pkg}"
        changed=1
    done

    for prev in "${prev_tools[@]}"; do
        found=0
        for spec in "${wanted[@]}"; do
            [[ "$prev" == "$spec" ]] && found=1 && break
        done
        [[ $found -eq 1 ]] && continue

        bin="$(_uv_binary_from_spec "$prev")"
        keep=0
        for wbin in "${wanted_bins[@]}"; do
            [[ "$bin" == "$wbin" ]] && keep=1 && break
        done
        [[ $keep -eq 1 ]] && continue

        uninstall_name="$(_uv_uninstall_name_from_spec "$prev")"
        [[ -z "$uninstall_name" ]] && continue
        (( changed == 0 )) && echo "  - uv tools:"
        echo "      - uninstall ${uninstall_name}"
        changed=1
    done

    if (( changed == 0 )); then
        return 0
    fi
    return 1
}

_preview_pnpm_global_changes() {
    if ! typeset -p PNPM_GLOBAL_PACKAGES &>/dev/null; then
        return 0
    fi

    local -a wanted prev_packages
    wanted=("${PNPM_GLOBAL_PACKAGES[@]}")
    [[ ${#wanted[@]} -eq 0 ]] && return 0

    local state_file="${STATE_DIR}/pnpm_global_packages.txt"
    prev_packages=()
    local line
    while IFS= read -r line || [[ -n "$line" ]]; do
        prev_packages+=("$line")
    done < <(_read_state_items "$state_file")

    if ! command -v pnpm &>/dev/null; then
        echo "  - pnpm globals: pnpm not found (will skip)"
        return 0
    fi
    if ! command -v node &>/dev/null; then
        echo "  - pnpm globals: node not found (will skip)"
        return 0
    fi

    local global_root=""
    global_root="$(pnpm root -g 2>/dev/null || true)"

    local pkg prev found changed
    changed=0
    for pkg in "${wanted[@]}"; do
        if _array_contains "$pkg" "${prev_packages[@]}"; then
            if [[ -n "$global_root" && -d "${global_root}/${pkg}" ]]; then
                continue
            fi
            if [[ -z "$global_root" ]]; then
                continue
            fi
        fi
        (( changed == 0 )) && echo "  - pnpm globals:"
        echo "      + add ${pkg}"
        changed=1
    done

    for prev in "${prev_packages[@]}"; do
        found=0
        for pkg in "${wanted[@]}"; do
            [[ "$prev" == "$pkg" ]] && found=1 && break
        done
        [[ $found -eq 1 ]] && continue
        (( changed == 0 )) && echo "  - pnpm globals:"
        echo "      - remove ${prev}"
        changed=1
    done

    if (( changed == 0 )); then
        return 0
    fi
    return 1
}

preview_dev_tools_changes() {
    log_section "Dev tools (diff)"

    local has_changes=0
    if ! _preview_go_install_tools_changes; then
        has_changes=1
    fi
    if ! _preview_uv_tools_changes; then
        has_changes=1
    fi
    if ! _preview_pnpm_global_changes; then
        has_changes=1
    fi

    if (( has_changes == 0 )); then
        log_info "No dev tool changes."
        return 0
    fi
    return 1
}
