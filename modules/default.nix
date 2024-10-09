{ inputs, pkgs, config, ... }:

{
    home.stateVersion = "24.05";
    imports = [
        # gui
        ./firefox
        ./foot
        ./eww
        ./dunst
        ./hyprland
        ./rofi
        ./kitty

        # cli
        ./nvim
        ./zsh
        ./git
        ./gpg
        ./direnv

        # system
        ./xdg
        ./packages
    ];
}
