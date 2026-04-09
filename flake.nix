{
  description = "NixOS Configuration with Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, helix, hyprland, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        # New machines
        abthin = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/abthin.nix
            ./modules/shared.nix
            ./modules/desktop.nix
            ./modules/hyprland.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.ab = import ./home/home.nix;
            }
          ];
        };

        abmain = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/abmain.nix
            ./modules/shared.nix
            ./modules/shared-workstation.nix
            ./modules/desktop.nix
            ./modules/desktop-workstation.nix
            ./modules/hyprland.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.ab = {
                imports = [
                  ./home/home.nix
                  ./home/home-workstation.nix
                ];
              };
            }
          ];
        };

        # Legacy machines
        abasus = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/abasus.nix
            ./modules/shared.nix
            ./modules/shared-workstation.nix
            ./modules/desktop.nix
            ./modules/desktop-workstation.nix
            ./modules/hyprland.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.ab = {
                imports = [
                  ./home/home.nix
                  ./home/home-workstation.nix
                ];
              };
            }
          ];
        };

        abdell = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/abdell.nix
            ./modules/shared.nix
            ./modules/shared-workstation.nix
            ./modules/desktop.nix
            ./modules/desktop-workstation.nix
            ./modules/hyprland.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.ab = {
                imports = [
                  ./home/home.nix
                  ./home/home-workstation.nix
                ];
              };
            }
          ];
        };
      };

      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          git
          nixos-rebuild
          home-manager
        ];
        
        shellHook = ''
          echo "🚀 NixOS Configuration Development Shell"
          echo "Available commands:"
          echo "  nixos-rebuild switch --flake .#hostname"
          echo "  home-manager switch --flake .#ab@hostname"
        '';
      };
    };
}