{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.hacking;
in {
  options.modules.hacking = {enable = mkEnableOption "hacking";};
  config =
    mkIf cfg.enable
    {
      programs = {
        wireshark.enable = true;

        proxychains = {
          enable = true;
          quietMode = true;
          proxies = {
            local = {
              enable = true;
              type = "socks5";
              host = "127.0.0.1";
              port = 1080;
            };
          };
        };
      };

      environment.systemPackages = with pkgs; [
        nmap
        whois
        dig

        # Reverse engineering
        hydra
        cutter

        # Password cracking
        john
        hashcat

        # Web hacking
        sqlmap
        burpsuite
        gobuster
        dirbuster
        wpscan
        dnsenum
        aircrack-ng
        metasploit

        wordlists
      ];

      lib.
      networking.firewall.enable = lib.mkOverride false;
    };
}
