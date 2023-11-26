{ pkgs, ... }:
let PKGS = pkgs.callPackage (import ./pkgs.nix) {}; in
{
  users.groups."ubridge" = {
    name = "ubridge";
  };

  users.users."rick" = {
    uid = 1000;
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
      "ubridge"
      "wireshark"
    ];
    packages = PKGS.USER ++ PKGS.GNOME_EXT;
  };

  users.users."guest" = {
    uid = 1001;
    isNormalUser = true;
    packages = PKGS.USER ++ PKGS.GNOME_EXT;
  };

  services.xserver = {
    displayManager = {
      autoLogin.enable = false;
      autoLogin.user = "guest";
    };
  };

  imports = [ ./home.nix ];
}

# vim:expandtab ts=2 sw=2

