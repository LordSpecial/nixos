-include .env
FLAKE = $(HOME)/.config/nixos

SERVER_HOSTS = specialserver
IS_SERVER = $(filter $(HOST),$(SERVER_HOSTS))
ROLLBACK_TIMEOUT ?= 5min
REBOOT_TIMEOUT ?= 5min

.PHONY: switch boot build test update gc clean reload-app-cache deploy diff _server-switch

## Rebuild and switch immediately (with safety checks for servers)
switch:
	@if [ -n "$(IS_SERVER)" ]; then \
		$(MAKE) _server-switch; \
	else \
		sudo nixos-rebuild switch --flake $(FLAKE)#$(HOST) && \
		$(MAKE) reload-app-cache; \
	fi

## Server-safe switch with dead man's switch
_server-switch: build
	@echo "Checking for kernel changes..."
	@set -o pipefail; \
	diff_out=$$(nix store diff-closures /run/current-system ./result 2>&1) || { \
		echo ""; \
		echo "*** diff-closures failed — refusing to switch (fail closed) ***"; \
		echo "$$diff_out"; \
		echo "Run 'make diff' to debug, or 'make deploy' to boot+reboot safely."; \
		echo ""; \
		exit 1; \
	}; \
	if echo "$$diff_out" | grep -qE '^\s*linux(-[0-9]|[: ])'; then \
		echo ""; \
		echo "*** Kernel change detected ***"; \
		echo "Live-switching the kernel can break connectivity on remote servers."; \
		echo "Use 'make deploy' instead (applies at next boot + reboots)."; \
		echo ""; \
		exit 1; \
	fi
	@echo "No kernel change detected."
	@echo "Scheduling automatic rollback in $(ROLLBACK_TIMEOUT)..."
	@sudo systemctl stop nixos-rollback.timer 2>/dev/null || true
	@sudo systemctl stop nixos-failsafe-reboot.timer 2>/dev/null || true
	@sudo systemd-run --on-active="$(ROLLBACK_TIMEOUT)" --unit=nixos-rollback \
		/bin/sh -c '/run/current-system/sw/bin/nixos-rebuild switch --rollback; /run/current-system/sw/bin/systemd-run --on-active="$(REBOOT_TIMEOUT)" --unit=nixos-failsafe-reboot /run/current-system/sw/bin/reboot'
	@sudo nixos-rebuild switch --flake $(FLAKE)#$(HOST) || { \
		echo ""; \
		echo "*** Switch failed — rollback stays armed ***"; \
		echo "The system may be in a partially applied state."; \
		echo "Rollback will fire in $(ROLLBACK_TIMEOUT) unless you intervene."; \
		echo "To cancel: sudo systemctl stop nixos-rollback.timer nixos-failsafe-reboot.timer"; \
		exit 1; \
	}
	@echo ""
	@echo "=== Switch successful ==="
	@echo "Safety rollback is armed. If you lose connectivity:"
	@echo "  - Automatic rollback in $(ROLLBACK_TIMEOUT)"
	@echo "  - Hard reboot $(REBOOT_TIMEOUT) after rollback if still unreachable"
	@echo ""
	@if read -p "Press ENTER to confirm deployment is working: " _ 2>/dev/null; then \
		sudo systemctl stop nixos-rollback.timer 2>/dev/null; \
		sudo systemctl stop nixos-failsafe-reboot.timer 2>/dev/null; \
		echo "Rollback timer cancelled. Deployment confirmed."; \
	else \
		echo ""; \
		echo "*** No interactive confirmation — rollback stays armed ***"; \
		echo "Connect and run: sudo systemctl stop nixos-rollback.timer nixos-failsafe-reboot.timer"; \
	fi

## Deploy with reboot (for kernel changes on servers)
deploy:
	@if [ -z "$(IS_SERVER)" ]; then \
		echo "'make deploy' is only for server hosts ($(SERVER_HOSTS))."; \
		echo "Use 'make switch' for laptops."; \
		exit 1; \
	fi
	sudo nixos-rebuild boot --flake $(FLAKE)#$(HOST)
	@echo ""
	@echo "Configuration applied to next boot."
	@echo "Rebooting in 5 seconds... Reconnect via SSH after reboot."
	@sleep 5
	sudo reboot

## Show what changed between current system and new build
diff: build
	nix store diff-closures /run/current-system ./result

## Rebuild but only apply after reboot
boot:
	sudo nixos-rebuild boot --flake $(FLAKE)#$(HOST)

## Just build, don't activate
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
