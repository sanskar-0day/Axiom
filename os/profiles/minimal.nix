{ config, pkgs, ... }:
{
  axiom.desktop.environment = "minimal";

  environment.systemPackages = with pkgs; [
    foot
    dmenu
    i3status
  ];
}