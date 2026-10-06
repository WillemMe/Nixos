{
  inputs,
  pkgs,
  lib,
  config,
  username,
  ...
}:
with lib;
let
  cfg = config.modules.hyprland;
in
{
  options.modules.hyprland = {
    enable = mkEnableOption "hyprland";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      acpi
      tlp
      kitty
      bluez
    ];

    programs = {
      hyprland = {
        enable = true;
        xwayland.enable = true;
      };
      hyprlock = {
        enable = true;
      };
      nm-applet.enable = true;
    };

    #All nerdfonts
    fonts.packages =
      [ ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

    services.gnome.gnome-keyring.enable = true;

    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    hardware = {
      enableAllFirmware = true;
      brillo.enable = true; # Allow user to control screen brightness
      bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {
          General = {
            Experimental = false;
            FastConnectable = false;
          };
          Policy = {
            # Enable all controllers when they are found. This includes
            # adapters present on start as well as adapters that are plugged
            # in later on. Defaults to 'true'.
            AutoEnable = true;
          };
        };
      };
    };
    users.users.${username}.extraGroups = [ "video" ];
  };
}
