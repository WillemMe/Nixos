{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.noctalia-greeter;
in
{
  imports = [ inputs.noctalia-greeter.nixosModules.default ];

  options.modules.noctalia-greeter = { enable = mkEnableOption "noctalia-greeter"; };

  config = mkIf cfg.enable {
    # Module auto-enables services.greetd and services.accounts-daemon and
    # points greetd at the noctalia-greeter-session wrapper.
    programs.noctalia-greeter = {
      enable = true;
      settings = {
        # Matches the graphite-dark cursor set for the desktop session via
        # stylix in home-dots/home-modules/desktop-env/hyprland/default.nix.
        cursor = {
          theme = "graphite-dark";
          size = 24;
          path = "${pkgs.graphite-cursors}/share/icons";
        };
        keyboard.layout = "us";
        # Skips the session picker — matches the old tuigreet setup, which
        # hardcoded `--cmd start-hyprland`. Must match the desktop entry's
        # Name= exactly (confirmed: share/wayland-sessions/hyprland.desktop).
        session.default = "Hyprland";
      };
    };
  };
}
