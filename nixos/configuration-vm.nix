{ ... }: {
  imports = [
    ./custom/main.nix
  ];

  virtualisation = {
    vmVariant = {
      virtualisation = {
        memorySize =  8192;
        cores = 8;
      };
    };
  };

  users.users."rick" = {
    initialPassword = "rick";
  };
}

# vim:expandtab ts=2 sw=2

