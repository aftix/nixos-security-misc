architecture := `uname -m`

default:
    @just --list

test arch=architecture:
    @just check {{arch}}
    @just microvm-build {{arch}}

check arch=architecture *FLAGS="":
    @nix flake check {{FLAGS}}

microvm-build arch=architecture *FLAGS="":
    @nix build '.#packages.{{arch}}-linux.microvm' --out-link .nixkeep-microvm-{{arch}} {{FLAGS}}

microvm arch=architecture *FLAGS="":
    @just microvm-build {{arch}} {{FLAGS}}
    @nix run '.#packages.{{arch}}-linux.microvm' {{FLAGS}}

clean:
    @rm -rf .nixkeep-* result var.img control.socket
