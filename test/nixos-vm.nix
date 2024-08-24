{pkgs, ...}: {
  # Enable everything in flake
  nixos-security-misc = {
    enable = true;
    thunderbird.enable = true;
  };

  networking.hostName = "microvm";
  users.users.root.password = "";

  microvm = {
    volumes = [
      {
        mountPoint = "/var";
        image = "var.img";
        size = 256;
      }
    ];
    shares = [
      {
        # use "virtiofs" for MicroVMs that are started by systemd
        proto = "9p";
        tag = "ro-store";
        # a host's /nix/store will be picked up so that no
        # squashfs/erofs will be built for it.
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
      }
    ];

    hypervisor = "qemu";
    socket = "control.socket";
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  networking.firewall.allowedTCPPorts = [22];
  environment.systemPackages = with pkgs; [htop];

  system.stateVersion = "24.05";
}
