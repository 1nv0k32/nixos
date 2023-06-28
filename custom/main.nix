{ config, lib, pkgs, ... }:
let CONFS = pkgs.callPackage (import ./src/confs.nix) {}; in
let PKGS = pkgs.callPackage (import ./src/pkgs.nix) {}; in
{
  system.stateVersion = "23.05";

  boot.kernelParams = [ "amd_pstate=passive" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 0;
  
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;

  networking.hostName = "nyx";
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "systemd-resolved";
  networking.networkmanager.extraConfig = CONFS.NETWORK_MANAGER_CONFIG;
  networking.firewall.enable = true;
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  systemd.extraConfig = CONFS.SYSTEMD_CONFIG;
  systemd.user.extraConfig = CONFS.SYSTEMD_USER_CONFIG;


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
  console.packages = PKGS.CONSOLE;
  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-v24b.psf.gz";
  console.keyMap = "us";

  services.avahi.enable = false;
  services.resolved.enable = true;
  services.resolved.extraConfig = CONFS.RESOLVED_CONFIG;
  services.logind.extraConfig = CONFS.LOGIND_CONFIG;
  services.power-profiles-daemon.enable = false;
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = CONFS.CPU_FREQ_CONFIG;
  #services.fprintd.enable = true;
  services.fwupd.enable = true;
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.layout = "us";
  services.pipewire.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.alsa.support32Bit = true;
  services.pipewire.pulse.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  virtualisation.podman.enable = true;
  virtualisation.podman.dockerCompat = true;
  virtualisation.podman.defaultNetwork.settings.dns_enabled = true;
  virtualisation.libvirtd.enable = true;

  nixpkgs.config.allowUnfree = lib.mkForce(true);

  environment.etc."inputrc".text = CONFS.INPUTRC_CONFIG;
  environment.etc."bashrc.local".text = CONFS.BASHRC_CONFIG;
  environment.etc."vimrc".text = CONFS.VIMRC_CONFIG;
  environment.etc."gitconfig".text = CONFS.GIT_CONFIG;

  environment.variables.EDITOR = "vim";

  environment.systemPackages = PKGS.SYSTEM;
  environment.gnome.excludePackages = PKGS.GNOME_EXCLUDE;

  programs.ssh.extraConfig = CONFS.SSH_CLIENT_CONFIG;
  programs.tmux.enable = true;
  programs.tmux.extraConfig = CONFS.TMUX_CONFIG;
  programs.mtr.enable = true;
  programs.steam.enable = true;

  users.users.rick = {
    isNormalUser = true;
    description = "rick";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
    ];
    packages = PKGS.USER;
  };
}

# vim:expandtab ts=2 sw=2

