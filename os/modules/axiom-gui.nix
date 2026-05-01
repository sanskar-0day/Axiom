{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.axiom.gui;
in
{
  options.axiom.gui = {
    enable = mkEnableOption "Axiom OS GUI";

    autostart = mkOption {
      type = types.bool;
      default = true;
      description = "Start Axiom GUI on login";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # Runtime dependencies
      webkitgtk_4_1
      gtk3
      nix-editor
    ];

    # Autostart the GUI on login
    environment.etc."xdg/autostart/axiom-gui.desktop" = mkIf cfg.autostart {
      text = ''
        [Desktop Entry]
        Type=Application
        Name=Axiom OS
        Exec=axiom-bridge
        StartupNotify=true
      '';
    };
  };
}