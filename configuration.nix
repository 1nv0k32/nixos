### 1nv0k32 ###

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nyx"; # Define your hostname.
  networking.networkmanager.enable = true;

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

  #services.fprintd.enable = true;
  services.fwupd.enable = true;

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.layout = "us";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rick = {
    isNormalUser = true;
    description = "rick";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = (with pkgs; [
    efibootmgr
    vim
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
    auto-cpufreq
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

  environment.etc."auto-cpufreq.conf".text = pkgs.lib.mkForce(
    ''
      [charger]
      governor = ondemand
      scaling_min_freq = 400000
      #scaling_max_freq = 4760000
      turbo = auto
      [battery]
      governor = ondemand
      scaling_min_freq = 400000
      scaling_max_freq = 1400000
      turbo = never
    ''
  );
  systemd.packages = [ pkgs.auto-cpufreq ];
  systemd.services.auto-cpufreq.path = with pkgs; [ bash coreutils ];
  systemd.services.power-profiles-daemon.enable = false;

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

  environment.etc."vimrc".text = pkgs.lib.mkForce(
    ''
      ### CUST ###
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
      ### CUST ###
    ''
  );

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

  environment.variables.EDITOR = "vim";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
