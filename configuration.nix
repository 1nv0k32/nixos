{ ... }:
let configRepo = builtins.fetchGit { url = "https://github.com/1nv0k32/NixOS.git"; ref = "main"; }; in
{
  imports = [
    ./hardware-configuration.nix
    (import "${configRepo}/src/main.nix")
    (import "${configRepo}/system/z13.nix")
  ];
}

# vim:expandtab ts=2 sw=2

