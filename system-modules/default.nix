{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./docker
    ./greetd
    ./hacking
    ./hw-dev
    ./hyprland
    ./noctalia
    ./noctalia-greeter
    ./sdr
    ./vm
    ./kubernetes
    ./via
  ];
}
