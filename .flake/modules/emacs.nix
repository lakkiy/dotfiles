{ config, pkgs, ... }:

{
  services.emacs = {
    enable = true;
    package = emacs-overlay.emacsPgtk;
  };

  home.packages = with pkgs; [
    pandoc
    mpv
    tdlib  # telega
    xapian # xeft
    notmuch # mail
    afew # tag mail
    isync # sync mail
    librime # emacs-rime
    imagemagick # dirvish
    mediainfo
    ffmpegthumbnailer
    poppler
    aspell # spell check
  ];
}
