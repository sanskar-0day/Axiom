{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.axiom.desktop;
in
{
  options.axiom.desktop = {
    environment = mkOption {
      type = types.enum [ "hyprland" "plasma" "minimal" ];
      default = "hyprland";
      description = "Desktop environment to use";
    };
  };

  config = {
    # Wayland / display server base
    services.greetd = {
      enable = true;
      settings.default_session = {
        command = if cfg.environment == "hyprland" then
          "${pkgs.hyprland}/bin/Hyprland"
        else if cfg.environment == "plasma" then
          "${pkgs.plasma5Packages.plasma-workspace}/bin/startplasma-wayland"
        else
          "${pkgs.sway}/bin/sway";
      };
    };

    programs.hyprland.enable = cfg.environment == "hyprland";

    services.desktopManager.plasma6.enable = cfg.environment == "plasma";

    # Common packages for all desktop environments
    environment.systemPackages = with pkgs; [
      kitty
      wofi
      waybar
      mako
      grim
      slurp
      wl-clipboard
    ];

    # Fonts
    fonts.packages = with pkgs; [
      inter
      jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      lohit-fonts.devanagari
      lohit-fonts.tamil
      lohit-fonts.bengali
      lohit-fonts.telugu
    ];
  };
}