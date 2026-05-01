{
  description = "Axiom OS — declarative operating system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      devShells = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              nim
              nimble
              nodejs_20
              nodePackages.pnpm
              nix-editor
              nixfmt-rfc-style
              gtk3
              webkitgtk
              pkg-config
              git
              jq
              kuzu
            ];

            shellHook = ''
              echo "========================================="
              echo "  Axiom OS Development Environment"
              echo "========================================="
              echo "Nim:     $(nim --version 2>/dev/null | head -1 || echo 'not found')"
              echo "Node:    $(node --version 2>/dev/null || echo 'not found')"
              echo "pnpm:    $(pnpm --version 2>/dev/null || echo 'not found')"
              echo ""
              echo "Commands:"
              echo "  pnpm install      - Install JS dependencies"
              echo "  pnpm -r build     - Build all frontend apps"
              echo "  cd core/engine && nimble build  - Build backend"
              echo "  cd core/bridge && nimble build   - Build bridge"
              echo "========================================="
            '';
          };
        }
      );
    } // {
      homeConfigurations.axiom = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./os/profiles/home.nix
        ];
      };

      nixosModules.default = import ./os/modules/default.nix;

      nixosConfigurations.axiom = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./os/modules/default.nix
          ./os/profiles/dusklinux.nix
          home-manager.nixosModules.home-manager
          {
            axiom.gui.enable = true;
            axiom.enable = true;
            
            users.users.axiom = {
              isNormalUser = true;
              extraGroups = [ "wheel" "networkmanager" ];
              initialPassword = "password";
            };
            
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.axiom = import ./os/profiles/home.nix;
            
            services.getty.autologinUser = "axiom";
            virtualisation.vmVariant = {
              virtualisation.memorySize = 4096;
              virtualisation.cores = 4;
              virtualisation.resolution = { x = 1920; y = 1080; };
            };
          }
        ];
      };
    };
}