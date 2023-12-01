{ lib, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./src/main.nix
  ] ++
  lib.optional (builtins.pathExists ./system.nix) ./system.nix;
}

# vim:expandtab ts=2 sw=2

