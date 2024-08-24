{
  config,
  lib,
  security-misc,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.nixos-security-misc;
  inherit (config.lib.nixos-security-misc) mkEnableTarget;
in {
  options.nixos-security-misc.thunderbird.enable = mkEnableTarget "thunderbird" (
    # Currently, programs.thunderbird only exists in unstable, but this flake support stable
    if config.programs ? thunderbird
    then config.programs.thunderbird.enable
    else false
  );

  config = let
    name = "thunderbird/pref/40_security-misc.js";
  in
    mkIf cfg.thunderbird.enable {
      environment.etc."${name}".source = "${security-misc}/etc/${name}";
    };
}
