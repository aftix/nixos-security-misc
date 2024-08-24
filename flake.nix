{
  description = "Flake for applying hardened security settings to NixOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";

    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    microvm = {
      url = "github:astro/microvm.nix";
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
    linuxSystems = with flake-utils.lib.system; [
      x86_64-linux
      i686-linux
      aarch64-linux
      riscv64-linux
    ];
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

      packages.microvm = self.nixosConfigurations.${system}.config.microvm.declaredRunner;
    })
    //
    # Output attributes without a system
    {
      nixosConfigurations =
        nixpkgs.lib.attrsets.mergeAttrsList
        (builtins.map (system: {
            ${system} = nixpkgs.lib.nixosSystem {
              inherit system;
              modules = [
                inputs.microvm.nixosModules.microvm
                self.nixosModules.default
                ./test/nixos-vm.nix
              ];
            };
          })
          linuxSystems);
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
