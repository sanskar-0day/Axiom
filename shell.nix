{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    nim
    pkg-config
    webkitgtk
    gtk3
  ];
}
