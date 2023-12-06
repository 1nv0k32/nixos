{ lib, pkgs, ... }: {
  imports = [
    <nixos-wsl/modules>
  ];

  wsl = {
    enable = true;
    defaultUser = "rick";
    wslConf = {
      interop.enabled = true;
      network.generateResolvConf = false;
    };
  };

  environment.systemPackages = with pkgs; [
    wsl-vpnkit
  ];

  systemd.services."wsl-vpnkit" = {
    enable = true;
    description = "wsl-vpnkit service";
    serviceConfig = {
      ExecStart = "${pkgs.wsl-vpnkit}/bin/wsl-vpnkit";
      User = "root";
      Group = "root";
    };
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
  };

  services.resolved = {
    enable = lib.mkForce true;
    extraConfig = lib.mkForce ''
    [Resolve]
    DNS=8.8.8.8
    #Domains=
    DNSSEC=no
    #DNSOverTLS=no
    MulticastDNS=no
    LLMNR=no
    Cache=no
    CacheFromLocalhost=no
    DNSStubListener=no
  '';
  };

  boot.loader.systemd-boot.enable = lib.mkForce false;
  networking.networkmanager.enable = lib.mkForce false;
  networking.firewall.enable = lib.mkForce false;
}

# vim:expandtab ts=2 sw=2

