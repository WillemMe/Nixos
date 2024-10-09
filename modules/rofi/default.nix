{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.rofi;

in {
    options.modules.rofi = { enable = mkEnableOption "rofi"; };
    config = mkIf cfg.enable {
      home.file.".config/rofi/colors.rasi".source = ./colors.rasi;
      home.file.".config/rofi/config.rasi".source = ./config.rasi;
      home.file.".config/rofi/fonts.rasi".source = ./fonts.rasi;
    };
}
