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
    ".config" = {
      source = ./axiom-desktop-files/.config;
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
