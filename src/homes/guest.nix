{ customPkgs, ... }: { ... }: {
  home-manager.users."guest" = { ... }: {
    home = {
      username = "guest";
      homeDirectory = "/home/guest";
      stateVersion = "24.05";
    };

    imports = [ (import ./base.nix { customPkgs = customPkgs; }) ];
  };
}

# vim:expandtab ts=2 sw=2

