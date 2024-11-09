{ pkgs, lib, config, ... }:

with lib;
let cfg = 
    config.modules.packages;
in {
    options.modules.packages = { enable = mkEnableOption "packages"; };
    config = mkIf cfg.enable {
        home.packages = with pkgs; [
            ripgrep ffmpeg tealdeer
            eza htop fzf
            pass gnupg bat
            unzip lowdown zk
            usbutils
            grim slurp slop
            imagemagick age libnotify
            git python3 lua zig file 
            mpv pqiv libqalculate
           #wf-recorder 
            anki-bin
            #Applications
            obsidian virt-manager
            vesktop # for discord screen share
            thunderbird nextcloud-client spotify
            burpsuite wireshark
            #Libreoffice
            libreoffice hunspell
            hunspellDicts.nl_nl hunspellDicts.en_US
            neofetch mission-center
            arduino-ide

            #Hacking tools
            proxychains
        ];
    };
}
