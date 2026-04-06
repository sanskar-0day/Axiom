{ config, pkgs, ... }:
{
  axiom.desktop.environment = "hyprland";
  axiom.windowsCompat.wine.enable = true;

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  # GPU drivers (auto-detect in real config)
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Gamemode
  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    steam
    lutris
    heroic
    mangohud
    gamescope
    protonup-qt
  ];
}