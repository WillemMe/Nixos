

{ config, pkgs, lib, ... }:

with lib;
let
  # Path to the source files (can be a local directory or fetched from a repo)
  cfg = config.modules.rofi;

in {
  options.modules.eww = { enable = mkEnableOption "eww"; };
  config = mkIf cfg.enable {
   # Declare this as a Home Manager module
   home.packages = with pkgs; [
     # Add eww and any other dependencies here
     eww upower socat
     jaq ripgrep bluez
     bc networkmanager pulseaudio
     wireplumber material-symbols
   ];

   # Managing individual files
   home.file.".config/eww/eww.scss".source = ./eww.scss;
   home.file.".config/eww/eww.yuck".source = ./eww.yuck;
   home.file.".config/eww/launch".source = ./launch;

   # Managing directories: assets, css, dashboard, modules, scripts, windows
   home.file.".config/eww/assets".source = ./assets;
   home.file.".config/eww/css".source = ./css;
   home.file.".config/eww/modules".source = ./modules;
   home.file.".config/eww/scripts".source = ./scripts;
   home.file.".config/eww/windows".source = ./windows;

  # systemd.user.services.eww = {
  #   Unit = {
  #     Description = "Eww bar";
  #     After = [ "graphical-session.target" ];
  #   };
  #   Service = {
  #     ExecStart = "${eww}/launch";
  #     Restart = "always";
  #     RestartSec = 5;
  #   };
  #   Install = {
  #     WantedBy = [ "default.target" ];
  #   };
  # };

   home.sessionVariables = {
     EWW_CONFIG_DIR = "${config.home.homeDirectory}/.config/eww";
   };
   
   #systemd.user.services.eww.enable = true;
  };
}
