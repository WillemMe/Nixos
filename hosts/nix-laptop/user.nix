{ config, lib, inputs, ...}:
#Home Manager
{
    imports = [ ../../modules/default.nix ];
    config.modules = {
        # gui
        firefox.enable = true;
        foot.enable = true;
        eww.enable = true;
        dunst.enable = true;
        hyprland.enable = true;
        rofi.enable = true;
        kitty.enable = true;
        vscode.enable = true;

        # cli
        nvim.enable = true;
        zsh.enable = true;
        git.enable = true;
        gpg.enable = false;
        direnv.enable = true;
        joshuto.enable = true;
        hacking.enable = true;
        qemu.enable = true;

        # system
        xdg.enable = true;
        packages.enable = true;
        scripts.enable = true;
    };
}
