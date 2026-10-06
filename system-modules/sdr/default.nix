{ pkgs, lib, config, username, ... }:

with lib;
let cfg = config.modules.sdr;

in {
  options.modules.sdr = { enable = mkEnableOption "sdr"; };
  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      rtl-sdr-blog
      airspy
      sdrpp
      multimon-ng
      flac
    ];

    hardware.rtl-sdr.enable = true;
    boot.blacklistedKernelModules = [ "dvb_usb_rtl28xxu" ];
    services.udev.extraRules = ''
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="2838", ENV{ID_SOFTWARE_RADIO}="1", MODE="0660", GROUP="plugdev"
        '';

      users.users.${username}.extraGroups = [ "plugdev" ];
    };
}
