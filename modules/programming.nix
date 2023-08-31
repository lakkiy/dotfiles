{ config, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    nixfmt
    protobuf

    # go
    gopls
    gotools # goimports
    go-tools # staticcheck
    delve
    gogetdoc
    impl
    gotests
    gomodifytags
    reftools # fillstruct
    godef
    protoc-gen-go
    protoc-gen-go-grpc

    # tag system
    universal-ctags
    global
    python39Packages.pygments
    cscope

    clojure
    leiningen

    pypy3                                     # python3 with jit enabled
    pipx                                      # install single python package like mycli
    nodePackages.pyright                      # lsp server

    deno
    nodePackages.typescript
    nodePackages.vscode-langservers-extracted # lsp server
    nodePackages.pnpm

    # for copilet.el
    nodejs-slim
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

  home.file.".globalrc".source = ./files/globalrc;
}
