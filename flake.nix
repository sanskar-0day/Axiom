{
  description = "Axiom OS — declarative operating system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, home-manager }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
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
    ) // {
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
          {
            axiom.gui.enable = true;
          }
        ];
      };
    };
}