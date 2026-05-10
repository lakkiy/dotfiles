#!/usr/bin/env zsh
# lib/macos.sh — macOS system defaults (darwin-common parity)

_write_defaults() {
    local domain="$1"
    local key="$2"
    local type="$3"
    local value="$4"
    run defaults write "$domain" "$key" "-${type}" "$value"
}

_write_defaults_optional() {
    local domain="$1"
    local key="$2"
    local type="$3"
    local value="$4"

    if [[ "${DRY_RUN:-}" == "1" ]]; then
        log_dry "defaults write ${domain} ${key} -${type} ${value}"
        return 0
    fi

    if defaults write "$domain" "$key" "-${type}" "$value" 2>/dev/null; then
        return 0
    fi
    if defaults -currentHost write "$domain" "$key" "-${type}" "$value" 2>/dev/null; then
        log_warn "Fallback succeeded with -currentHost for ${domain} ${key}."
        return 0
    fi

    log_warn "Skip optional default (${domain} ${key}); write failed on this host."
    return 0
}

_get_scutil_name() {
    local name_type="$1"
    scutil --get "$name_type" 2>/dev/null | tail -n 1
}

_set_scutil_name() {
    local name_type="$1"
    local wanted="$2"

    local current=""
    current="$(_get_scutil_name "$name_type")"

    if [[ "$current" == "$wanted" ]]; then
        log_info "${name_type} already set: ${wanted}"
        return
    fi

    log_info "Setting ${name_type}: ${wanted}"
    run sudo scutil --set "$name_type" "$wanted"
}

_normalize_bool() {
    local v="${1:l}"
    case "$v" in
        1|true|yes) echo "1" ;;
        0|false|no) echo "0" ;;
        *) echo "$v" ;;
    esac
}

_defaults_value_matches() {
    local domain="$1"
    local key="$2"
    local type="$3"
    local wanted="$4"

    local current
    current="$(defaults read "$domain" "$key" 2>/dev/null || true)"
    [[ -z "$current" ]] && return 1

    case "$type" in
        bool)
            [[ "$(_normalize_bool "$current")" == "$(_normalize_bool "$wanted")" ]]
            ;;
        int)
            [[ "$current" == "$wanted" ]]
            ;;
        float)
            awk -v a="$current" -v b="$wanted" 'BEGIN { d=a-b; if (d<0) d=-d; exit (d < 0.000001 ? 0 : 1) }'
            ;;
        string)
            if [[ "$current" == "~/"* ]]; then
                current="${HOME}/${current#\~/}"
            fi
            [[ "$current" == "$wanted" ]]
            ;;
        *)
            [[ "$current" == "$wanted" ]]
            ;;
    esac
}

_preview_scutil_name_change() {
    local name_type="$1"
    local wanted="$2"
    local current
    current="$(_get_scutil_name "$name_type")"
    if [[ "$current" == "$wanted" ]]; then
        return 0
    fi
    echo "  - ${name_type}: '${current}' -> '${wanted}'"
    return 1
}

_preview_default_change() {
    local domain="$1"
    local key="$2"
    local type="$3"
    local wanted="$4"

    if _defaults_value_matches "$domain" "$key" "$type" "$wanted"; then
        return 0
    fi

    local current
    current="$(defaults read "$domain" "$key" 2>/dev/null || echo "<unset>")"
    echo "  - defaults write ${domain} ${key} -${type} ${wanted} (current: ${current})"
    return 1
}

preview_macos_defaults_changes() {
    log_section "macOS defaults (diff)"

    local changed=0
    if ! _preview_scutil_name_change "ComputerName" "${HOSTNAME}"; then
        changed=1
    fi
    if ! _preview_scutil_name_change "HostName" "${HOSTNAME}"; then
        changed=1
    fi
    if ! _preview_scutil_name_change "LocalHostName" "${HOSTNAME}"; then
        changed=1
    fi

    local -a defaults_plan
    defaults_plan=(
        "com.apple.AppleMultitouchTrackpad|Clicking|bool|true"
        "com.apple.driver.AppleBluetoothMultitouch.trackpad|Clicking|bool|true"
        "com.apple.AppleMultitouchTrackpad|TrackpadRightClick|bool|true"
        "com.apple.driver.AppleBluetoothMultitouch.trackpad|TrackpadRightClick|bool|true"
        "com.apple.AppleMultitouchTrackpad|Dragging|bool|true"
        "com.apple.driver.AppleBluetoothMultitouch.trackpad|Dragging|bool|true"
        "com.apple.AppleMultitouchTrackpad|TrackpadThreeFingerDrag|bool|true"
        "com.apple.driver.AppleBluetoothMultitouch.trackpad|TrackpadThreeFingerDrag|bool|true"
        "NSGlobalDomain|AppleShowAllFiles|bool|true"
        "NSGlobalDomain|AppleInterfaceStyleSwitchesAutomatically|bool|true"
        "NSGlobalDomain|NSAutomaticCapitalizationEnabled|bool|false"
        "NSGlobalDomain|NSDocumentSaveNewDocumentsToCloud|bool|false"
        "NSGlobalDomain|InitialKeyRepeat|int|10"
        "NSGlobalDomain|KeyRepeat|int|1"
        "NSGlobalDomain|com.apple.sound.beep.volume|float|0.4723665"
        "NSGlobalDomain|com.apple.keyboard.fnState|bool|true"
        "com.apple.dock|minimize-to-application|bool|true"
        "com.apple.screencapture|show-thumbnail|bool|true"
        "com.apple.screencapture|target|string|clipboard"
        "com.apple.finder|AppleShowAllFiles|bool|true"
        "com.apple.finder|ShowStatusBar|bool|true"
        "com.apple.finder|ShowPathbar|bool|true"
        "com.apple.finder|FXDefaultSearchScope|string|SCcf"
        "com.apple.finder|FXPreferredViewStyle|string|Nlsv"
        "com.apple.finder|QuitMenuItem|bool|true"
    )

    local item domain key type wanted
    for item in "${defaults_plan[@]}"; do
        domain="${item%%|*}"
        item="${item#*|}"
        key="${item%%|*}"
        item="${item#*|}"
        type="${item%%|*}"
        wanted="${item#*|}"
        if ! _preview_default_change "$domain" "$key" "$type" "$wanted"; then
            changed=1
        fi
    done

    if (( changed == 0 )); then
        log_info "No macOS defaults changes."
        return 0
    fi
    return 1
}

sync_macos_defaults() {
    log_section "macOS defaults"

    # darwin-common.nix: networking.{computerName,hostName,localHostName}
    _set_scutil_name "ComputerName" "${HOSTNAME}"
    _set_scutil_name "HostName" "${HOSTNAME}"
    _set_scutil_name "LocalHostName" "${HOSTNAME}"

    # darwin-common.nix: system.defaults.trackpad.*
    _write_defaults "com.apple.AppleMultitouchTrackpad" "Clicking" "bool" "true"
    _write_defaults "com.apple.driver.AppleBluetoothMultitouch.trackpad" "Clicking" "bool" "true"
    _write_defaults "com.apple.AppleMultitouchTrackpad" "TrackpadRightClick" "bool" "true"
    _write_defaults "com.apple.driver.AppleBluetoothMultitouch.trackpad" "TrackpadRightClick" "bool" "true"
    _write_defaults "com.apple.AppleMultitouchTrackpad" "Dragging" "bool" "true"
    _write_defaults "com.apple.driver.AppleBluetoothMultitouch.trackpad" "Dragging" "bool" "true"
    _write_defaults "com.apple.AppleMultitouchTrackpad" "TrackpadThreeFingerDrag" "bool" "true"
    _write_defaults "com.apple.driver.AppleBluetoothMultitouch.trackpad" "TrackpadThreeFingerDrag" "bool" "true"

    # darwin-common.nix: system.defaults.NSGlobalDomain.*
    _write_defaults "NSGlobalDomain" "AppleShowAllFiles" "bool" "true"
    _write_defaults "NSGlobalDomain" "AppleInterfaceStyleSwitchesAutomatically" "bool" "true"
    _write_defaults "NSGlobalDomain" "NSAutomaticCapitalizationEnabled" "bool" "false"
    _write_defaults "NSGlobalDomain" "NSDocumentSaveNewDocumentsToCloud" "bool" "false"
    _write_defaults "NSGlobalDomain" "InitialKeyRepeat" "int" "10"
    _write_defaults "NSGlobalDomain" "KeyRepeat" "int" "1"
    _write_defaults "NSGlobalDomain" "com.apple.sound.beep.volume" "float" "0.4723665"
    _write_defaults "NSGlobalDomain" "com.apple.keyboard.fnState" "bool" "true"

    # darwin-common.nix: system.defaults.dock.*
    _write_defaults "com.apple.dock" "minimize-to-application" "bool" "true"

    # darwin-common.nix: system.defaults.screencapture.*
    _write_defaults "com.apple.screencapture" "show-thumbnail" "bool" "true"
    _write_defaults "com.apple.screencapture" "target" "string" "clipboard"

    # darwin-common.nix: system.defaults.finder.*
    _write_defaults "com.apple.finder" "AppleShowAllFiles" "bool" "true"
    _write_defaults "com.apple.finder" "ShowStatusBar" "bool" "true"
    _write_defaults "com.apple.finder" "ShowPathbar" "bool" "true"
    _write_defaults "com.apple.finder" "FXDefaultSearchScope" "string" "SCcf"
    _write_defaults "com.apple.finder" "FXPreferredViewStyle" "string" "Nlsv"
    _write_defaults "com.apple.finder" "QuitMenuItem" "bool" "true"
}
