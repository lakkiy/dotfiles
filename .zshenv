### ZSH envioronment

export EDITOR='emacsclient -a "" -c -n "$@"'
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export TERM=xterm-256color
export PATH=$HOME/bin:$PATH

### Golang
export GO111MODULE=auto
export GOPROXY=https://goproxy.cn
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

### Local zshenv
[ -f ~/.zshenv.local ] && source ~/.zshenv.local
