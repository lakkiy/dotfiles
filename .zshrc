### Plugin manager

ZPLUGINDIR=$HOME/.zsh/plugins

# if you want to use unplugged, you can copy/paste plugin-clone here, or just pull the repo
if [[ ! -d $ZPLUGINDIR/zsh_unplugged ]]; then
    echo "Cloning mattmc3/zsh_unplugged"
    git clone https://github.com/mattmc3/zsh_unplugged $ZPLUGINDIR/zsh_unplugged --quiet
fi
source $ZPLUGINDIR/zsh_unplugged/zsh_unplugged.zsh

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

# Provide a nice prompt if the terminal supports it.
# if [ "$TERM" != "dumb" ] || [ -n "$INSIDE_EMACS" ]; then
#   PROMPT_COLOR="1;31m"
#   ((UID)) && PROMPT_COLOR="1;32m"
#   if [ -n "$INSIDE_EMACS" ] || [ "$TERM" = "eterm" ] || [ "$TERM" = "eterm-color" ]; then
#     # Emacs term mode doesn't support xterm title escape sequence (\e]0;)
#     PS1="\n\[\033[$PROMPT_COLOR\][\u@\h:\w]\\$\[\033[0m\] "
#   else
#     PS1="\n\[\033[$PROMPT_COLOR\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\\$\[\033[0m\] "
#   fi
#   if test "$TERM" = "xterm"; then
#     PS1="\[\033]2;\h:\u:\w\007\]$PS1"
#   fi
# fi

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

# Prettify ls
alias l='ls -alh'
alias ll='ls -l'
if (( $+commands[gls] )); then
    alias ls='gls --color=tty --group-directories-first'
else
    alias ls='ls --color=tty'
fi

# Basic
alias python="python3"
alias k="kubectl"

# Emacs
alias te='emacs -nw'
alias e='emacsclient -a "" -c -n'

# Modern Unix Tools
# See https://github.com/ibraheemdev/modern-unix
alias diff="delta"
alias find="fd"
alias grep="rg"

### Local customizations, e.g. theme, plugins, aliases, etc.
[ -f $HOME/.zshrc.local ] && source $HOME/.zshrc.local
