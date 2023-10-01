{ pkgs, ... }:
let PKGS = pkgs.callPackage (import ../pkgs.nix) {}; in
{
  users.users."rick" = {
    isNormalUser = true;
    initialPassword = "rick";
    description = "rick";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
    ];
    packages = PKGS.USER ++ PKGS.GNOME_EXT;
  };

  home-manager.users."rick" = { ... }: {
    home = {
      username = "rick";
      homeDirectory = "/home/rick";
      stateVersion = "23.05";
    };

    programs.git = {
      enable = true;
      userName = "Armin";
      userEmail = "Armin.Mahdilou@gmail.com";
    };

    imports = [ ./base.nix ];
  };
}

# vim:expandtab ts=2 sw=2

