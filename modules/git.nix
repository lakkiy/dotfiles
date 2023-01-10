{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "404cn";
    userEmail = "liubolovelife@gmail.com";
    delta.enable = true;
    extraConfig = {
      pull.rebase = true;
      push.default = "current";
      diff.colorMoved = "default";
      merge.conflictStyle = "diff3";
      include.path = "$HOME/.gitconfig";
      credential.helper = if pkgs.stdenv.isLinux then "store" else "osxkeychain";
    };
    ignores = [
      ".DS_Store"
      "*.bak"
      "*.log"
      "*.swp"
      "tags"
      "GPATH"
      "GRTAGS"
      "GTAGS"
    ];
  };
}
