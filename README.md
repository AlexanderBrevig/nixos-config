# NixOS Config

NixOS + Home Manager + Hyprland flake for my machines.

## Structure

```
flake.nix
hosts/
  abasus.nix           # ASUS laptop
modules/
  shared.nix           # Common system config
  hyprland.nix         # Hyprland, Wayland, fonts, portal setup
home/
  home.nix             # Home Manager entry point
  programs/            # Per-program configs (fish, helix, git, hyprland, ...)
templates/             # Dev shell templates (rust, go, java, node, ocaml)
```

## Usage

```bash
# Rebuild
sudo nixos-rebuild switch --flake .#abasus

# Update inputs
nix flake update
```

## Adding a new host

1. Create `hosts/<name>.nix` with hardware config and LUKS/filesystem UUIDs
2. Add a `nixosConfigurations.<name>` entry in `flake.nix`
3. Rebuild with `--flake .#<name>`
