{ config, pkgs, lib, ... }:
let customConfs = pkgs.callPackage (import ./confs.nix) {}; in
let customPkgs = pkgs.callPackage (import ./pkgs.nix) {}; in
{
  imports = [ (import ./users.nix { customPkgs = customPkgs; }) ];

  nix = {
    extraOptions = customConfs.NIX_CONFIG;
  };

  system = {
    stateVersion = "24.05";
    autoUpgrade = {
      enable = true;
      operation = "boot";
      flags = [ "--upgrade-all" ];
      allowReboot = false;
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    blacklistedKernelModules = [ "snd_pcsp" ];
    extraModprobeConfig = "options kvm_amd nested=1";
    loader = {
      efi.canTouchEfiVariables = lib.mkDefault true;
      timeout = 0;
      systemd-boot = {
        enable = true;
        editor = lib.mkForce false;
        consoleMode = "max";
      };
    };
    initrd.systemd = {
      enable = true;
      extraConfig = customConfs.SYSTEMD_CONFIG;
    };
  };
  
  networking = {
    hostName = "nyx";
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      extraConfig = customConfs.NETWORK_MANAGER_CONFIG;
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
    extraConfig = customConfs.SYSTEMD_CONFIG;
    user.extraConfig = customConfs.SYSTEMD_USER_CONFIG;
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
    packages = customPkgs.CONSOLE;
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
      extraConfig = customConfs.RESOLVED_CONFIG;
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
    xserver = {
      enable = true;
      layout = "us";
      desktopManager.gnome.enable = true;
      displayManager = {
        gdm.enable = true;
        defaultSession = "gnome";
      };
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
      enable = false;
    };
  };

  sound.enable = true;
  hardware = {
    opengl.driSupport32Bit = true;
    pulseaudio.enable = false;
    bluetooth.powerOnBoot = lib.mkForce(true);
    wirelessRegulatoryDatabase = true;
  };

  security = {
    rtkit.enable = true;
    pam = {
      services = {
        gdm.enableGnomeKeyring = true;
        gdm.fprintAuth = false;
      };
    };
    wrappers.ubridge = {
      source = "${pkgs.ubridge}/bin/ubridge";
      capabilities = "cap_net_admin,cap_net_raw=ep";
      owner = "root";
      group = "ubridge";
      permissions = "u+rx,g+x";
    };
  };

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    libvirtd = {
      enable = true;
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
    systemPackages = customPkgs.SYSTEM;
    variables = {
      EDITOR = "vim";
      VAGRANT_DEFAULT_PROVIDER = "libvirt";
    };

    etc = {
      "inputrc".text = customConfs.INPUTRC_CONFIG;
      "bashrc.local".text = customConfs.BASHRC_CONFIG;
      "vimrc".text = customConfs.VIMRC_CONFIG;
    };
  };

  programs = {
    ssh.extraConfig = customConfs.SSH_CLIENT_CONFIG;
    mtr.enable = true;
    dconf.enable = true;
    steam.enable = true;
    wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
    tmux = {
      enable = true;
      extraConfig = customConfs.TMUX_CONFIG;
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
    packages = customPkgs.FONT;
    enableDefaultPackages = true;
    fontconfig.defaultFonts = {
      serif = [ "Vazirmatn" "DejaVu Serif" ];
      sansSerif = [ "Vazirmatn" "DejaVu Sans" ];
    };
  };
}

# vim:expandtab ts=2 sw=2

