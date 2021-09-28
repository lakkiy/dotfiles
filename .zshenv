# ZSH envioronment

export LANG="en_US.UTF-8"
export TERM=xterm-256color
export DEFAULT_USER=$USER
export EDITOR='vim'
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/sbin:$PATH

# Cask
export PATH=$HOME/.cask/bin:$PATH

# Ruby
export PATH=$HOME/.rbenv/shims:$PATH

# Golang
export GO111MODULE=auto
export GOPROXY=https://goproxy.cn # https://athens.azurefd.net
export GOPATH=$HOME/go
export PATH=${GOPATH//://bin:}/bin:$PATH

# Rust
export PATH=$HOME/.cargo/bin:$PATH

# sdcv
export STARDICT_DATA_DIR=$HOME/.sdcv-dict

# for osx tui emacs paste non-ascii mess-up problem
export LC_ALL=en_US.UTF-8

################# gnu global && emacs citre-global
# Set this to save gtags database to GTAGSOBJDIRPREFIX/<project-root>.  This
# requires --objdir option in gtags command line, see citre-global-gtags-args.
export GTAGSOBJDIRPREFIX=~/.cache/gtags/
# Make sure you use the path to the default config file on your machine.  This
# file contains the definition for Pygments plugin parser.
export GTAGSCONF=~/.globalrc
# Use gtags built in parse for native support language and others use pygments.
export GTAGSLABEL=native-pygments

# Local customizations
[ -f $HOME/.zshenv.local ] && source $HOME/.zshenv.local
