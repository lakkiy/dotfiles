{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    go

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
}
