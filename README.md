# :: nixcfg 🛠

The various Nix crimes that make my Infrastructure work.

# > installing a machine

After booting a `nixos-installer` or any distro that supports `kexec`,
installing can be done using `nixos-anywhere`:

```bash
#> pre-generate a hostkey for initrd decryption
temp=$(mktemp -d)
mkdir -p "$temp"/etc/secrets/initrd
ssh-keygen -N "" -t ed25519 -f "$temp"/etc/secrets/initrd/ssh_host_ed25519_key

nix run github:nix-community/nixos-anywhere -- \
    --generate-hardware-config nixos-facter ./confs/<machine>/facter.json \
    --extra-files "$temp" --flake .#<machine> --target-host nixos@<ip>
```
