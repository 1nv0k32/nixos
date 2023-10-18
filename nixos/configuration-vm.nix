{ ... }: {
  imports = [
    ./src/main.nix
  ];

  users.users."rick" = {
    initialPassword = "rick";
  };
}

# vim:expandtab ts=2 sw=2

