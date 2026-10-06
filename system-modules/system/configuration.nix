{
  config,
  pkgs,
  inputs,
  username,
  ...
}:
{
  # Remove unecessary preinstalled packages
  environment.defaultPackages = [ ];
  services.xserver.desktopManager.xterm.enable = false;
  nixpkgs.config.allowUnfree = true;

  # Laptop-specific packages (the other ones are installed in `packages.nix`)
  environment.systemPackages = with pkgs; [
    nixpkgs-fmt
    linuxKernel.packages.linux_zen.usbip
  ];

  programs = {
    zsh.enable = true;
    git.enable = true;
    nix-ld.enable = true;
  };

  # Nix settings, auto cleanup and enable flakes
  nix = {
    settings = {
      auto-optimise-store = true;
      allowed-users = [ "${username}" ];
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
      extra-substituters = [ "https://noctalia.cachix.org" ];
      extra-trusted-public-keys = [
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  # Install fonts
  fonts = {
    packages = with pkgs; [
      jetbrains-mono
      roboto
      nerd-fonts.jetbrains-mono
      noto-fonts-color-emoji
      texlivePackages.lobster2
    ];

    fontconfig = {
      hinting.autohint = true;
      defaultFonts = {
        emoji = [ "Noto Emoji Color" ];
      };
    };
  };

  # Set up locales (timezone and keyboard layout)
  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Set up user and enable sudo
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "input"
      "wheel"
      "networkmanager"
      "wireshark"
    ];
    shell = pkgs.zsh;
  };

  # Set up networking and secure it
  networking = {
    networkmanager = {
      enable = true;
    };
    wireless.dbusControlled = true;
    firewall = {
      enable = false;
      allowedTCPPorts = [
        443
        80
      ];
      allowedUDPPorts = [
        443
        80
        44857
      ];
      allowPing = true;
    };
    extraHosts = ''
      # Add your own LAN/host aliases here.
      127.0.0.1   lo
    '';
  };

  # Set environment variables
  environment = {
    variables = {
      NIXOS_CONFIG_DIR = "$HOME/.config/nixos/";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      PASSWORD_STORE_DIR = "$HOME/.local/share/password-store";
      GTK_RC_FILES = "$HOME/.local/share/gtk-1.0/gtkrc";
      GTK2_RC_FILES = "$HOME/.local/share/gtk-2.0/gtkrc";
      MOZ_ENABLE_WAYLAND = "1";
      EDITOR = "nvim";
      DIRENV_LOG_FORMAT = "";
      ANKI_WAYLAND = "1";
      DISABLE_QT5_COMPAT = "0";
      GSK_RENDERER = "ngl";
      NIXPKGS_ALLOW_UNFREE = "1";
      LD_LIBRARY_PATH = "${pkgs.gcc15Stdenv.cc.cc.lib}/lib:${pkgs.stdenv.cc.cc.lib}/lib:/run/opengl-driver/lib";
    };
    sessionVariables.NIXOS_OZONE_WL = "1";
  };

  # Security
  security = {
    sudo.enable = true;
    protectKernelImage = true;
  };

  # Output devices

  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        mesa
        libGL
        glibc
      ];
    };
  };
  services.pcscd.enable = true; # Allow yubikey to be read as smart card

  system.stateVersion = "26.05";
}
