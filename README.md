# nixos

NixOS system configuration (hosts, hardware, system-level services).
Home-manager / dotfiles live in a separate flake input (`home-flake`) and are
not part of this repo.

## Structure

```
nixos/
├── flake.nix                  # Host definitions and flake inputs
├── hosts/
│   └── example/               # Example host: hardware config + system-module toggles
├── system-modules/
│   ├── docker/              # Container runtime
│   ├── greetd/              # Display manager (tuigreet)
│   ├── noctalia/            # Noctalia shell
│   ├── noctalia-greeter/    # Noctalia login greeter
│   ├── hyprland/            # Hyprland window manager
│   ├── hacking/             # Pentesting / security tooling
│   ├── hw-dev/              # Hardware dev tools
│   ├── sdr/                 # Software-defined radio tooling
│   ├── vm/                  # Virtualisation (qemu/libvirt)
│   ├── kubernetes/          # Kubernetes tooling
│   ├── via/                 # Keyboard configurator
│   └── _template/           # Skeleton for new modules
└── overlays/                # Package overlays (e.g. apple-color-emoji)
```

## Hosts

Each host only sets which `system-modules` are enabled plus its own hardware
config.

| Host      | Role     | Notable modules enabled              |
| --------- | -------- | ------------------------------------ |
| `example` | Template | hyprland, noctalia(-greeter), docker |

Copy `hosts/example` as a starting point for your own host(s) — see "Adding a
new host" below.

## System modules

Modules live under `system-modules/<name>` and are toggled per-host via
`config.modules.<name>.enable` in `hosts/<host>/system-modules.nix`. New modules
follow the skeleton in `system-modules/_template/default.nix`:

```nix
{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.PROGRAM;
in {
  options.modules.PROGRAM = { enable = mkEnableOption "PROGRAM"; };
  config = mkIf cfg.enable { };
}
```

1. Copy `_template` to `system-modules/<name>`, fill it in.
2. Add it to the `imports` list in `system-modules/default.nix`.
3. Enable it on whichever host(s) need it in `hosts/<host>/system-modules.nix`.

## Home-manager

User-level configuration (shell, editor, desktop apps, theming) is managed by a
separate home-manager flake, wired in via the `home-flake` input in `flake.nix`
and applied automatically through `home-manager.nixosModules.home-manager` on
`nixos-rebuild switch`.

## Adding a new host

1. Add an entry to `nixosConfigurations` in `flake.nix`:

```nix
my-host = mkNixOS {
  pkgs = inputs.nixpkgs;
  system = "x86_64-linux";
  hostname = "my-host";
  username = "myuser";
};
```

2. Create the host directory with its own hardware config and module toggles:

```bash
mkdir hosts/my-host
sudo nixos-generate-config --show-hardware-config > hosts/my-host/hardware-configuration.nix
```

```nix
# hosts/my-host/system-modules.nix
{ config, lib, inputs, ... }: {
  imports = [ ../../system-modules/default.nix ];
  config.modules = {
    hyprland.enable = true;
    # ...
  };
}
```

```nix
# hosts/my-host/user-configuration.nix
{ config, pkgs, inputs, ... }: {
  # host-specific system config (networking, virtualisation, etc)
}
```

> Hardware configs are host-specific (drives, kernel modules, bootloader). Never
> reuse another host's `hardware-configuration.nix`.

3. Build and switch:

```bash
sudo nixos-rebuild switch --flake .#my-host
```

## Rebuilding

```bash
sudo nixos-rebuild switch --flake .#<hostname>
```

## Credits

Special thanks to Notusknot for dotfile outline:

- [Notusknot dotfiles](https://github.com/notusknot/dotfiles-nix/)
