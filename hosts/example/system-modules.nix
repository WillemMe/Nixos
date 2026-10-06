{ config, lib, inputs, ... }:

{
  imports = [ ../../system-modules/default.nix ];
  config.modules = {
    hyprland.enable = true;
    docker.enable = true;
    vm.enable = false;
    sdr.enable = false;
    kubernetes.enable = false;
    hw-dev.enable = false;
    hacking.enable = false;
    via.enable = false;
    noctalia.enable = true;
    noctalia-greeter.enable = true;
    greetd.enable = false; # replaced by noctalia-greeter
  };
}
