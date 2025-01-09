{ config, pkgs, inputs, ... }:

{
     networking.wg-quick.interfaces = {
       wg-homelab = {
         address = [ "10.20.0.100/24" ];
         privateKeyFile = "/root/wireguard/priv.key";
         listenPort = 55934;
         peers = [
           {
             publicKey = "PbfzZPPMEN+5iYdbkzxr/HtmUpUao5+eAdXEUJ5oJxA=";
             #allowedIPs = [ "0.0.0.0/0" "::/0" ]; #Every thing

             allowedIPs = [ "10.20.0.1/32" "10.20.0.0/24" ]; 
             endpoint = "149.102.157.98:55555";
             persistentKeepalive = 25;
           }
         ];
       };
     };

    ##Docker
    virtualisation.docker = {
        enable = true;
        storageDriver = "btrfs";
    };
}
