{ config, pkgs, inputs, ... }:

{
    imports = [
        ./wireguard.nix
    ];
    ##Docker
    virtualisation.docker = {
        enable = true;
        #storageDriver = "btrfs";
    };

    networking.interfaces.enp6s0.wakeOnLan = {
        enable = true;
        policy = ["magic"];
    };

    programs = {
      steam = {
          enable = true;
          remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
          dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
          localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
      };
    };
}
