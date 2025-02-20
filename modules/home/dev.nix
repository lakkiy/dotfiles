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
      # golang
      GO111MODULE = "auto";
      GOPROXY = "https://goproxy.io,direct";

      # gtags
      GTAGSOBJDIRPREFIX = "$HOME/.cache/gtags/";
      GTAGSCONF = "$HOME/.globalrc";
      GTAGSLABEL = "native-pygments";

      # python pdm
      PDM_CONFIG_FILE = "$HOME/.config/pdm/config.toml";
    };

    home.sessionPath = [
      "$GOPATH/bin"
    ];

    home.packages = with pkgs; ([
      emacs-lsp-booster
      protobuf buf grpcurl   # rpc
      universal-ctags global # tag system
      delta                  # better diff
      just gnumake           # command runner
      cloc                   # counts lines of source code
      tailspin               # highlight logs
      litecli mycli pgcli    # rds cli
      kubectl                # k8s
      mongosh                # mongodb
      mosh                   # ssh on udp
    ]
    ++ [
      ccls # lsp server for C
    ]
    ++ [
      gopls                            # lsp server for go
      gotools go-tools                 # goimports staticcheck
      delve                            # debug tool
      gotests                          # generate go test
      gomodifytags                     # modify struct tag
      reftools                         # fillstruct
      protoc-gen-go protoc-gen-go-grpc # rpc
      wire oapi-codegen
    ]
    ++ [
      pipx       # install python cli app
      ruff       # format and check python code
      pdm        # manage python project
      aider-chat # AI tools for editor(emacs)
      (python3.withPackages (ps:
        with ps; [
          pip
          pygments        # for gtags
          debugpy         # debug tool
          requests pytest # general python package
          # conda # if need different python version for virtual environment
          # jupytext ipython jupyterlab notebook
        ]))
    ]
    ++ [
      nodejs typescript deno                    # runtime
      nodePackages.npm nodePackages.pnpm        # package management
      nodePackages.typescript-language-server   # lsp server
      nodePackages.vscode-langservers-extracted # lsp server
      sassc                                     # compile scss/sass to css
    ]
    ++ [
      rustc                 # runtime
      cargo                 # dependencies management
      rust-analyzer         # lsp server
      rustfmt               # formatter
      llvmPackages.bintools # lld, faster linking
      # clippy # lint FIXME build failed on m-mac
      # cargo-audit cargo-expand cargo-edit cargo-watch cargo-tarpaulin
    ]
    ++ [
      clojure jdk # lisp on jvm
      leiningen  # dependencies management for clojure

      # $raco pkg install sicp
      # #lang sicp
      # (require sicp) in REPL
      racket # lisp for run sicp
    ]);

    programs.go.enable = true;
    programs.go.goPath = ".go";
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;

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
