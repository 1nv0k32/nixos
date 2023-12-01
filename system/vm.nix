{ lib, ... }: {
  networking = {
    hostName = lib.mkForce "vmnix";
    firewall = {
      allowPing = lib.mkForce false;
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

