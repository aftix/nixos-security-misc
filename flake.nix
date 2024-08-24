{
  description = "Flake for applying hardened security settings to NixOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";

    security-misc = {
      url = "github:Kicksecure/security-misc";
      flake = false;
    };
  };

  outputs = {
    flake-utils,
    nixpkgs,
    security-misc,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      formatter =
        if pkgs ? alejandra
        then pkgs.alejandra
        else pkgs.nix-fmt;
    })
    // {
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
