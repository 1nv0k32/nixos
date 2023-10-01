{ ... }:
let home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz"; in
{
  imports = [
    (import "${home-manager}/nixos")
    ./home/rick.nix
    ./home/guest.nix
  ];
}

# vim:expandtab ts=2 sw=2

