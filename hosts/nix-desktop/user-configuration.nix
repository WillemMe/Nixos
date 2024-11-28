{ config, pkgs, inputs, ... }:

{
   ##Docker
    virtualisation.docker = {
        enable = true;
        #storageDriver = "btrfs";
    };

    networking.interfaces.enp6s0.wakeOnLan = {
        enable = true;
        policy = ["magic"];
    };

    networking.wg-quick.interfaces = {
       wg-homelab = {
         address = [ "10.20.0.101/24" ];
         privateKeyFile = "/root/wireguard/priv.key";
         listenPort = 55934;
         peers = [
           {
             publicKey = "PbfzZPPMEN+5iYdbkzxr/HtmUpUao5+eAdXEUJ5oJxA=";
             #allowedIPs = [ "0.0.0.0/0" "::/0" ]; #Every thing

             allowedIPs = [ "10.20.0.1/32" "10.20.0.100/32" ]; 
             endpoint = "149.102.157.98:55555";
             persistentKeepalive = 25;
           }
         ];
       };
     };

    services.openssh = {
        enable = true;
        ports = [ 22 ];
        settings = {
            PasswordAuthentication = true;
            AllowUsers = [ "willem" ]; # Allows all users by default. Can be [ "user1" "user2" ]
            UseDns = true;
            X11Forwarding = false;
            PermitRootLogin = "no"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
        };
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
