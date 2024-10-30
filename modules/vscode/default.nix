{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.vscode;

in {
    options.modules.vscode = { enable = mkEnableOption "vscode"; };
    config = mkIf cfg.enable {
        programs.vscode = {
            enable = true;
            extensions = with pkgs; [
               # vscode-extensions.github.copilot
               # vscode-extensions.github.copilot-chat 
                vscode-extensions.ms-vsliveshare.vsliveshare
                vscode-extensions.bradlc.vscode-tailwindcss
                vscode-extensions.james-yu.latex-workshop
            ];
        };
    };
}
