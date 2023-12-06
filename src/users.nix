{ customPkgs, ... }: { pkgs, lib, ... }:
let homeManager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz"; in
with lib;
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
    packages = customPkgs.USER ++ customPkgs.GNOME_EXT;
  };

  users.users."guest" = {
    uid = 1001;
    isNormalUser = true;
    packages = customPkgs.USER ++ customPkgs.GNOME_EXT;
  };

  services.xserver = {
    displayManager = {
      autoLogin.enable = mkDefault false;
      autoLogin.user = mkDefault "guest";
    };
  };

  imports = [
    (import "${homeManager}/nixos")
    (import ./homes/rick.nix { customPkgs = customPkgs; })
    (import ./homes/guest.nix { customPkgs = customPkgs; })
  ];
}

# vim:expandtab ts=2 sw=2
