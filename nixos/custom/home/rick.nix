{ ... }:
{
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

