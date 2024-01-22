{ config, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    protobuf

    # tag system
    universal-ctags
    global
    cscope

    #langs
    nixd
    nixfmt
    gcc
    gdb
    ccls
    jdk
    clojure
    leiningen
    sassc # front end for libsass
    # js
    deno
    nodejs-slim # for copilet.el
    typescript
    nodePackages.typescript-language-server   # also for js
    nodePackages.vscode-langservers-extracted # html, css etc
    nodePackages.pnpm
    # python
    #vscode-extensions.ms-python.vscode-pylance
    nodePackages.pyright                      # lsp server
    (python3.withPackages(ps: with ps; [
      ipython
      pam # for ags
      pygments # for gtags
      pdm
      pip
      pipx
      jedi-language-server
      epc orjson sexpdata six setuptools paramiko rapidfuzz # lsp-bridge for emacs
      requests # blink-search for emacs
    ]))
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
    # common lisp
    sbcl
    lispPackages.quicklisp
    sbclPackages.quicklisp-stats
  ];

  programs.go = {
    enable = true;
    goPath = ".go";
  };
  home.sessionVariables = {
    GO111MODULE="auto";
    GOPROXY="https://goproxy.io,direct";
    GTAGSOBJDIRPREFIX="$HOME/.cache/gtags/";
    GTAGSCONF="$HOME/.globalrc";
    GTAGSLABEL="native-pygments";
  };
  home.sessionPath = [
    "$GOPATH/bin"
  ];

  home.file.".globalrc".source = ./files/globalrc;
}
