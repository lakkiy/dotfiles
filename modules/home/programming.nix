{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    python3Minimal
    pipx
    nodePackages.pyright
    # python39Packages.epc
    # python39Packages.orjson

    deno
    nodePackages.typescript
    nodePackages.vscode-langservers-extracted
    nodePackages.pnpm

    clojure
    leiningen

    universal-ctags
    global
    python39Packages.pygments
    cscope

    nixfmt
  ];

  programs.go = {
    enable = true;
    goPath = ".go";
  };
  home.sessionVariables = {
    # go
    GO111MODULE="auto";
    GOPROXY="https://goproxy.io,direct";
    # global gtags
    GTAGSOBJDIRPREFIX="$HOME/.cache/gtags/";
    GTAGSCONF="$HOME/.globalrc";
    GTAGSLABEL="native-pygments";
  };
  home.sessionPath = [
    # go
    "$GOPATH/bin"
  ];

  home.file.".globalrc".source = ../files/globalrc;
}
