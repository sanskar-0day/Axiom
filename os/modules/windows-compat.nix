{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.axiom.windowsCompat;
in
{
  options.axiom.windowsCompat = {
    wine.enable = mkEnableOption "Wine for running Windows applications";

    vm = {
      enable = mkEnableOption "Windows VM with GPU passthrough";
      memoryMB = mkOption {
        type = types.int;
        default = 4096;
        description = "RAM allocated to the Windows VM in MB";
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.wine.enable {
      environment.systemPackages = with pkgs; [
        wineWowPackages.stable
        winetricks
        protontricks
      ];
    })

    (mkIf cfg.vm.enable {
      virtualisation.libvirtd.enable = true;
      programs.virt-manager.enable = true;

      environment.systemPackages = with pkgs; [
        qemu
        looking-glass-client
      ];

      users.users.${config.axiom.user or "user"}.extraGroups = [ "libvirtd" ];
    })
  ];
}