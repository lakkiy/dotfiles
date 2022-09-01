### Plugin manager

ZPLUGINDIR=$HOME/.zsh/plugins
PS1="%n@%m %1~ %# "

# if you want to use unplugged, you can copy/paste plugin-clone here, or just pull the repo
if [[ ! -d $ZPLUGINDIR/zsh_unplugged ]]; then
    echo "Cloning mattmc3/zsh_unplugged"
    git clone https://github.com/mattmc3/zsh_unplugged $ZPLUGINDIR/zsh_unplugged --quiet
fi
source $ZPLUGINDIR/zsh_unplugged/zsh_unplugged.plugin.zsh

# use curl download single file and source it
function load-files () {
    local file_name dir_name
    for url in $@; do
        file_name=${${url##*/}%}
        dir_name="${ZPLUGINDIR:-$HOME/.zsh/plugins}/$file_name"

        if [[ ! -d $dir_name ]]; then
            mkdir -p $dir_name
        fi
        if [[ ! -f $dir_name/$file_name ]]; then
		    echo "Downloading $url..."
            curl -sSL $url -o $dir_name/$file_name
        fi

        fpath+=$dir_name
        if (( $+functions[zsh-defer] )); then
            zsh-defer source $dir_name/$file_name
        else
            source $dir_name/$file_name
        fi
    done
}


### Basic config

autoload -U compinit
compinit


### History
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS
HISTSIZE='128000'
SAVEHIST='128000'


### Plugins

plugins=(
    # use zsh-defer magic to load the remaining plugins at hypersonic speed!
    romkatv/zsh-defer

    # core plugins
    zsh-users/zsh-autosuggestions
    zsh-users/zsh-history-substring-search
    zsh-users/zsh-completions

    # user plugins
    rupa/z
    hlissner/zsh-autopair
    djui/alias-tips
    peterhurford/up.zsh

    # load this one last
    zsh-users/zsh-syntax-highlighting
)

files=(
    # ohmyzsh
    https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/colored-man-pages/colored-man-pages.plugin.zsh
    https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/git/git.plugin.zsh
    https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/common-aliases/common-aliases.plugin.zsh
    https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/fancy-ctrl-z/fancy-ctrl-z.plugin.zsh
    https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/extract/extract.plugin.zsh
    https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/fzf/fzf.plugin.zsh
)

# clone, source, and add to fpath
plugin-load $plugins
load-files $files

### Alias
# Basic
alias ls="ls --color=auto"
alias python="python3"
alias k="kubectl"

# Emacs
alias te='emacs -nw'
alias me='emacs -q -l ~/.config/emacs/lisp/init-eat.el'
alias mte='emacs -nw -q -l ~/.config/emacs/lisp/init-eat.el'
alias e='emacsclient -a "" -c -n'

# Modern Unix Tools
# See https://github.com/ibraheemdev/modern-unix
alias diff="delta"
alias find="fd"
alias grep="rg"


### Vterm
if [[ "$INSIDE_EMACS" = 'vterm' ]]; then
    # use C-c C-l to clean vterm buffer
    alias clear='vterm_printf "51;Evterm-clear-scrollback";tput clear'
    source $HOME/.vterm
fi

### Local customizations, e.g. theme, plugins, aliases, etc.
[ -f $HOME/.zshrc.local ] && source $HOME/.zshrc.local
