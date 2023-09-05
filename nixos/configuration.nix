{ ... }: {
  imports = [
    <home-manager/nixos>
    ./hardware-configuration.nix
    ./custom/main.nix
    ./custom/user.nix
    ./system.nix
  ];
}

# vim:expandtab ts=2 sw=2

