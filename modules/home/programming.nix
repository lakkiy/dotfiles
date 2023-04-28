{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # lsp-bridge dep
    # python311Packages.epc
    # python311Packages.orjson
    # python311Packages.six
    # python311Packages.paramiko
    # python311Packages.sexpdata

    pypy3 # python3 with jit enabled
    pipx
    nodePackages.pyright

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
