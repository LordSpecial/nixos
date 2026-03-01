# Installation
1. Clone repo, such as into `~/.config/nixos`
2. create a symlink `sudo ln -s ~/.config/nixos/ /etc/`
    * you may need to `sudo chown -R simon:users ~/.config/nixos/`

# Usage

Set your host in `.env`:
```bash
echo "HOST=workLaptop" > .env
```

## Commands

| Command | Description |
|---------|-------------|
| `make switch` | Rebuild and activate immediately |
| `make boot` | Rebuild, apply on next reboot |
| `make build` | Build only (no activation) |
| `make test` | Test without persisting |
| `make deploy` | Server only: `boot` + reboot (for kernel changes) |
| `make diff` | Build and show what changed vs current system |
| `make update` | Update flake inputs |
| `make gc` | Remove old generations |
| `make clean` | Garbage-collect the nix store |

## Server safety (`specialserver`)

Servers listed in `SERVER_HOSTS` get additional protection when running `make switch`:

1. **Kernel change detection** — if the new build changes the kernel, the switch is blocked. Use `make deploy` instead, which applies at next boot and reboots cleanly.
2. **Dead man's switch** — before switching, a rollback timer is armed (default 5 min). After a successful switch you must press ENTER to confirm. If you lose connectivity:
   - The system rolls back automatically after 5 minutes
   - If still unreachable 5 minutes after rollback, the server hard-reboots
3. **Fail-closed** — if the closure diff command errors, or the switch itself fails, the rollback stays armed rather than being cancelled.

To manually cancel the safety timers after reconnecting:
```bash
sudo systemctl stop nixos-rollback.timer nixos-failsafe-reboot.timer
```

Timeouts are configurable:
```bash
make switch ROLLBACK_TIMEOUT=10min REBOOT_TIMEOUT=3min
```

# Secrets (agenix)
This repo uses `agenix` for encrypted secrets stored in `secrets/` and decrypted at activation.

## Typical usage
1. **Create a local age key (one time per host)**
   ```bash
   mkdir -p ~/.config/agenix
   age-keygen -o ~/.config/agenix/ageWorkLaptop.key
   ```
2. **Register the host key**
   - Add the public key to `secrets/secrets.nix`.
   - Set `age.identityPaths` in `system/secrets/agenix.nix` (or override per-host).

## Add a new secret
1. Add the secret entry in `secrets/secrets.nix`:
   ```nix
   "secrets/my-secret.age".publicKeys = [ workLaptop ];
   ```
2. Create/edit the encrypted file:
   ```bash
   RULES=secrets/secrets.nix agenix -e secrets/my-secret.age -i ~/.config/agenix/ageWorkLaptop.key
   ```

## Replace/rotate a secret
Re-run `agenix -e` for the same file (it will overwrite the encrypted payload):
```bash
RULES=secrets/secrets.nix agenix -e secrets/my-secret.age -i ~/.config/agenix/ageWorkLaptop.key
```

## Add a new host (second machine)
1. Generate a key on the new host.
2. Add its public key to `secrets/secrets.nix`.
3. Re-encrypt all secrets for the new recipient:
   ```bash
   RULES=secrets/secrets.nix agenix -r -i ~/.config/agenix/ageWorkLaptop.key
   ```
4. Set `age.identityPaths` on that host and rebuild.
