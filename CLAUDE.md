# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a NixOS/nix-darwin personal system configuration using Nix flakes. It supports multiple platforms:
- NixOS systems (Linux)
- macOS via nix-darwin
- Standalone home-manager configurations

The configuration uses a modular architecture with shared common functionality and platform-specific modules.

## Architecture

- `flake.nix`: Main flake configuration defining inputs, outputs, and the `mkHost` function for creating system configurations
- `common.nix`: Shared configuration across all platforms
- `home.nix`: Home-manager configuration imported by all hosts
- `modules/`: Platform-specific and feature modules
  - `modules/home/`: Home-manager modules (dev tools, desktop environments, etc.)
  - `modules/nixos/`: NixOS-specific modules
  - `modules/darwin-common.nix`: macOS-specific configuration
- `hosts/`: Individual host configurations (north, homelab, m3air, macmini)

The `mkHost` function automatically selects appropriate modules based on the target platform (Darwin vs Linux).

## Common Commands

### Building and Activating Configurations

**NixOS:**
```bash
# Install from scratch
nixos-install --flake .#<host>

# Rebuild existing system
sudo nixos-rebuild switch --flake .#<host>
```

**macOS (nix-darwin):**
```bash
# First time setup
nix build .#darwinConfigurations.<host>.system
./result/sw/bin/darwin-rebuild switch --flake .#<host>

# Subsequent rebuilds
sudo darwin-rebuild switch --flake .#<host>
```

**Standalone home-manager:**
```bash
# First time
nix build .#homeConfigurations.<host>.activationPackage
./result/activate

# Rebuilds
home-manager switch --flake .#<host>
```

### Development

```bash
# Format Nix code
nix fmt

# Check flake
nix flake check

# Update flake inputs
nix flake update
```

## Host Configurations

- `north`: NixOS desktop with Zen browser
- `homelab`: NixOS server (root user)
- `m3air`: macOS (aarch64) with development tools
- `macmini`: macOS (aarch64) with media server apps

## Key Features

- Dvorak keyboard layout configuration
- Development environment with Emacs, terminal tools
- Platform-specific package management (nixpkgs + homebrew on macOS)
- Shared shell configuration (zsh with oh-my-zsh plugins)
- Font management across platforms
- Git configuration with delta, LFS support