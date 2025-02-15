# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
      [ (modulesPath + "/installer/scan/not-detected.nix")
      ./hardware-optimizations.nix
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

 
  #boot.initrd.luks.devices = {
  #    "luks-78aa9120-4494-4608-9554-0011d0596ed0" = {
  #        device = "/dev/disk/by-uuid/78aa9120-4494-4608-9554-0011d0596ed0";
  #        allowDiscards = true;
  #    };
  #    "luks-abb44ccb-c7a5-44fc-968d-a2c1a676f0a7" = {
  #        device = "/dev/disk/by-uuid/abb44ccb-c7a5-44fc-968d-a2c1a676f0a7";
  #        allowDiscards = true;
  #    };
  #};
# Bootloader.
  boot.loader.systemd-boot.enable = false;

# grub
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    useOSProber = true;
    device = "nodev";
 };
    fileSystems."/" =
    { device = "/dev/nvme0n1p2";
      fsType = "ext4";
  };

  fileSystems."/boot" =
    { device = "/dev/nvme0n1p1";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices =
      [ { 
          device = "/dev/nvme0n1p3";
        }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp6s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp13s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
