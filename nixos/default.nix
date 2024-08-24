{
  config,
  lib,
  ...
}: let
  inherit (lib.options) mkEnableOption;
in {
  options.nixos-security-misc = {
    enable = mkEnableOption "nixos-security-misc";
    autoEnable = mkEnableOption "enable security targets by default";
  };

  config.lib.nixos-security-misc.mkEnableTarget = let
    cfg = config.nixos-security-misc;
  in
    humanName: autoEnable:
      lib.mkEnableOption "security hardening for ${humanName}"
      // {
        default = cfg.enable && cfg.autoEnable && autoEnable;
        example = !autoEnable;
      }
      // lib.optionalAttrs autoEnable {
        defaultText = lib.literalMD "same as [`nixos-security-misc.autoEnable`](#nixossecuritymiscautoenable)";
      };
}
