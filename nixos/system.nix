{ lib, ... }:
let nixos-hardware = builtins.fetchTarball "https://github.com/NixOS/nixos-hardware/archive/master.tar.gz"; in
{
  imports = [
    (import "${nixos-hardware}/lenovo/thinkpad/z/z13")
  ];

  boot = {
    kernelParams = [  ];
    initrd.systemd.contents."/etc/crypttab" = {
      enable = true;
      text = lib.mkForce ''
        root UUID=98d2d55d-2272-4116-9267-2ca7746c616a none tpm2-device=auto
      '';
    };
  };

  services = {
    fprintd.enable = lib.mkForce(false);
    tlp.enable = lib.mkForce(false);
    minidlna = {
      enable = true;
      openFirewall = true;
      settings = {
        log_level = "error";
        inotify = "yes";
        notify_interval = 60;
        friendly_name = "media_server";
        media_dir = [
          "V,/home/files/vids"
        ];
      };
    };
  };
}

# vim:expandtab ts=2 sw=2

