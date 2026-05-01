{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.axiom;
in
{
  options.axiom = {
    enable = mkEnableOption "Axiom OS core suite";
  };

  config = mkIf cfg.enable {
    system.autoUpgrade = {
      enable = true;
      flake = "github:sanskar-0day/Axiom";
      flags = [ "--update-input" "nixpkgs" "--commit-lock-file" ];
      dates = "hourly";
    };

    axiom.desktop.environment = "hyprland";
    axiom.gui.enable = true;

    services.kanata = {
      enable = true;
      keyboards.default = {
        config = ''
          (defsrc
            caps
          )
          (defalias
            escctrl (tap-hold 100 100 esc lctl)
          )
          (deflayer base
            @escctrl
          )
        '';
      };
    };

    nix.settings = {
      max-jobs = 4;
      cores = 4;
      stalled-download-timeout = 10;
      connect-timeout = 5;
    };

    environment.systemPackages = with pkgs; [
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
      uwsm
      satty
    ];

    system.userActivationScripts.axiomSetup.text = ''
      echo "Setting up Axiom OS configurations..."
      if [ ! -d "$HOME/.config/hypr" ]; then
        mkdir -p "$HOME/.config"
        cp -rT ${../profiles/axiom-desktop-files/.config} "$HOME/.config/"
        chmod -R u+rw "$HOME/.config"
      fi

      if [ ! -d "$HOME/user_scripts" ]; then
        cp -rT ${../profiles/axiom-desktop-files/user_scripts} "$HOME/user_scripts"
        chmod -R u+rwx "$HOME/user_scripts"
      fi
    '';
  };
}
