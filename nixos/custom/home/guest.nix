{ pkgs, ... }:
let PKGS = pkgs.callPackage (import ../pkgs.nix) {}; in
{
  users.users."guest" = {
    isNormalUser = true;
    initialPassword = "guest";
    description = "guest";
    packages = PKGS.USER ++ PKGS.GNOME_EXT;
  };

  home-manager.users."guest" = { ... }: {
    home = {
      username = "guest";
      homeDirectory = "/home/guest";
      stateVersion = "23.05";
    };

    imports = [ ./base.nix ];
  };
}

# vim:expandtab ts=2 sw=2

