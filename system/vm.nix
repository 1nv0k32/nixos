{ lib, ... }: {
  services = {
    k3s.enable = lib.mkForce true;
    qemuGuest.enable = true;
    openssh.enable = true;
  };
}

# vim:expandtab ts=2 sw=2

