{ ... }:
{
  home-manager.users."guest" = { ... }: {
    home = {
      username = "guest";
      homeDirectory = "/home/guest";
      stateVersion = "23.11";
    };

    imports = [ ./base.nix ];
  };
}

# vim:expandtab ts=2 sw=2

