# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
      [ (modulesPath + "/installer/scan/not-detected.nix")
        ./hardware-optimizations.nix
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usbhid" "usb_storage" "aesni_intel" "cryptd" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

# grub
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    extraGrubInstallArgs = ["--disable-shim-lock"]; 
 };


  boot.initrd.luks.devices = {
    cryptlvm = {
      device = "/dev/disk/by-uuid/2ac07984-f83a-476c-8f8c-b7604ea46a08";
      preLVM = true;
      allowDiscards = true;
    };
    home = {
      device = "/dev/disk/by-uuid/c46db88f-099f-4407-88e3-66c5b6a783d0";
      preLVM = true;
      allowDiscards = true;
    };
  };

  fileSystems."/" =
    { device = "/dev/vg1/root";
      fsType = "btrfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/9FF8-BD5A";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  fileSystems."/home" =
    { device = "/dev/vg2/home";
      fsType = "btrfs";
    };

#  fileSystems."/home/willem/The Vault/Photos" =
#    { device = "//vault/Photos";
#      fsType = "cifs";
#    };

#  fileSystems."/home/willem/The Vault/Backup" =
#    { device = "//vault/Backup";
#      fsType = "cifs";
#    };

#  fileSystems."/home/willem/The Vault/Documents" =
#    { device = "//vault/Documents";
#      fsType = "cifs";
#    };

  swapDevices =
    [ { device = "/dev/vg1/swap"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.br-11899c465c2d.useDHCP = lib.mkDefault true;
  # networking.interfaces.br-21ce49000683.useDHCP = lib.mkDefault true;
  # networking.interfaces.br-2962ed1ac19f.useDHCP = lib.mkDefault true;
  # networking.interfaces.br-2ec4d89f8884.useDHCP = lib.mkDefault true;
  # networking.interfaces.br-5077600cb9e1.useDHCP = lib.mkDefault true;
  # networking.interfaces.br-985a0c071f54.useDHCP = lib.mkDefault true;
  # networking.interfaces.br-d23d5cca46a2.useDHCP = lib.mkDefault true;
  # networking.interfaces.br-d631b333b659.useDHCP = lib.mkDefault true;
  # networking.interfaces.br-e8e1285306ee.useDHCP = lib.mkDefault true;
  # networking.interfaces.docker0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlan0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
