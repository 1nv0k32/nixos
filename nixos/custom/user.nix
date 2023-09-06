{ pkgs, ... }:
let home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz"; in
let PKGS = pkgs.callPackage (import ./pkgs.nix) {}; in
{
  users.users."rick" = {
    isNormalUser = true;
    initialPassword = "rick";
    description = "rick";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
    ];
    packages = PKGS.USER;
  };

  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users."rick" = { lib, ... }: {
    home = {
      username = "rick";
      homeDirectory = "/home/rick";
      stateVersion = "23.05";
      packages = PKGS.GNOME_EXT;
    };

    programs.home-manager.enable = true;

    programs.git = {
      enable = true;
      userName = "Armin";
      userEmail = "Armin.Mahdilou@gmail.com";
    };

    programs.ssh = {
      enable = true;
      includes = ["~/.ssh/config.d/*.config"];
    };

    programs.gnome-terminal = {
      enable = true;
      themeVariant = "dark";
      showMenubar = false;
      profile."352f48f0-7279-422e-9e0a-95228e86bd1d" = {
        visibleName = "default";
        default = true;
        allowBold = true;
        audibleBell = false;
        showScrollbar = false;
        cursorShape = "ibeam";
        cursorBlinkMode = "on";
        font = "Monospace 13";

      };
    };

    programs.chromium = {
      enable = true;
      extensions = [
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
        { id = "ponfpcnoihfmfllpaingbgckeeldkhle"; } # enhancer for youtube
        { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
      ];
    };

    dconf.settings = {
      "org/gnome/desktop/sound" = {
        event-sounds = false;
      };
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        clock-show-seconds = true;
        clock-show-weekday = true;
        show-battery-percentage = true;
        enable-hot-corners = false;
      };
      "org/gnome/desktop/session" = {
        idle-delay = lib.hm.gvariant.mkUint32 0;
      };
      "org/gnome/desktop/notifications" = {
        show-in-lock-screen = false;
      };
      "org/gnome/desktop/peripherals/touchpad" = {
        click-method = "areas";
        disable-while-typing = true;
        tap-to-click = true;
        two-finger-scrolling-enabled = true;
      };
      "org/gnome/settings-daemon/plugins/power" = {
        idle-dim = false;
        power-button-action = "nothing";
        sleep-inactive-ac-type = "nothing";
        sleep-inactive-battery-type = "nothing";
      };

      "org/gnome/shell".enabled-extensions = lib.lists.forEach PKGS.GNOME_EXT (e: e.extensionUuid);
      "org/gnome/shell/extensions/just-perfection" = {
        animation = lib.hm.gvariant.mkInt32 3;
        panel = false;
        panel-in-overview = true;
        double-super-to-appgrid = false;
        window-demands-attention-focus = true;
        startup-status = lib.hm.gvariant.mkInt32 0;
      };

      "org/gnome/desktop/wm/keybindings" = {
        close = ["<Super>c"];
        switch-windows = ["<Alt>Tab"];
        switch-applications = ["<Super>Tab"];
        activate-window-menu = [];
      };
      "org/gnome/settings-daemon/plugins/media-keys" = {
        home = ["<Super>e"];
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        ];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        name = "gnome-terminal";
        binding = "<Super>Return";
        command = "gnome-terminal --maximize";
      };
    };

  };
}

# vim:expandtab ts=2 sw=2

