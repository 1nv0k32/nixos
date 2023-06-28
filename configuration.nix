### 1nv0k32 ###

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.kernelParams = [ "amd_pstate=passive" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 0;

  networking.hostName = "nyx";
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "systemd-resolved";
  networking.networkmanager.extraConfig  = ''
    [main]
    dns=none
    no-auto-default=*
    systemd-resolved=false
  '';

  services.resolved.enable = true;
  services.resolved.extraConfig = ''
    [Resolve]
    DNS=8.8.8.8
    #Domains=
    DNSSEC=no
    #DNSOverTLS=no
    MulticastDNS=no
    LLMNR=no
    Cache=no
    CacheFromLocalhost=no
    DNSStubListener=no
    #DNSStubListenerExtra=
    #ReadEtcHosts=yes
    #ResolveUnicastSingleLabel=no
  '';

  systemd.extraConfig = ''
    [Manager]
    LogLevel=err
    RuntimeWatchdogSec=off
    RebootWatchdogSec=off
    KExecWatchdogSec=off
    DefaultTimeoutStartSec=10s
    DefaultTimeoutStopSec=10s
  '';

  systemd.user.extraConfig = ''
    [Manager]
    DefaultTimeoutStartSec=10s
    DefaultTimeoutStopSec=10s
  '';

  services.logind.extraConfig = ''
    [Login]
    KillUserProcesses=no
    HandlePowerKey=ignore
    HandleSuspendKey=ignore
    HandleHibernateKey=ignore
    HandleLidSwitch=ignore
    HandleLidSwitchExternalPower=ignore
    HandleLidSwitchDocked=ignore
    HandleRebootKey=ignore
    HandleRebootKeyLongPress=ignore
  '';

  time.timeZone = "Europe/Amsterdam";

  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
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

  console.earlySetup = true;
  console.packages = with pkgs; [ terminus_font ];
  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-v24b.psf.gz";
  console.keyMap = "us";

  services.power-profiles-daemon.enable = false;
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    "charger" = {
      governor = "performance";
      turbo = "always";
    };
    "battery" = {
      governor = "ondemand";
      scaling_min_freq = 400000;
      scaling_max_freq = 1400000;
      turbo = "never";
    };
  };

  #services.fprintd.enable = true;
  services.fwupd.enable = true;

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.layout = "us";

  services.printing.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  users.users.rick = {
    isNormalUser = true;
    description = "rick";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd" 
    ];
    packages = (with pkgs; [
      firefox
      google-chrome
      spotify
      steam
      discord
      flameshot
      otpclient
      winbox
      gns3-gui
      gns3-server
    ]) 
    ++ (with pkgs; [
      gnome.gnome-terminal
      gnome.gedit
      gnome.gnome-tweaks
    ]) 
    ++ (with pkgs.gnomeExtensions; [
      just-perfection
      appindicator
      unblank
    ]);
  };

  environment.systemPackages = (with pkgs; [
    vim_configurable
    efibootmgr
    git
    tmux
    tree
    htop
    bat
    ncdu
    aria
    wget

    wireguard-tools
    openvpn

    kubectl
    kubernetes-helm
    k9s
    awscli
    vscode
    jetbrains.pycharm-community
    virt-manager
    win-virtio
    vagrant
  ]) 
  ++ (with pkgs; [
    nvme-cli
    pwgen
    qrencode

    vlc
    wireshark
    nmap
    burpsuite
    radare2
    pwntools
    pwndbg
    aircrack-ng
    binwalk
  ]);

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    gnome-console
    gnome-text-editor
  ]) ++ (with pkgs.gnome; [
    geary
    epiphany
    cheese
    totem
    gnome-music
    gnome-characters
  ]);

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };
  virtualisation.libvirtd.enable = true;

  environment.etc."inputrc".text = pkgs.lib.mkForce(
    builtins.readFile <nixpkgs/nixos/modules/programs/bash/inputrc>
    + 
    ''
      ### CUST ###
      set completion-ignore-case on
      set colored-completion-prefix on
      set skip-completed-text on
      set visible-stats on
      set colored-stats on
      set mark-symlinked-directories on
      ### CUST ###
    ''
  );

  environment.etc."bashrc.local".text = pkgs.lib.mkForce(
    ''
      ### CUST ###
      WH="\[\e[0;00m\]"
      RE="\[\e[0;31m\]"
      GR="\[\e[0;32m\]"
      PR="\[\e[0;35m\]"
      CY="\[\e[0;36m\]"

      PS_STAT="[ \$? = "0" ] && printf '$GR*$WH' || printf '$RE*$WH'"
      if [ "`id -u`" -eq 0 ]; then
          DoC=$RE
          PS_SH="$RE# $WH"
      else
          DoC=$GR
          PS_SH="$GR$ $WH"
      fi
      PS1="$DoC[$WH\t$DoC]-[$WH\u@\H$DoC]\`$PS_STAT\`$DoC[$PR\w$DoC]$WH \n$PS_SH"

      alias rm='rm -I'
      alias ls='ls --color=auto'
      alias ll='ls -alhFb --group-directories-first'
      alias grep='grep --color=auto'
      alias diff='diff --color=auto'
      ### CUST ###
    ''
  );

  environment.etc."vimrc".text = pkgs.lib.mkForce
  ''
    syntax enable
    filetype indent on
    set mouse=a
    set encoding=utf-8
    set belloff=all
    set tabstop=4
    set softtabstop=4
    set shiftwidth=4
    set expandtab
    set smarttab
    set number
    set wildmenu
    set foldenable
    set clipboard=unnamedplus
    set nowrap
    set modeline
    set modelines=1
  '';

  environment.etc."gitconfig".text = pkgs.lib.mkForce(
    ''
      [init]
          defaultBranch = main
      [color]
          ui = auto
      [push]
          autoSetupRemote = true
          default = current
      [pull]
          rebase = true
    ''
  );

  programs.ssh.extraConfig = ''
    Host *
      IdentitiesOnly yes
      ServerAliveInterval 60
  '';

  programs.tmux.enable = true;
  programs.tmux.extraConfig = ''
    bind -r C-a send-prefix
    bind r source-file /etc/tmux.conf
    bind -  split-window -v  -c '#{pane_current_path}'
    bind \\ split-window -h  -c '#{pane_current_path}'
    bind -r C-k resize-pane -U
    bind -r C-j resize-pane -D
    bind -r C-h resize-pane -L
    bind -r C-l resize-pane -R
    bind -r k select-pane -U
    bind -r j select-pane -D
    bind -r h select-pane -L
    bind -r l select-pane -R
    bind -T copy-mode MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel

    set -sg escape-time 0
    set -g prefix C-a
    set -g history-limit 50000
    set -g set-titles on
    set -g mouse on
    set -g monitor-activity on
    set -g default-terminal "screen-256color"
    set -g default-command "''${SHELL}"
    set -g status-interval 60
    set -g status-bg black
    set -g status-fg green
    set -g window-status-activity-style fg=red
    set -g status-left-length 100
    set -g status-left  '#{?client_prefix,#[fg=red]PFX,   } #[fg=green](#S) '
    set -g status-right-length 100
    set -g status-right '#[fg=yellow]%Y/%m(%b)/%d %a %H:%M#[default]'
  '';

  environment.variables.EDITOR = "vim";

  programs.mtr.enable = true;


  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  networking.firewall.enable = true;

  system.stateVersion = "23.05";
}

# vim:expandtab ts=2 sw=2

