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
    wire # DI

    # python
    nodePackages.pyright                      # lsp server
    (python3.withPackages(ps: with ps; [
      pygments # for gtags
      pdm
      pip
      pipx
      python-lsp-server
      pam # for ags
    ]))

    # tag system
    universal-ctags
    global
    cscope

    clojure
    leiningen

    deno
    nodePackages.typescript
    nodePackages.typescript-language-server   # also for js
    nodePackages.vscode-langservers-extracted # html, css etc
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
