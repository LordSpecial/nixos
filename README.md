# Installation
1. Clone repo, such as into `~/.config/nixos`
2. create a symlink `sudo ln -s ~/.config/nixos/ /etc/`
    * you may need to `sudo chown -R simon:users ~/.config/nixos/`

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
