{ config, pkgs, inputs, ... }:

{
    # Remove unecessary preinstalled packages
    environment.defaultPackages = [ ];
    services.xserver.desktopManager.xterm.enable = false;
    nixpkgs.config.allowUnfree = true;
    
     # Laptop-specific packages (the other ones are installed in `packages.nix`)
    environment.systemPackages = with pkgs; [
        acpi tlp git kitty
    ] ++ [
    inputs.zen-browser.packages.${system}.specific
    ];


    programs = {
      zsh.enable = true;
      hyprland = {
        enable = true;
        xwayland.enable = true;
      };  
      nix-ld.enable = true;
      hyprlock.enable = true;
      git.enable = true;
      wireshark.enable = true;
      nm-applet.enable = true;
      virt-manager.enable = true;
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

    hardware.rtl-sdr.enable = true;
    boot.blacklistedKernelModules = [ "dvb_usb_rtl28xxu" ];
    #services.udev.packages = [ pkgs.rtl-sdr ];

    #services.qemuGuest.enable = true;
    #services.spice-vdagentd.enable = true;
    services.gnome.gnome-keyring.enable = true;
    
    virtualisation.spiceUSBRedirection.enable = true;
    ##Docker
    virtualisation.docker = {
        enable = true;
    };
    hardware.nvidia-container-toolkit.enable = true;

    virtualisation.libvirtd = {
        enable = true;  
      qemu = {
        package = pkgs.qemu_kvm;
        vhostUserPackages = [ pkgs.virtiofsd ];
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [(pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd];
        };
      };  
    };
    programs.dconf = {
        enable = true; # virt-manager requires dconf to remember settings
    };
    
    services.udev = {
        packages = with pkgs; [ platformio-core openocd teensy-udev-rules];
   };
   
    services.greetd = {
    enable = true;
    settings = {
      default_session = {
          command = ''${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland -r --asterisks --user-menu --theme border=magenta;text=cyan;prompt=green;time=red;action=blue;button=yellow;container=black;input=red'';
        user = "greeter";
      };
    };
    };

    # Install fonts
    fonts = {
        packages = with pkgs; [
            jetbrains-mono
            roboto
            openmoji-color
            (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
        ];

        fontconfig = {
            hinting.autohint = true;
            defaultFonts = {
              emoji = [ "OpenMoji Color" ];
            };
        };
    };

    # Nix settings, auto cleanup and enable flakes
    nix = {
        settings.auto-optimise-store = true;
        settings.allowed-users = [ "willem" ];
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


    # Set up locales (timezone and keyboard layout)
    time.timeZone = "Europe/Amsterdam";
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
        font = "Lat2-Terminus16";
        keyMap = "us";
    };

    # Set up user and enable sudo
    users.users.willem = {
        isNormalUser = true;
        extraGroups = [ "input" "wheel" "networkmanager" "plugdev" "wireshark" "docker" "libvirtd" "video" "dialout"];
        shell = pkgs.zsh;
    };

    # Set up networking and secure it
    networking = {
        networkmanager = {
            enable = true;
            #logLevel = "DEBUG";
        };
        wireless.dbusControlled = true;
        firewall = {
            enable = false;
            allowedTCPPorts = [ 443 80 ];
            allowedUDPPorts = [ 443 80 44857 ];
            allowPing = false;
        };
        extraHosts =
            ''
                10.10.0.111 vault
                10.20.0.101 pc
                127.0.0.1   lo
                127.0.0.1   lo.dorp.me
            '';
    };

    # Set environment variables
    environment.variables = {
        NIXOS_CONFIG = "$HOME/.config/nixos/configuration.nix";
        NIXOS_CONFIG_DIR = "$HOME/.config/nixos/";
        XDG_DATA_HOME = "$HOME/.local/share";
        PASSWORD_STORE_DIR = "$HOME/.local/share/password-store";
        GTK_RC_FILES = "$HOME/.local/share/gtk-1.0/gtkrc";
        GTK2_RC_FILES = "$HOME/.local/share/gtk-2.0/gtkrc";
        MOZ_ENABLE_WAYLAND = "1";
        ZK_NOTEBOOK_DIR = "$HOME/stuff/notes/";
        EDITOR = "nvim";
        DIRENV_LOG_FORMAT = "";
        ANKI_WAYLAND = "1";
        DISABLE_QT5_COMPAT = "0";
        GSK_RENDERER= "ngl";
        NIXPKGS_ALLOW_UNFREE="1";
    };

    # Security 
    security = {
        sudo.enable = true;
        #doas = {
        #    enable = true;
        #    extraRules = [{
        #        users = [ "willem" ];
        #        keepEnv = true;
        #        persist = true;
        #    }];
        #};

        # Extra security
        protectKernelImage = true;
    };

    #hardware.pulseaudio.enable = true;
    security.rtkit.enable = true;

    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
    };
    
    # Disable bluetooth, enable pulseaudio, enable opengl (for Wayland)
    hardware = {
        bluetooth = {
            enable = true;
            powerOnBoot = true;
        };
       # opengl = {
       #     enable = true;
       #     driSupport = true;
       # };
    };

    # Do not touch
    system.stateVersion = "24.05";
}
