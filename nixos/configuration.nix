{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ./custom/main.nix
    ./system.nix
  ];
}

# vim:expandtab ts=2 sw=2

