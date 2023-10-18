{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ./src/main.nix
    ./system.nix
  ];
}

# vim:expandtab ts=2 sw=2

