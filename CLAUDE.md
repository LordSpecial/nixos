# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## NixOS Flake Configuration

This repository contains a NixOS configuration using flakes with flake-parts framework, organized modularly for managing multiple hosts (workLaptop and personalLaptop).

### Common Commands

Set `HOST` environment variable in `.env` file or export it before running commands:
```bash
export HOST=workLaptop  # or personalLaptop
```

**Build and deployment:**
- `make switch` - Rebuild and switch configuration immediately
- `make boot` - Rebuild but only apply after reboot
- `make build` - Build configuration without activating
- `make test` - Test configuration without persisting changes

**Maintenance:**
- `make update` - Update flake inputs to latest versions
- `make gc` - Collect garbage (remove old generations)
- `make clean` - Clean build artifacts from nix store

**Direct commands** (if not using Makefile):
```bash
sudo nixos-rebuild switch --flake ~/.config/nixos#workLaptop
nix flake update ~/.config/nixos
```

### Architecture Overview

**Configuration composition pattern:**
The config uses a layered approach where base configs are composed with host-specific configs:

1. `flake.nix` imports `hosts/default.nix` and `lib/default.nix` via flake-parts
2. `hosts/default.nix` defines nixosConfigurations by composing:
   - Base laptop modules from `system/default.nix` (just `system/core` currently)
   - Host-specific config from `hosts/{hostname}/default.nix`
   - Home-manager with profile from `home/profiles/{hostname}.nix`

**Directory structure:**
- `flake.nix` - Main flake with inputs (nixpkgs, flake-parts, home-manager, hyprland, zen-browser, claude-code, codex-cli)
- `hosts/` - Per-host configurations (workLaptop, personalLaptop)
  - `hosts/default.nix` - Builds nixosConfigurations for each host
  - `hosts/{hostname}/default.nix` - Host-specific settings (bootloader, hostname, hardware imports)
  - `hosts/{hostname}/hardware-configuration.nix` - Auto-generated hardware config
- `system/` - Reusable system-level modules
  - `system/default.nix` - Exports base laptop config (just core module)
  - `system/core/default.nix` - Core system config (users, desktop environment, base packages)
  - `system/hardware/` - GPU drivers (intel-gpu.nix, nvidia-gpu.nix, hybrid-nv-in-gpu.nix)
  - `system/programs/` - Program configurations (hyprland/, terminal.nix, vscodium.nix)
- `home/` - Home-manager configurations
  - `home/default.nix` - Base home-manager config
  - `home/profiles/{hostname}.nix` - Per-host user packages and dotfiles
- `modules/` - Additional modular configurations (quickshell/)
- `lib/` - Utility functions (currently empty placeholder)

**Key patterns:**
- System config: `system/core/default.nix` sets up GNOME, Hyprland, users, base packages
- Host config: Each `hosts/{hostname}/default.nix` imports hardware modules and sets host-specific options (bootloader, graphics)
- Home config: `home/profiles/{hostname}.nix` imports home modules and sets user packages
- Graphics: Hosts import specific GPU modules from `system/hardware/` and enable features via options like `system.hybrid.enable`
- Overlays: AI tools (claude-code, codex) are added via nixpkgs overlays in `system/core/default.nix`

**Flake inputs:**
- Always uses nixos-unstable for latest packages
- Hyprland is pinned to avoid breaking changes
- Claude Code and Codex CLI use community flakes for frequent updates (sadjow/claude-code-nix, sadjow/codex-nix)
- All inputs follow nixpkgs where possible for consistency

### Installation

1. Clone repo to `~/.config/nixos`
2. Create symlink: `sudo ln -s ~/.config/nixos/ /etc/`
3. May need: `sudo chown -R simon:users ~/.config/nixos/`
4. Set HOST in `.env` file
5. Run `make switch`