{
  pkgs,
  lib,
  config,
  username,
  ...
}:
with lib;
let
  cfg = config.modules.vm;
in
{
  options.modules.vm = {
    enable = mkEnableOption "vm";
  };
  config = mkIf cfg.enable {
    programs.virt-manager.enable = true;
    programs.dconf.enable = true;
    virtualisation = {
      spiceUSBRedirection.enable = true;
      libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          vhostUserPackages = [ pkgs.virtiofsd ];
          runAsRoot = true;
          swtpm.enable = true;
          #ovmf = {
          #  enable = true;
          #  packages = [
          #    (pkgs.OVMF.override {
          #      secureBoot = true;
          #      tpmSupport = true;
          #    }).fd
          #  ];
          #};
        };
      };
    };

    systemd.services.libvirtd.environment = {
      LD_LIBRARY_PATH = "/run/opengl-driver/lib:/run/opengl-driver-32/lib";
      LIBGL_DRIVERS_PATH = "/run/opengl-driver/lib/dri";
    };

    users.users.${username}.extraGroups = [
      "libvirtd"
      "kvm"
    ];
  };
}
