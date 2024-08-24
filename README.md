# Enhance security settings for NixOS

## Motivation

This flake provides a NixOS module to apply configurations from [Kicksecure's security-misc](https://github.com/Kicksecure/security-misc).
Many of these settings are from the [Kernel Self-Protection Project recommendations](https://kspp.github.io/Recommended_Settings).

## Compatibility

This flake aims to be compatible with NixOS 24.05 and NixOS unstable. The default nixpkgs input is for stable, set it to follow an unstable nixpkgs input
if desired.

## Usage
