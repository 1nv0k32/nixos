{ customPkgs, ... }: { ... }:
{
  home-manager.users."rick" = { ... }: {
    home = {
      username = "rick";
      homeDirectory = "/home/rick";
      stateVersion = "24.05";
    };

    programs.git = {
      enable = true;
      userName = "Armin";
      userEmail = "Armin.Mahdilou@gmail.com";
    };

    imports = [ (import ./base.nix { customPkgs = customPkgs; }) ];
  };
}

# vim:expandtab ts=2 sw=2

