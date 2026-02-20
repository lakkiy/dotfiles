{ config, pkgs, lib, user, ... }: {
  # Host-specific home-manager configuration
  home-manager.users.${user} = {
    imports = [
      ../modules/home/dev.nix
    ];
    my.dev.enable = true;
    home.file.".config/karabiner/karabiner.json".source = ../static/karabiner.json;
  };

  fonts.packages = with pkgs; [
    cascadia-code
    ibm-plex

    # variable
    cardo

    # CJK
    lxgw-wenkai
    sarasa-gothic
    source-han-sans
    source-han-serif

    # icons & backup font
    nerd-fonts.symbols-only
  ];

  homebrew = {
    enable = true;
    taps = [];
    brews = [
      "coreutils" # gls
      "pngpaste"  # paste image in emacs telega
      "librime"   # emacs-rime
      # 测试配置文件和使用自用的节点裸核跑的时候使用
      # You need to customize /opt/homebrew/etc/mihomo/config.yaml.
      # To start mihomo now and restart at login:
      # brew services start mihomo
      # Or, if you don't want/need a background service you can just run:
      # /opt/homebrew/opt/mihomo/bin/mihomo -d /opt/homebrew/etc/mihomo
      "mihomo" # sing-box
    ];
    casks = [
      "zen"
      "iterm2" # 系统终端在 screen 中不能用滚轮上下滑动
      "bitwarden"
      "karabiner-elements"
      "squirrel-app"
      "the-unarchiver"
      "raycast"
      "dropbox"
      "iina"
      "keepingyouawake"
      "folo"
      "chatgpt" "claude" "claude-code"
    ];
  };
}
