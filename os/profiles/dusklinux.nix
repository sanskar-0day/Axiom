{ config, pkgs, ... }:
{
  axiom.desktop.environment = "hyprland";

  environment.systemPackages = with pkgs; [
    kitty
    wofi
    waybar
    mako
    swww
    hyprpicker
    grim
    slurp
  ];
}