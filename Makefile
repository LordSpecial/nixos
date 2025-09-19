FLAKE = $(HOME)/.config/nixos
HOST  = workLaptop

.PHONY: switch boot build test update gc clean

## Rebuild and switch immediately
switch:
	sudo nixos-rebuild switch --flake $(FLAKE)#$(HOST)

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
