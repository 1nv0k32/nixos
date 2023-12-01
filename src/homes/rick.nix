{ homeManager, configRepo, ... }:
{
  home-manager.users."rick" = { ... }: {
    home = {
      username = "rick";
      homeDirectory = "/home/rick";
      stateVersion = "23.11";
    };

    programs.git = {
      enable = true;
      userName = "Armin";
      userEmail = "Armin.Mahdilou@gmail.com";
    };

    imports = [ "${configRepo}nixos/src/base.nix" ];
  };
}

# vim:expandtab ts=2 sw=2

