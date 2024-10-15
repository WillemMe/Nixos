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
        ./vscode

        # cli
        ./nvim
        ./zsh
        ./git
        ./gpg
        ./direnv
        ./joshuto
        ./hacking

        # system
        ./xdg
        ./packages
        ./scripts
    ];
}
