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

    # Personal script directories in this repo to expose on PATH.
    # Host config sets BIN_DIRS as repo-relative paths, e.g. BIN_DIRS=(bin).
    if typeset -p BIN_DIRS &>/dev/null && (( ${#BIN_DIRS[@]} )); then
        local bin_rel bin_abs bin_persist
        for bin_rel in "${BIN_DIRS[@]}"; do
            bin_abs="${SETUP_DIR}/${bin_rel}"
            _prepend_path "${bin_abs}"
            # Persist relative to $HOME when the repo lives under it, for portability.
            if [[ "${bin_abs}" == "${HOME}/"* ]]; then
                bin_persist="\$HOME/${bin_abs#${HOME}/}"
            else
                bin_persist="${bin_abs}"
            fi
            _persist_profile_line_if_missing "$profile" "export PATH=\"${bin_persist}:\$PATH\""
        done
    fi
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

# Package names currently installed as uv tools (first column of `uv tool list`).
# Authoritative — avoids guessing a binary name from the package, which breaks
# for packages whose entry points differ (e.g. mlx-lm -> mlx_lm, mlx_lm.server).
_uv_installed_packages() {
    uv tool list 2>/dev/null | awk 'NF && $1 != "-" {print $1}'
}

# Is a spec already installed? Prefer the uv tool list; fall back to binary
# presence only for git/url specs whose canonical name we cannot infer.
_uv_spec_installed() {
    local spec="$1"; shift
    local uninstall_name
    uninstall_name="$(_uv_uninstall_name_from_spec "$spec")"
    if [[ -n "$uninstall_name" ]]; then
        _array_contains "$uninstall_name" "$@"
        return
    fi
    local uv_bin="${UV_TOOL_BIN_DIR:-${HOME}/.local/bin}"
    [[ -x "${uv_bin}/$(_uv_binary_from_spec "$spec")" ]]
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

    local -a installed_uv
    installed_uv=()
    local _pkg_line
    while IFS= read -r _pkg_line || [[ -n "$_pkg_line" ]]; do
        [[ -n "$_pkg_line" ]] && installed_uv+=("$_pkg_line")
    done < <(_uv_installed_packages)

    # Install only when a package is recorded in NEITHER the state file NOR the
    # system. The state file is authoritative: once recorded we never reinstall,
    # even if the system check can't find it (state file wins). A package present
    # on the system but missing from the state file is simply recorded — the state
    # file is rewritten to the full wanted list below — and not reinstalled.
    local spec pkg in_state on_system
    for spec in "${wanted[@]}"; do
        pkg="$(_uv_package_from_spec "$spec")"

        in_state=0; on_system=0
        _array_contains "$spec" "${prev_tools[@]}" && in_state=1
        _uv_spec_installed "$spec" "${installed_uv[@]}" && on_system=1

        if (( in_state )); then
            log_info "uv tool already installed: ${pkg}"
            continue
        fi
        if (( on_system )); then
            log_info "uv tool present on system, recording in state: ${pkg}"
            continue
        fi

        log_info "Installing uv tool: ${pkg}"
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

# Is a pnpm global package installed? `pnpm root -g` returns the global prefix,
# but packages live one level deeper under <prefix>/<hash>/node_modules/<pkg>
# (and the entry is a symlink into the store), so a plain "<root>/<pkg>" dir
# check never matches. Search the node_modules trees instead.
_pnpm_pkg_installed() {
    local global_root="$1" pkg="$2"
    [[ -n "$global_root" ]] || return 1
    find "$global_root" -maxdepth 4 -path "*/node_modules/${pkg}" 2>/dev/null | grep -q .
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

    # Install only when a package is recorded in NEITHER the state file NOR the
    # system. The state file is authoritative (see sync_uv_tools for rationale):
    # recorded packages are never reinstalled; system-only packages are recorded.
    local pkg in_state on_system
    for pkg in "${wanted[@]}"; do
        in_state=0; on_system=0
        _array_contains "$pkg" "${prev_packages[@]}" && in_state=1
        _pnpm_pkg_installed "$global_root" "$pkg" && on_system=1

        if (( in_state )); then
            log_info "pnpm package already installed: ${pkg}"
            continue
        fi
        if (( on_system )); then
            log_info "pnpm package present on system, recording in state: ${pkg}"
            continue
        fi

        log_info "Installing pnpm package: ${pkg}"
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

    local spec pkg bin prev found keep wbin uninstall_name
    local changed=0

    local -a installed_uv
    installed_uv=()
    local _pkg_line
    while IFS= read -r _pkg_line || [[ -n "$_pkg_line" ]]; do
        [[ -n "$_pkg_line" ]] && installed_uv+=("$_pkg_line")
    done < <(_uv_installed_packages)

    wanted_bins=()
    for spec in "${wanted[@]}"; do
        wanted_bins+=("$(_uv_binary_from_spec "$spec")")
    done

    for spec in "${wanted[@]}"; do
        pkg="$(_uv_package_from_spec "$spec")"
        # No install when recorded in the state file OR present on the system.
        if _array_contains "$spec" "${prev_tools[@]}" || \
           _uv_spec_installed "$spec" "${installed_uv[@]}"; then
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
        # No install when recorded in the state file OR present on the system.
        if _array_contains "$pkg" "${prev_packages[@]}" || \
           _pnpm_pkg_installed "$global_root" "$pkg"; then
            continue
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
