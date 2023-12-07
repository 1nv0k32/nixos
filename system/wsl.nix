{ pkgs, lib, ... }:
with lib;
{
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
      Restart = "always";
      KillMode = "mixed";
    };
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
  };

  services.resolved = {
    enable = mkForce true;
    extraConfig = mkForce ''
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

  boot.loader.systemd-boot.enable = false;
  networking.networkmanager.enable = false;
  networking.firewall.enable = false;
}

# vim:expandtab ts=2 sw=2
