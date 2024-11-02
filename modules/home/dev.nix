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
      protobuf buf grpcurl
      emacs-lsp-booster
      universal-ctags global
    ]
    ++ [
      # C
      ccls
      # gdb # FIXME platform not support for m3air
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
      oapi-codegen
    ]
    ++ [
      # Python
      ruff pipx pdm
      (python3.withPackages (ps:
        with ps; [
          pygments #  for gtags
          debugpy pip
          requests pytest

          # conda # FIXME build failed on m-mac

          # jupytext ipython jupyterlab notebook

          # lsp-bridge for emacs
          # epc orjson sexpdata six setuptools paramiko rapidfuzz
        ]))

      # FIXME not in nixpkgs darwin 24
      # aider-chat
    ]
    ++ [
      # Web
      nodejs-slim typescript deno
      nodePackages.npm nodePackages.pnpm
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      sassc # compile scss/sass to css
    ]
    ++ [
      # Rust
      cargo rustc rust-analyzer rustfmt
      llvmPackages.bintools # lld, faster linking
      # cargo-audit cargo-expand cargo-edit cargo-watch cargo-tarpaulin
      # clippy # lint #FIXME build failed on m-mac
    ]
    ++ [
      # Lisp
      clojure
      leiningen
      jdk

      # $raco pkg install sicp
      # #lang sicp
      # (require sicp) in REPL
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
