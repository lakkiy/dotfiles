{ config, pkgs, ... }:

{
  services.emacs.enable = true;

  programs.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
    extraPackages = epkgs: with epkgs; [
      visual-fill-column
      deadgrep
      go-translate
      fanyi
      restclient
      leetcode
      d2-mode
      ob-d2
      websocket
      async-await
      markdown-mode
      gptel
      envrc
      ox-gfm
      ob-restclient
      ob-go
      org-appear
      valign
      toc-org
      htmlize
      org-variable-pitch
      org-download
      org-present
      citar
      magit
      magit-delta
      diff-hl
      magit-todos
      dired-sidebar
      dirvish
      eat
      w3m
      nerd-icons
      nerd-icons-ibuffer
      nerd-icons-completion
      telega
      org-static-blog
      xeft
      toml-mode
      yaml-mode
      docker-compose-mode
      dockerfile-mode
      k8s-mode
      git-modes
      terraform-mode
      markdown-mode
      markdown-toc
      protobuf-mode
      csv-mode
      dired-toggle-sudo
      elpa-mirror
      bind
      gcmh
      async
      fullframe
      hide-mode-line
      pinyinlib
      ace-window
      popper
      window-numbering
      switchy-window
      ibuffer-vc
      isearch-mb
      vertico
      marginalia
      consult
      orderless
      embark
      consult-yasnippet
      consult-dir
      consult-eglot
      solaire-mode
      default-text-scale
      minions
      meow
      anzu
      separedit
      iscroll
      vundo
      rime
      symbol-overlay
      hl-todo
      ligature
      avy
      corfu
      popon
      corfu-terminal
      yasnippet
      devdocs
      imenu-list
      paredit
      puni
      dumb-jump
      apheleia
      eldoc-box
      citre
      aggressive-indent
      go-mode
      flymake-go-staticcheck
      go-gen-test
      go-tag
      go-dlv
      go-fill-struct
      go-impl
      gotest
      nix-mode
      clojure-mode
      cider
      clj-refactor
      lua-mode
      rust-mode
      typescript-mode
      (treesit-grammars.with-grammars (p: builtins.attrValues p))
      # NOTE these is undefined
      # nix-ts-mode
      # gpt-commit
      # tabnine
      #------------
      # FIXME compile rime failed
      rime
    ];
  };
}
