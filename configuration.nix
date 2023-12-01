{ lib, ... }:
let configRepo = builtins.fetchGit { url = "https://github.com/1nv0k32/NixOS.git"; ref = "main"; }; in
{
  imports = [
    ./hardware-configuration.nix
    "${configRepo}/src/main.nix"
  ] ++
  lib.optional (builtins.pathExists ./system.nix) ./system.nix;
}

# vim:expandtab ts=2 sw=2

