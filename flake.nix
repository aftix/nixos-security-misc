{
  description = "Flake for applying hardened security settings to NixOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    security-misc = {
      url = "github:Kicksecure/security-misc";
      flake = false;
    };
  };

  outputs = {
    self,
    flake-utils,
    nixpkgs,
    security-misc,
    ...
  } @ inputs: let
    linuxSystems = builtins.filter (nixpkgs.lib.strings.hasSuffix "-linux") flake-utils.lib.allSystems;
  in
    # Per-system output attributes
    flake-utils.lib.eachSystem linuxSystems (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [inputs.devshell.overlays.default];
      };
    in {
      formatter =
        pkgs.alejandra or pkgs.nix-fmt;

      devShells.default = pkgs.devshell.mkShell {
        imports = [(pkgs.devshell.importTOML ./devshell.toml)];
      };
    })
    //
    # Output attributes without a system
    {
      nixosModules = rec {
        nixos-security-misc = {lib, ...}: {
          _module.args = {inherit security-misc;};
          imports = [
            ./nixos
          ];
        };
        default = nixos-security-misc;
      };
      overlays.default = _: _: {};
    };
}
