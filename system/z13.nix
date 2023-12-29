{ config, options, lib, ... }:
with lib;
{
  boot = {
    kernelParams = options.boot.kernelParams.default ++ [ "amd_pstate=passive" ];
    initrd.luks.devices = let luksDevs = config.boot.initrd.luks.devices; in
      builtins.listToAttrs (
        map (device: lib.nameValuePair device {crypttabExtraOpts = [ "tpm2-device=auto" ];})
      luksDevs);
  };

  services = {
    fprintd.enable = true;
    power-profiles-daemon.enable = mkForce false;

    auto-cpufreq = {
      enable = true;
      settings = {
        "charger" = {
          governor = "ondemand";
          turbo = "auto";
        };
        "battery" = {
          governor = "ondemand";
          scaling_min_freq = 400000;
          scaling_max_freq = 1600000;
          turbo = "never";
        };
      };
    };

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

  systemd.services = {
    minidlna.wantedBy = mkForce [];
  };
}

# vim:expandtab ts=2 sw=2

