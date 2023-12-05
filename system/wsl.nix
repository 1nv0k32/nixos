{ lib, modulesPath, ... }: {
  imports = [
    <nixos-wsl/modules>
  ];

  wsl = {
    enable = true;
    defaultUser = "rick";
  };
}

# vim:expandtab ts=2 sw=2

