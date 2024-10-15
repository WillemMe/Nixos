{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.hacking;

in {
    options.modules.hacking = { enable = mkEnableOption "hacking"; };
    config = mkIf cfg.enable {
        home.packages = with pkgs; [
	        nmap
	    ];
    };
}
