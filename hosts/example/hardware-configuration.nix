# Placeholder hardware configuration.
#
# DO NOT USE THIS FILE AS-IS. Replace it entirely with the output of:
#   sudo nixos-generate-config --show-hardware-config > hosts/<your-host>/hardware-configuration.nix
#
# This stub only exists so the flake evaluates without a real machine.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.loader.grub.enable = true;
  boot.initrd.availableKernelModules = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  swapDevices = [ ];
}
