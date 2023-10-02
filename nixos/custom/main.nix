{ pkgs, lib, ... }:
let CONFS = pkgs.callPackage (import ./confs.nix) {}; in
let PKGS = pkgs.callPackage (import ./pkgs.nix) {}; in
{
  imports = [ ./users.nix ];

  system = {
    stateVersion = "23.11";
    autoUpgrade = {
      enable = false;
      allowReboot = false;
    };
  };

  boot = {
    extraModprobeConfig = "options kvm_amd nested=1";
    kernelParams = [ "amd_pstate=passive" ];
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
        timeout = 0;
      };
    initrd.systemd = {
      enable = true;
      extraConfig = CONFS.SYSTEMD_CONFIG;
    };
  };
  
  networking = {
    hostName = "nyx";
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      extraConfig = CONFS.NETWORK_MANAGER_CONFIG;
    };
    firewall = {
      enable = true;
      allowPing = false;
      allowedTCPPorts = [  ];
      allowedUDPPorts = [  ];
      extraPackages = [ pkgs.conntrack-tools ];
    };
  };

  systemd = {
    extraConfig = CONFS.SYSTEMD_CONFIG;
    user.extraConfig = CONFS.SYSTEMD_USER_CONFIG;
    tmpfiles.rules = [
      "L+ /lib/ld-linux.so.2 - - - - ${pkgs.glibc_multi}/lib/32/ld-linux.so.2"
      "L+ /lib64/ld-linux-x86-64.so.2 - - - - ${pkgs.glibc}/lib64/ld-linux-x86-64.so.2"
    ];
  };

  time = {
    timeZone = "Europe/Amsterdam";
    hardwareClockInLocalTime = false;
  };

  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_GB.UTF-8";
      LC_IDENTIFICATION = "en_GB.UTF-8";
      LC_MEASUREMENT = "en_GB.UTF-8";
      LC_MONETARY = "en_GB.UTF-8";
      LC_NAME = "en_GB.UTF-8";
      LC_NUMERIC = "en_GB.UTF-8";
      LC_PAPER = "en_GB.UTF-8";
      LC_TELEPHONE = "en_GB.UTF-8";
      LC_TIME = "en_GB.UTF-8";
    };
  };

  console = {
    earlySetup = true;
    packages = PKGS.CONSOLE;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-v24b.psf.gz";
    keyMap = "us";
  };

  services = {
    avahi.enable = lib.mkForce(false);
    gnome.core-utilities.enable = lib.mkForce(false);
    power-profiles-daemon.enable = lib.mkForce(false);
    fstrim.enable = lib.mkDefault(true);
    fwupd.enable = true;
    flatpak.enable = true;
    resolved = {
      enable = true;
      extraConfig = CONFS.RESOLVED_CONFIG;
    };
    logind = {
      killUserProcesses = true;
      suspendKeyLongPress = "lock";
      suspendKey = "lock";
      rebootKeyLongPress = "lock";
      rebootKey = "lock";
      powerKeyLongPress = "lock";
      powerKey = "lock";
      hibernateKeyLongPress = "lock";
      hibernateKey = "lock";
      lidSwitchExternalPower = "lock";
      lidSwitchDocked = "lock";
      lidSwitch = "lock";
    };
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
          scaling_max_freq = 1400000;
          turbo = "never";
        };
      };
    };
    xserver = {
      enable = true;
      layout = "us";
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    tor = {
      enable = false;
      client.enable = false;
    };
    k3s = {
      enable = true;
    };
  };

  hardware = {
    pulseaudio.enable = false;
    bluetooth.powerOnBoot = lib.mkForce(false);
    wirelessRegulatoryDatabase = true;
  };

  security = {
    rtkit.enable = true;
    pam = {
      services = {
        gdm.enableGnomeKeyring = true;
      };
    };
  };

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    libvirtd = {
      enable = true;
    };
    vmVariant = {
      virtualisation = {
        memorySize =  8192;
        cores = 8;
      };
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = lib.mkForce(true);
      packageOverrides = pkgs: {
        vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
      };
    };
  };

  environment = {
    systemPackages = PKGS.SYSTEM;
    variables = {
      EDITOR = "vim";
      VAGRANT_DEFAULT_PROVIDER = "libvirt";
    };

    etc = {
      "inputrc".text = CONFS.INPUTRC_CONFIG;
      "bashrc.local".text = CONFS.BASHRC_CONFIG;
      "vimrc".text = CONFS.VIMRC_CONFIG;
    };
  };

  programs = {
    ssh.extraConfig = CONFS.SSH_CLIENT_CONFIG;
    mtr.enable = true;
    dconf.enable = true;
    tmux = {
      enable = true;
      extraConfig = CONFS.TMUX_CONFIG;
    };
    git = {
      enable = true;
      config = {
        init.defaultBranch = "main";
        color.ui = "auto";
        push.autoSetupRemote = true;
        push.default = "current";
        pull.rebase = true;
        fetch.prune = true;
        fetch.pruneTags = true;
      };
    };
  };

  fonts = {
    packages = PKGS.FONT;
    enableDefaultPackages = true;
    fontconfig.defaultFonts = {
      serif = [ "Vazirmatn" "DejaVu Serif" ];
      sansSerif = [ "Vazirmatn" "DejaVu Sans" ];
    };
  };
}

# vim:expandtab ts=2 sw=2

