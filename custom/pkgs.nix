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
    firefox
    chromium
    spotify
    flameshot
    otpclient
    winbox
    gns3-gui
    gns3-server
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
    wpm

    gnome.gnome-terminal
    gnome.gedit
    gnome.gnome-tweaks
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
    openvpn
    iw

    kubectl
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

  GNOME_EXCLUDE = with pkgs; [
    gnome-photos
    gnome-tour
    gnome-console
    gnome-text-editor
    gnome.geary
    gnome.epiphany
    gnome.cheese
    gnome.totem
    gnome.gnome-music
    gnome.gnome-characters
  ];
}

# vim:expandtab ts=2 sw=2

