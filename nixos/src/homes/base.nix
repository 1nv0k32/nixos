{ pkgs, lib, ... }:
let PKGS = pkgs.callPackage (import ../pkgs.nix) {}; in
with lib.hm.gvariant;
{
  programs.home-manager.enable = true;

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
      idle-delay = mkUint32 0;
    };
    "org/gnome/desktop/background" = {
      picture-options = "none";
      primary-color = "#000000";
      secondary-color = "#000000";
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
    "org/gnome/mutter" = {
      dynamic-workspaces = true;
      edge-tiling = true;
    };
    "org/gnome/desktop/input-sources" = {
      per-window = true;
      sources = [ (mkTuple [ "xkb" "us" ]) (mkTuple [ "xkb" "ir" ]) ];
    };
    "org/gnome/desktop/wm/preferences" = {
      audible-bell = false;
      auto-raise = true;
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

    # Extensions
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = lib.lists.forEach PKGS.GNOME_EXT (e: e.extensionUuid);
    };

    "org/gnome/shell/extensions/just-perfection" = {
      animation = mkInt32 4;
      panel = true;
      panel-in-overview = true;
      double-super-to-appgrid = false;
      window-demands-attention-focus = true;
      startup-status = mkInt32 0;
      osd-position = mkInt32 2;
    };
  };
}

# vim:expandtab ts=2 sw=2

