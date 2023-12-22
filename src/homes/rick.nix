{ customPkgs, ... }: { ... }:
{
  home-manager.users."rick" = { ... }: {
    home = {
      username = "rick";
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

