architecture := `uname -m`

default:
    @just --list

test-all arch=architecture:
    @just test {{arch}}
    @just lint
    @just check-fmt

alias ta := test-all

test arch=architecture:
    @just check --all-systems
    @just microvm-build {{arch}}

alias t := test

check *FLAGS="":
    @nix flake check {{FLAGS}}

alias c := check

check-fmt:
    @alejandra -c .

alias cf := check-fmt

microvm-build arch=architecture *FLAGS="":
    @nix build '.#packages.{{arch}}-linux.microvm' --out-link .nixkeep-microvm-{{arch}} {{FLAGS}}

alias vmb := microvm-build

microvm arch=architecture *FLAGS="":
    @just microvm-build {{arch}} {{FLAGS}}
    @nix run '.#packages.{{arch}}-linux.microvm' {{FLAGS}}

alias vm := microvm

clean:
    @rm -rf .nixkeep-* result var.img control.socket

alias cl := clean

lint:
    @statix check

alias l := lint
