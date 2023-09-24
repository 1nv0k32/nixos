{ pkgs }:
{
  CONSOLE = with pkgs; [
    terminus_font
  ];

  FONT = with pkgs; [
    ubuntu_font_family
    vazir-fonts
  ];

  USER = with pkgs; [
    chromium
    firefox
    spotify
    flameshot
    otpclient
    winbox
    gns3-gui
    gns3-server
    dynamips
    inetutils
    ubridge
    pavucontrol
    networkmanagerapplet
    imagemagick
    ghostscript
    ffmpeg
    vlc
    gimp
    evince
    rivalcfg
    discord
    transmission
    transmission-gtk
    pulseaudio
    unrar-wrapper

    gnome.gnome-terminal
    gnome.gedit
    gnome.dconf-editor
    gnome.gnome-tweaks
    gnome.nautilus
    gnome.file-roller
  ];
  GNOME_EXT = with pkgs; [
    gnomeExtensions.just-perfection
    gnomeExtensions.appindicator
    gnomeExtensions.unblank
  ];

  SYSTEM = with pkgs; [
    vim_configurable
    efibootmgr
    cryptsetup
    git
    tmux
    tree
    file
    htop
    bat
    ncdu
    aria
    wget
    unzip
    gnumake
    tpm2-tss

    wireguard-tools
    conntrack-tools
    nftables
    openvpn
    iw

    kubectl
    k3s
    kubernetes-helm
    k9s
    argocd
    awscli
    vscode
    jetbrains.pycharm-community
    virt-manager
    win-virtio
    vagrant
    terraform
    ansible
    podman-compose
    distrobox

    nvme-cli
    gparted
    stress
    pwgen
    qrencode
    usbutils
    pciutils

    wireshark
    nmap
    burpsuite
    radare2
    pwntools
    pwndbg
    aircrack-ng
    binwalk

    python311
    hatch
    poetry
  ];
}

# vim:expandtab ts=2 sw=2

