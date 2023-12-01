{ configRepo, customPkgs, homeManager, pkgs, ... }: {
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
      autoLogin.enable = false;
      autoLogin.user = "guest";
    };
  };

  imports = [
    (import "${homeManager}/nixos")
    "${configRepo}/src/homes/rick.nix"
    "${configRepo}/src/homes/guest.nix"
  ];
}

# vim:expandtab ts=2 sw=2

