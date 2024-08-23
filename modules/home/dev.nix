{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.dev;
in {
  options.my.dev = {
    enable = mkEnableOption "dev";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      GO111MODULE = "auto";
      GOPROXY = "https://goproxy.io,direct";
      GTAGSOBJDIRPREFIX = "$HOME/.cache/gtags/";
      GTAGSCONF = "$HOME/.globalrc";
      GTAGSLABEL = "native-pygments";
      PDM_CONFIG_FILE = "$HOME/.config/pdm/config.toml";
    };

    home.sessionPath = [
      "$GOPATH/bin"
    ];

    home.packages = with pkgs; ([
      protobuf
      emacs-lsp-booster
      universal-ctags
      global
    ]
    ++ [
      # C
      gdb
      ccls
      cscope
    ]
    ++ [
      # Golang
      gopls
      gotools
      go-tools
      delve
      gogetdoc
      impl
      gotests
      gomodifytags
      reftools
      godef
      protoc-gen-go
      protoc-gen-go-grpc
      wire
    ]
    ++ [
      # Python
      pyright
      ruff
      pipx
      pdm
      (python3.withPackages (ps:
        with ps; [
          pip
          conda
          ipython
          debugpy
          requests
          pytest
          numpy
          jupyterlab
          notebook
          jupytext
          pygments # for gtags

          # lsp-bridge for emacs
          epc
          orjson
          sexpdata
          six
          setuptools
          paramiko
          rapidfuzz
        ]))
    ]
    ++ [
      # Web
      nodejs-slim
      typescript
      deno
      nodePackages.npm
      nodePackages.pnpm
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      sassc # compile scss/sass to css
    ]
    ++ [
      # Rust
      cargo
      rustc
      rust-analyzer
      llvmPackages.bintools # lld, faster linking
      cargo-watch # monitor source code and trigger commands
      cargo-tarpaulin # code coverage
      clippy # lint
      cargo-audit # security
      rustfmt
      cargo-expand
      cargo-edit
    ]
    ++ [
      # Lisp
      clojure
      leiningen
      jdk

      sbcl

      # $raco pkg install sicp
      # Add #lang sicp at the top of the file.
      # When using the REPL, we need to first evaluate (require sicp) before
      # evaluating anything else.
      racket
    ]);

    programs.go = {
      enable = true;
      goPath = ".go";
    };

    home.file.".globalrc".source = ../../static/globalrc;
    home.file.".condarc".text = "auto_activate_base: false";
    home.file.".config/pdm/config.toml".text = ''
      [venv]
      backend = "venv"
    '';
    home.file.".cargo/config.toml".text = ''
      # On Windows
      # ```
      # cargo install -f cargo-binutils
      # rustup component add llvm-tools-preview
      # ```
      [target.x86_64-pc-windows-msvc]
      rustflags = ["-C", "link-arg=-fuse-ld=lld"]
      [target.x86_64-pc-windows-gnu]
      rustflags = ["-C", "link-arg=-fuse-ld=lld"]

      # On Linux:
      # - Ubuntu, `sudo apt-get install lld clang`
      # - Arch, `sudo pacman -S lld clang`
      [target.x86_64-unknown-linux-gnu]
      rustflags = ["-C", "linker=clang", "-C", "link-arg=-fuse-ld=lld"]

      # On MacOS
      [target.x86_64-apple-darwin]
      rustflags = ["-C", "link-arg=-fuse-ld=lld"]
      [target.aarch64-apple-darwin]
      rustflags = ["-C", "link-arg=-fuse-ld=lld"]
    '';
  };
}
