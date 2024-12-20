{
    description = "NixOS configuration";

    # All inputs for the system
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        catppuccin.url = "github:catppuccin/nix";
        zen-browser.url = "github:MarceColl/zen-browser-flake";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
 
    };

    # All outputs for the system (configs)
    outputs = { home-manager, catppuccin,nixpkgs,  ... }@inputs: 
        let
            system = "x86_64-linux"; #current system
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            lib = nixpkgs.lib;

            # This lets us reuse the code to "create" a system
            # Credits go to sioodmy on this one!
            # https://github.com/sioodmy/dotfiles/blob/main/flake.nix
            mkSystem = pkgs: system: hostname:
                pkgs.lib.nixosSystem {
                    system = system;
                    modules = [
                        { networking.hostName = hostname; }
                        # General configuration (users, networking, sound, etc)
                        ./modules/system/configuration.nix

                        # User space hardware specific services
                        (./. + "/hosts/${hostname}/user-configuration.nix")

                        # Hardware config (bootloader, kernel modules, filesystems, etc)
                        # DO NOT USE MY HARDWARE CONFIG!! USE YOUR OWN!!
                        (./. + "/hosts/${hostname}/hardware-configuration.nix")

                        ## Theme
                        catppuccin.nixosModules.catppuccin

                        home-manager.nixosModules.home-manager
                        {
                            home-manager = {
                                useUserPackages = true;
                                useGlobalPkgs = true;
                                backupFileExtension = "backup";
                                extraSpecialArgs = { inherit inputs; };
                                # Home manager config (configures programs like firefox, zsh, eww, etc)
                                users.willem = {
                                  imports = [
                                    (./. + "/hosts/${hostname}/user.nix")
                                    catppuccin.homeManagerModules.catppuccin
                                  ];
                                };
                                
                            };
                            #nixpkgs.overlays = [
                            #    # Add nur overlay for Firefox addons
                            #    nur.overlay
                            #    (import ./overlays)
                            #];
                        }
                    ];
                    specialArgs = { inherit inputs; };
                };

        in {
            nixosConfigurations = {
                # Now, defining a new system is can be done in one line
                #                                Architecture   Hostname
                desktop = mkSystem inputs.nixpkgs "x86_64-linux" "desktop";

                nix-desktop = mkSystem inputs.nixpkgs "x86_64-linux" "nix-desktop";
                nix-laptop = mkSystem inputs.nixpkgs "x86_64-linux" "nix-laptop";
            };
    };
}
