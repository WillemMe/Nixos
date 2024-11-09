{ config, pkgs, inputs, ... }:

{
    ##Docker
    virtualisation.docker = {
        enable = true;
        storageDriver = "btrfs";
    };
}