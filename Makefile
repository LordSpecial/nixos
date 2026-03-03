-include .env
FLAKE = $(HOME)/.config/nixos

.PHONY: switch boot build test update gc clean reload-app-cache

## Rebuild and switch immediately
switch:
	sudo nixos-rebuild switch --flake $(FLAKE)#$(HOST)
	@$(MAKE) reload-app-cache

## Rebuild but only apply after reboot
boot:
	sudo nixos-rebuild boot --flake $(FLAKE)#$(HOST)

## Just build, don’t activate
build:
	nixos-rebuild build --flake $(FLAKE)#$(HOST)

## Test without persisting changes
test:
	sudo nixos-rebuild test --flake $(FLAKE)#$(HOST)

## Update flake inputs
update:
	nix flake update $(FLAKE)

## Collect garbage (remove old generations)
gc:
	sudo nix-collect-garbage -d

## Clean build artifacts
clean:
	sudo nix-store --gc

## Reload user app cache for launchers
reload-app-cache:
	@rm -rf ~/.cache/fuzzel
	@mkdir -p ~/.cache/fuzzel
	@if command -v update-desktop-database >/dev/null 2>&1; then \
		update-desktop-database ~/.local/share/applications ~/.nix-profile/share/applications 2>/dev/null || true; \
	fi
	@if pgrep -x noctalia-shell >/dev/null 2>&1; then \
		pkill -x noctalia-shell || true; \
		nohup noctalia-shell >/tmp/noctalia.log 2>&1 & \
	fi
