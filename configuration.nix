{ ... }:
let configRepo = builtins.fetchGit { url = "https://github.com/1nv0k32/NixOS.git"; ref = "main"; }; in
{
  imports = [
    ./hardware-configuration.nix
    (import "${configRepo}/src")
    (import "${configRepo}/system/z13.nix")
    #(import "${configRepo}/system/usb.nix")
    #(import "${configRepo}/system/vm.nix")
  ];
}

# vim:expandtab ts=2 sw=2

