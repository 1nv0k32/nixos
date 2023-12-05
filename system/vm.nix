{ lib, pkgs, ... }: {
  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 8192;
      cores = 6;
    };
  };
  users.users."rick".initialPassword = "rick";

  networking = {
    hostName = lib.mkForce "vmnix";
    firewall = {
      allowPing = lib.mkForce true;
      allowedTCPPorts = lib.mkForce [ 22 ];
      allowedUDPPorts = lib.mkForce [  ];
      extraPackages = lib.mkForce [ pkgs.conntrack-tools ];
    };
  };
  services = {
    k3s.enable = lib.mkForce true;
    qemuGuest.enable = true;
    openssh.enable = true;
  };
}

# vim:expandtab ts=2 sw=2

