{ config, pkgs, ... }:
{
  axiom.desktop.environment = "hyprland";

  # Dusklinux-inspired Hyprland configuration
  wayland.windowManager.hyprland.settings = {
    general = {
      gaps_in = 5;
      gaps_out = 10;
      border_size = 2;
      "col.active_border" = "rgba(8b5cf6ee) rgba(34d399ee) 45deg";
      "col.inactive_border" = "rgba(1e1e42aa)";
      layout = "dwindle";
    };

    decoration = {
      rounding = 10;
      blur = {
        enabled = true;
        size = 8;
        passes = 3;
        noise = 0.02;
      };
      drop_shadow = true;
      shadow_range = 15;
      shadow_render_power = 3;
      "col.shadow" = "rgba(000000cc)";
    };

    animations = {
      enabled = true;
      bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
      animation = [
        "windows, 1, 7, myBezier"
        "windowsOut, 1, 7, default, popin 80%"
        "border, 1, 10, default"
        "fade, 1, 7, default"
        "workspaces, 1, 6, default"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    kitty
    wofi
    waybar
    mako
    swww
    hyprpicker
    grimblast
  ];
}