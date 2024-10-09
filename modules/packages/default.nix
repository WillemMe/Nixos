{ pkgs, lib, config, ... }:

with lib;
let cfg = 
    config.modules.packages;
    screen = pkgs.writeShellScriptBin "screen" ''${builtins.readFile ./screen}'';
    bandw = pkgs.writeShellScriptBin "bandw" ''${builtins.readFile ./bandw}'';
    maintenance = pkgs.writeShellScriptBin "maintenance" ''${builtins.readFile ./maintenance}'';
    rofi-power-menu = pkgs.writeShellScriptBin "rofi-power-menu" ''${builtins.readFile ./rofi-power-menu}'';
in {
    options.modules.packages = { enable = mkEnableOption "packages"; };
    config = mkIf cfg.enable {
    	home.packages = with pkgs; [
            ripgrep ffmpeg tealdeer
            eza htop fzf
            pass gnupg bat
            unzip lowdown zk
            grim slurp slop
            imagemagick age libnotify
            git python3 lua zig 
            mpv pqiv
            screen bandw maintenance
            wf-recorder anki-bin
            #Applications
            obsidian discord virt-manager
            thunderbird nextcloud-client spotify
            wireshark burpsuite rustdesk
            #Libreoffice
            libreoffice hunspell
            hunspellDicts.nl_nl hunspellDicts.en_US

        ];
    };
}
