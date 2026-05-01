{ config, pkgs, lib, ... }:

{
  home.username = lib.mkDefault (let u = builtins.getEnv "USER"; in if u == "" then "axiom" else u);
  home.homeDirectory = lib.mkDefault (let h = builtins.getEnv "HOME"; in if h == "" then "/home/axiom" else h);

  home.stateVersion = "23.11"; # Please read the release notes before changing.

  home.packages = with pkgs; [
    (python3.withPackages (ps: with ps; [ requests pillow psutil setuptools ]))
    hyprland
    waybar
    rofi
    mako
    kitty
    alacritty
    git
    fastfetch
    btop
    yazi
    swappy
    waypaper
    wlogout
    zellij
    zathura
    mpv-unwrapped
    cava
    pavucontrol
    networkmanagerapplet
    grim
    slurp
    awww
    hyprpicker
    kanata
    uwsm
    satty
  ];

  home.file = {
    ".config/hypr" = {
      source = ./axiom-desktop-files/.config/hypr;
      recursive = true;
    };
    ".config/waybar" = {
      source = ./axiom-desktop-files/.config/waybar;
      recursive = true;
    };
    ".config/rofi" = {
      source = ./axiom-desktop-files/.config/rofi;
      recursive = true;
    };
    ".config/mako" = {
      source = ./axiom-desktop-files/.config/mako;
      recursive = true;
    };
    ".config/kitty" = {
      source = ./axiom-desktop-files/.config/kitty;
      recursive = true;
    };
    ".config/alacritty" = {
      source = ./axiom-desktop-files/.config/alacritty;
      recursive = true;
    };
    ".config/fastfetch" = {
      source = ./axiom-desktop-files/.config/fastfetch;
      recursive = true;
    };
    ".config/btop" = {
      source = ./axiom-desktop-files/.config/btop;
      recursive = true;
    };
    ".config/yazi" = {
      source = ./axiom-desktop-files/.config/yazi;
      recursive = true;
    };
    ".config/swappy" = {
      source = ./axiom-desktop-files/.config/swappy;
      recursive = true;
    };
    ".config/waypaper" = {
      source = ./axiom-desktop-files/.config/waypaper;
      recursive = true;
    };
    ".config/wlogout" = {
      source = ./axiom-desktop-files/.config/wlogout;
      recursive = true;
    };
    ".config/zellij" = {
      source = ./axiom-desktop-files/.config/zellij;
      recursive = true;
    };
    ".config/zathura" = {
      source = ./axiom-desktop-files/.config/zathura;
      recursive = true;
    };
    ".config/mpv" = {
      source = ./axiom-desktop-files/.config/mpv;
      recursive = true;
    };
    ".config/cava" = {
      source = ./axiom-desktop-files/.config/cava;
      recursive = true;
    };
    "user_scripts" = {
      source = ./axiom-desktop-files/user_scripts;
      recursive = true;
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
