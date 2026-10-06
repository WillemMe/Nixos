{
  description = "NixOS configuration";

  # All inputs for the system
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    voxtype.url = "github:peteonrails/voxtype";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Point this at your own home-manager flake (local path or git URL).
    home-flake = {
      url = "path:/home/<you>/.config/home-dots";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    stylix = {
      url = "github:nix-community/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    affinity-nix = {
      url = "github:mrshmllow/affinity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # No nixpkgs.follows: overriding a noctalia input changes its derivation
    # hash and causes a total miss against the noctalia.cachix.org binary
    # cache. The cachix branch always points at the newest cached commit.
    noctalia.url = "github:noctalia-dev/noctalia/cachix";
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # All outputs for the system (configs)
  outputs =
    {
      home-manager,
      nixpkgs,
      home-flake,
      voxtype,
      affinity-nix,
      ...
    }@inputs:
    let
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      lib = nixpkgs.lib;

      mkNixOS =
        {
          pkgs,
          system,
          hostname,
          username,
        }:
        pkgs.lib.nixosSystem {
          system = system;
          modules = [
            { networking.hostName = hostname; }
            {
              _module.args.username = username;
            }
            voxtype.nixosModules.default

            #({ pkgs, ... }: {
            #  nixpkgs.overlays = [ affinity-nix.overlays.default ];

            #  environment.systemPackages = [ pkgs.affinity-v3 ];
            #})
            # General configuration (users, networking, sound, etc)
            ./system-modules/system/configuration.nix

            # User space hardware specific services
            (./. + "/hosts/${hostname}/user-configuration.nix")

            # User space system modules
            (./. + "/hosts/${hostname}/system-modules.nix")

            # Hardware config (bootloader, kernel modules, filesystems, etc)
            # DO NOT USE MY HARDWARE CONFIG!! USE YOUR OWN!!
            (./. + "/hosts/${hostname}/hardware-configuration.nix")

            ## Theme
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useUserPackages = true;
                useGlobalPkgs = true;
                backupFileExtension = "backup";
                extraSpecialArgs = { inherit inputs; };
                users."${username}" = home-flake.homeManagerModules."${username}@${hostname}";
              };
            }
          ];
          specialArgs = { inherit inputs; };
        };
    in
    {
      nixosConfigurations = {
        # Defining a new host is a one-liner. Copy hosts/example as a
        # starting point and add an entry here.
        example = mkNixOS {
          pkgs = inputs.nixpkgs;
          system = "x86_64-linux";
          hostname = "example";
          username = "myuser";
        };
      };
    };
}
