{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.qemu;

in {
    options.modules.qemu = { enable = mkEnableOption "qemu"; };
    config = mkIf cfg.enable {
        dconf.settings = {
            "org/virt-manager/virt-manager/connections" = {
            autoconnect = ["qemu:///system"];
            uris = ["qemu:///system"];
        };
        };
    };
}
