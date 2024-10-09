{ inputs, pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.hyprland;

in {
    options.modules.hyprland= { enable = mkEnableOption "hyprland"; };
    config = mkIf cfg.enable {
	home.packages = with pkgs; [
	    wofi swaybg wlsunset wl-clipboard hyprland hyprpaper hyprlock rofi-wayland kitty
	];

        home.file.".config/hypr/hyprland.conf".source = ./hyprland.conf;
        home.file.".config/hypr/hyprpaper.conf".source = ./hyprpaper.conf;
        home.file.".config/hypr/configs/general.conf".source = ./configs/general.conf;
        home.file.".config/hypr/configs/exec.conf".source = ./configs/exec.conf;
        home.file.".config/hypr/configs/window.conf".source = ./configs/window.conf;
        home.file.".config/hypr/configs/binds.conf".source = ./configs/binds.conf;
    };
}
