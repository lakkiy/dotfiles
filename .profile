# enviroment variable

# Bash history ignore dup
export HISTCONTROL=ignoredups

export EDITOR='emacs -nw -q -l ~/.config/emacs/lisp/init-eat.el'
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export TERM=xterm-256color
export PATH=$HOME/bin:$PATH

### FZF
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git || git ls-tree -r --name-only HEAD || rg --files --hidden --follow --glob '!.git' || find ."
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview '(bat --style=plain --color=always {} || cat {} || tree -NC {}) 2> /dev/null | head -200'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview' --exact"
export FZF_ALT_C_OPTS="--preview 'tree -NC {} | head -200'"

### Golang
export GO111MODULE=auto
export GOPROXY=https://goproxy.io,direct
export GOPATH=$HOME/go
export PATH=${GOPATH//://bin:}/bin:${GOROOT//://bin:}/bin:$PATH

### Rust
export PATH=$HOME/.cargo/bin:$PATH

### Global(gtags)
export GTAGSOBJDIRPREFIX=$HOME/.cache/gtags/
export GTAGSCONF=$HOME/.globalrc
export GTAGSLABEL=native-pygments

### sdcv
export STARDICT_DATA_DIR=$HOME/.sdcv-dict

### krew -- kubectl plugin manager
export PATH="${PATH}:${HOME}/.krew/bin"

### local env
[ -f ~/.profile.local ] && source ~/.profile.local
