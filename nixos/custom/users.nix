{ pkgs, ... }:
let PKGS = pkgs.callPackage (import ./pkgs.nix) {}; in
{
  users.users."rick" = {
    uid = 1000;
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
    ];
    packages = PKGS.USER ++ PKGS.GNOME_EXT;
  };

  users.users."guest" = {
    uid = 1001;
    isNormalUser = true;
    packages = PKGS.USER ++ PKGS.GNOME_EXT;
  };

  imports = [ ./homes.nix ];
}

# vim:expandtab ts=2 sw=2

