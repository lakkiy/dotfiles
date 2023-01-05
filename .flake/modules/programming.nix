{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    python3Minimal
    python39Packages.epc
    python39Packages.orjson
    nodePackages.pyright

    deno
    nodePackages.typescript
    nodePackages.vscode-langservers-extracted
    nodePackages.pnpm

    clojure
    leiningen

    universal-ctags
    global
    cscope
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
}
