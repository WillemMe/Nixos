{ pkgs, lib, config, ... }:
with lib;
let 
  cfg = config.modules.zsh;
 
in {
    options.modules.zsh = { enable = mkEnableOption "zsh"; };

    config = mkIf cfg.enable {
    	home.packages = with pkgs; [
          libnotify            # dependecy for notify-send
          zoxide               # the better cd
          fzf                  # zoxide dependecy
          nix-output-monitor   # colorful nix build outputs
          eza                  # better ls
          bat                  # better cat
          trashy
          expect
          ];
        programs.zoxide = {
          enable = true;
          options = ["--cmd cd"];
        };
        programs.zsh = {
            enable = true;

            # directory to put config files in
            dotDir = ".config/zsh";

            enableCompletion = true;
            autosuggestion.enable = true;
            syntaxHighlighting.enable = true;

            # .zshrc
            initExtra = ''
                PROMPT="%F{blue}%m %~%b "$'\n'"%(?.%F{green}%Bλ%b |.%F{red}?) %f"

                export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store";
                bindkey '^ ' autosuggest-accept
                bindkey '^R' history-incremental-search-backward
                
                edir() { tar -cz $1 | age -p > $1.tar.gz.age && rm -rf $1 &>/dev/null && echo "$1 encrypted" }
                ddir() { age -d $1 | tar -xz && rm -rf $1 &>/dev/null && echo "$1 decrypted" }
            '';

            # basically aliases for directories: 
            # `cd ~dots` will cd into ~/.config/nixos
            dirHashes = {
                dots = "$HOME/.config/nixos";
            };

            # Tweak settings for history
            history = {
                save = 10000;
                size = 10000;
                path = "$HOME/.cache/zsh_history";
            };

            # Set some aliases
            shellAliases = {
                c = "clear";
                mkdir = "mkdir -vp";
                rm = "trash";
                rmr = "trash list | fzf --multi | awk '{$1=$1;print}' | rev | cut -d ' ' -f1 | rev | xargs trash restore --match=exact --force";
                mv = "mv -iv";
                cp = "cp -riv";
                cat = "bat --paging=never --style=plain";
                ls = "exa -a --icons";
                tree = "exa --tree --icons";
                #Devops
                g = "git";
                nd = "nix develop -c $SHELL";
                switch = "sudo nixos-rebuild switch --flake ~dots --fast";
                rebuild = "sudo -v && sudo nixos-rebuild switch --flake ~dots --fast --log-format internal-json -v |& nom --json &&  notify-send -a NixOS 'Rebuild complete\!'";
                update = "sudo nix flake update --commit-lock-file -I ~dots; switch; notify-send -a NixOS 'System updated\!'";
                nix-shell ="nix-shell --run zsh";
                #Programs
              };
    };
};
}
