{
  config,
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    protobuf

    # tag system
    universal-ctags global cscope

    # FIXME https://github.com/nix-community/nixd/issues/357
    # nixd
    nixfmt

    gcc gdb ccls

    clojure leiningen jdk

    nodejs-slim typescript deno
    nodePackages.npm nodePackages.pnpm
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    sassc # compile scss/sass to css

    nodePackages.pyright
    (python3.withPackages (ps:
      with ps; [
        requests ipython pip
        pdm      # manage project dep
        pipx     # venv for cli tools installed by pip
        pygments # for gtags
        # lsp-bridge for emacs
        epc orjson sexpdata six setuptools paramiko rapidfuzz
      ]))

    gopls gotools go-tools delve gogetdoc
    impl gotests gomodifytags reftools godef
    protoc-gen-go protoc-gen-go-grpc
    wire

    sbcl lispPackages.quicklisp sbclPackages.quicklisp-stats
  ];

  programs.go = {
    enable = true;
    goPath = ".go";
  };

  home.sessionVariables = {
    GO111MODULE = "auto";
    GOPROXY = "https://goproxy.io,direct";
    GTAGSOBJDIRPREFIX = "$HOME/.cache/gtags/";
    GTAGSCONF = "$HOME/.globalrc";
    GTAGSLABEL = "native-pygments";
  };

  home.sessionPath = [
    "$GOPATH/bin"
  ];

  home.file.".globalrc".source = ./globalrc;
}
