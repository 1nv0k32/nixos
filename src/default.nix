{ config, pkgs, lib, ... }:
let customConfs = pkgs.callPackage (import ./confs.nix) {}; in
let customPkgs = pkgs.callPackage (import ./pkgs.nix) {}; in
with lib;
{
  imports = [ (import ./users.nix { customPkgs = customPkgs; }) ];

  nix = {
    settings.experimental-features = mkDefault [ "nix-command" "flakes" ];
    extraOptions = customConfs.NIX_CONFIG;
  };

  system = {
    stateVersion = mkDefault "24.05";
    autoUpgrade = {
      enable = mkDefault true;
      allowReboot = mkDefault false;
      operation = mkDefault "boot";
      flags = mkDefault [ "--upgrade-all" ];
    };
  };

  boot = {
    kernelPackages = mkDefault pkgs.linuxPackages_latest;
    blacklistedKernelModules = mkDefault [ "snd_pcsp" ];
    extraModprobeConfig = mkDefault "options kvm_amd nested=1";
    loader = {
      efi.canTouchEfiVariables = mkDefault true;
      timeout = mkDefault 0;
      systemd-boot = {
        enable = mkDefault true;
        editor = mkForce false;
        consoleMode = mkDefault "max";
      };
    };
    initrd.systemd = {
      enable = mkDefault true;
      extraConfig = customConfs.SYSTEMD_CONFIG;
    };
  };
  
  networking = {
    hostName = mkDefault "nyx";
    networkmanager = {
      enable = mkDefault true;
      dns = mkDefault "systemd-resolved";
      extraConfig = customConfs.NETWORK_MANAGER_CONFIG;
    };
    firewall = {
      enable = mkDefault true;
      allowPing = mkDefault false;
      allowedTCPPorts = mkDefault [];
      allowedUDPPorts = mkDefault [];
    };
  };

  systemd = {
    extraConfig = customConfs.SYSTEMD_CONFIG;
    user.extraConfig = customConfs.SYSTEMD_USER_CONFIG;
    tmpfiles.rules = mkDefault [
      "L+ /lib/ld-linux.so.2 - - - - ${pkgs.glibc_multi}/lib/32/ld-linux.so.2"
      "L+ /lib64/ld-linux-x86-64.so.2 - - - - ${pkgs.glibc}/lib64/ld-linux-x86-64.so.2"
    ];
  };

  time = {
    timeZone = mkDefault "CET";
    hardwareClockInLocalTime = mkDefault false;
  };

  i18n.defaultLocale = mkDefault "en_GB.UTF-8";

  console = {
    earlySetup = mkDefault true;
    packages = customPkgs.CONSOLE;
    font = mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-v24b.psf.gz";
    keyMap = mkDefault "us";
  };

  services = {
    avahi.enable = mkForce false;
    gnome.core-utilities.enable = mkForce false ;
    fstrim.enable = mkDefault true;
    fwupd.enable = mkDefault true;
    flatpak.enable = mkDefault true;
    resolved = {
      enable = mkDefault true;
      extraConfig = customConfs.RESOLVED_CONFIG;
    };
    logind = {
      killUserProcesses = mkDefault true;
      suspendKeyLongPress = mkDefault "lock";
      suspendKey = mkDefault "lock";
      rebootKeyLongPress = mkDefault "lock";
      rebootKey = mkDefault "lock";
      powerKeyLongPress = mkDefault "lock";
      powerKey = mkDefault "lock";
      hibernateKeyLongPress = mkDefault "lock";
      hibernateKey = mkDefault "lock";
      lidSwitchExternalPower = mkDefault "lock";
      lidSwitchDocked = mkDefault "lock";
      lidSwitch = mkDefault "suspend";
    };
    xserver = {
      enable = mkDefault true;
      layout = mkDefault "us";
      desktopManager.gnome.enable = mkDefault true;
      displayManager = {
        gdm.enable = mkDefault true;
        defaultSession = mkDefault "gnome";
      };
    };
    pipewire = {
      enable = mkDefault true;
      alsa.enable = mkDefault true;
      alsa.support32Bit = mkDefault true;
      pulse.enable = mkDefault true;
    };
    tor = {
      enable = mkDefault false;
      client.enable = mkDefault false;
    };
    k3s = {
      enable = mkDefault false;
    };
  };

  sound.enable = mkDefault true;
  hardware = {
    opengl.driSupport32Bit = mkDefault true;
    pulseaudio.enable = mkForce false;
    bluetooth.powerOnBoot = mkDefault true;
    wirelessRegulatoryDatabase = mkDefault true;
  };

  security = {
    rtkit.enable = mkDefault true;
    pam = {
      services = {
        gdm.enableGnomeKeyring = mkDefault true;
        gdm.fprintAuth = mkDefault false;
      };
    };
    wrappers.ubridge = {
      source = mkDefault "${pkgs.ubridge}/bin/ubridge";
      capabilities = mkDefault "cap_net_admin,cap_net_raw=ep";
      owner = mkDefault "root";
      group = mkDefault "ubridge";
      permissions = mkDefault "u+rx,g+x";
    };
  };

  virtualisation = {
    podman = {
      enable = mkDefault true;
      dockerCompat = mkDefault true;
      defaultNetwork.settings.dns_enabled = mkDefault true;
    };
    libvirtd = {
      enable = mkDefault true;
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = mkDefault true;
      packageOverrides = pkgs: {
        vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
      };
    };
  };

  environment = {
    systemPackages = customPkgs.SYSTEM;
    variables = {
      EDITOR = mkForce "vim";
      VAGRANT_DEFAULT_PROVIDER = mkForce "libvirt";
    };

    etc = {
      "inputrc".text = customConfs.INPUTRC_CONFIG;
      "bashrc.local".text = customConfs.BASHRC_CONFIG;
      "vimrc".text = customConfs.VIMRC_CONFIG;
    };
  };

  programs = {
    ssh.extraConfig = customConfs.SSH_CLIENT_CONFIG;
    mtr.enable = mkDefault true;
    dconf.enable = mkDefault true;
    steam.enable = mkDefault true;
    wireshark = {
      enable = mkDefault true;
      package = mkDefault pkgs.wireshark;
    };
    tmux = {
      enable = mkDefault true;
      extraConfig = customConfs.TMUX_CONFIG;
    };
    git = {
      enable = mkDefault true;
      config = {
        init.defaultBranch = mkDefault "main";
        color.ui = mkDefault "auto";
        push.autoSetupRemote = mkDefault true;
        push.default = mkDefault "current";
        pull.rebase = mkDefault true;
        fetch.prune = mkDefault true;
        fetch.pruneTags = mkDefault true;
      };
    };
  };

  fonts = {
    packages = customPkgs.FONT;
    enableDefaultPackages = mkDefault true;
    fontconfig.defaultFonts = {
      serif = mkDefault [ "Vazirmatn" "DejaVu Serif" ];
      sansSerif = mkDefault [ "Vazirmatn" "DejaVu Sans" ];
    };
  };
}

# vim:expandtab ts=2 sw=2
