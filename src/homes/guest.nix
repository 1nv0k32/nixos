{ customPkgs, ... }: { ... }: {
  home-manager.users."guest" = { ... }: {
    home = {
      username = "guest";
    };

    imports = [ (import ./base.nix { customPkgs = customPkgs; }) ];
  };
}

# vim:expandtab ts=2 sw=2

