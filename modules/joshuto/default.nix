{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.joshuto;

in {
    options.modules.joshuto = { enable = mkEnableOption "joshuto"; };
    config = mkIf cfg.enable {
      home.packages = with pkgs; [
        # Add joshuto package or any other dependencies
        joshuto
      ];

      programs.zsh = {
        shellAliases = {
          jo = "joshuto";
        };
      };

      # Managing individual files using relative paths (relative to the Nix file)
      home.file.".config/joshuto/bookmarks.toml".source = ./bookmarks.toml;
      home.file.".config/joshuto/icons.toml".source = ./icons.toml;
      home.file.".config/joshuto/joshuto.toml".source = ./joshuto.toml;
      home.file.".config/joshuto/keymap.toml".source = ./keymap.toml;
      home.file.".config/joshuto/mimetype.toml".source = ./mimetype.toml;
      
      # Managing shell scripts
      home.file.".config/joshuto/jo_wrapper.sh".source = ./jo_wrapper.sh;
      home.file.".config/joshuto/on_preview_removed.sh".source = ./on_preview_removed.sh;
      home.file.".config/joshuto/on_preview_shown.sh".source = ./on_preview_shown.sh;
      home.file.".config/joshuto/preview_file.sh".source = ./preview_file.sh;
      
      # Make the scripts executable (just to ensure proper permissions)
      home.file.".config/joshuto/jo_wrapper.sh".executable = true;
      home.file.".config/joshuto/on_preview_removed.sh".executable = true;
      home.file.".config/joshuto/on_preview_shown.sh".executable = true;
      home.file.".config/joshuto/preview_file.sh".executable = true;
    
    };

}
