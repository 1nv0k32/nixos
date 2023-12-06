{ lib, pkgs, ... }: {
  imports = [
    <nixos-wsl/modules>
  ];

  wsl = {
    enable = true;
    defaultUser = "rick";
    wslConf = {
      generateResolvConf = false;
    };
  };

  environment.systemPackages = with pkgs; [
    wsl-vpnkit
  ];

  boot.loader.systemd-boot.enable = lib.mkForce false;
  networking.networkmanager.enable = lib.mkForce false;
  networking.firewall.enable = lib.mkForce false;
  services.resolved.enable = lib.mkForce false;
}

# vim:expandtab ts=2 sw=2

