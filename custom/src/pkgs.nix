{ pkgs }:
{
  CONSOLE = with pkgs; [ terminus_font ];

  USER = with pkgs; [
    firefox
    google-chrome
    spotify
    discord
    flameshot
    otpclient
    winbox
    gns3-gui
    gns3-server
    pavucontrol
    networkmanagerapplet

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
    git
    tmux
    tree
    file
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
