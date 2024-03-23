{ config, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    protobuf
    emacs-lsp-booster

    # tag system
    universal-ctags
    global
    cscope

    #langs
    # FIXME the nix version that nixd used was insecure, casue the
    # nixos-build false, also see:
    # https://github.com/nix-community/nixd/issues/357
    # nixd
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
    nodePackages.npm # emacs copilot need this to install copilot server
    nodePackages.pnpm
    # python
    nodePackages.pyright                      # lsp server
    (python3.withPackages(ps: with ps; [
      ipython
      pdm # manage project dep
      pip
      pipx # venv for cli tools installed by pip
      pam # for ags
      pygments # for gtags
       # lsp-bridge for emacs
      epc orjson sexpdata six setuptools paramiko rapidfuzz
      # blink-search for emacs
      requests
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

  home.file.".globalrc".source = ../files/globalrc;
}
