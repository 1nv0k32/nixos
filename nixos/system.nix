{ lib, ... }:
{
  boot = {
    kernelParams = [ "amd_pstate=passive" ];
    initrd.systemd.contents."/etc/crypttab" = {
      enable = true;
      text = lib.mkForce ''
        root UUID=98d2d55d-2272-4116-9267-2ca7746c616a none tpm2-device=auto
      '';
    };
  };

  services = {
    fprintd.enable = true;

    ###################
    ### DLNA Server ###
    ###################
    minidlna = {
      enable = false;
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
    ###################
    ### DLNA Server ###
    ###################
  };
}

# vim:expandtab ts=2 sw=2

