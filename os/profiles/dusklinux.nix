{ config, pkgs, ... }:
{
  axiom.desktop.environment = "hyprland";

  environment.systemPackages = with pkgs; [
    kitty
    wofi
    waybar
    mako
    awww
    hyprpicker
    grim
    slurp
  ];
}