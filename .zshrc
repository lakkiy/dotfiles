# where should we store your Zsh plugins?
ZPLUGINDIR=$HOME/.zsh/plugins

# if you want to use unplugged, you can copy/paste plugin-clone here, or just pull the repo
if [[ ! -d $ZPLUGINDIR/zsh_unplugged ]]; then
  git clone https://github.com/mattmc3/zsh_unplugged $ZPLUGINDIR/zsh_unplugged
fi
source $ZPLUGINDIR/zsh_unplugged/unplugged.zsh

# use curl download single file and source it
function load-file () {
    local url="$1"
    local file_name=${${url##*/}%}
    local dir_name="${ZPLUGINDIR:-$HOME/.zsh/plugins}/$file_name"

    if [[ ! -d $dir_name ]]; then
        mkdir -p $dir_name
    fi
    if [[ ! -f $dir_name/$file_name ]]; then
		echo "Downloading $url..."
        curl -sSL $url -o $dir_name/$file_name
    fi

    source $dir_name/$file_name
    fpath+=$dir_name
}

autoload -U compinit
compinit

setopt HIST_IGNORE_DUPS
HISTSIZE='128000'
SAVEHIST='128000'

# for theme support see
# https://github.com/zthxxx/jovial/issues/16
setopt prompt_subst
autoload -U colors && colors
typeset -AHg FG BG
for color in {000..255}; do
  FG[$color]="%{\e[38;5;${color}m%}"
  BG[$color]="%{\e[48;5;${color}m%}"
done

# add your plugins to this list
plugins=(
  # core plugins
  mafredri/zsh-async
  zsh-users/zsh-autosuggestions
  zsh-users/zsh-history-substring-search
  zsh-users/zsh-completions

  # user plugins
  rupa/z
  hlissner/zsh-autopair
  djui/alias-tips

  # load this one last
  zsh-users/zsh-syntax-highlighting
)

files=(
  # theme
  https://github.com/zthxxx/jovial/raw/master/jovial.zsh-theme
  # ohmyzsh
  https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/colored-man-pages/colored-man-pages.plugin.zsh
  https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/git/git.plugin.zsh
  https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/common-aliases/common-aliases.plugin.zsh
  https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/fancy-ctrl-z/fancy-ctrl-z.plugin.zsh
  https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/extract/extract.plugin.zsh
  https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/fzf/fzf.plugin.zsh
)

# clone, source, and add to fpath
for repo in $plugins; do
    plugin-load https://github.com/${repo}.git
done
for file in $files; do
    load-file ${file}
done
unset repo
unset file

# Use jovial theme instead
#PS1='%~ %(?.%F{cyan}.%F{magenta})» '

export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git || git ls-tree -r --name-only HEAD || rg --files --hidden --follow --glob '!.git' || find ."
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview '(bat --style=plain --color=always {} || cat {} || tree -NC {}) 2> /dev/null | head -200'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview' --exact"
export FZF_ALT_C_OPTS="--preview 'tree -NC {} | head -200'"

################## Aliases ##################
# Basic
alias ls="ls --color"
alias python="python3"
alias k="kubectl"

# Emacs
alias e="emacsclient -nw"
alias me="emacs -Q -nw -l ~/.config/emacs/init-mini.el" # mini Emacs
alias mge="emacs -Q -l ~/.config/emacs/init-mini.el" # mini GUI Emacs
alias vim="e" # after Emacs, please

# Modern Unix Tools
# See https://github.com/ibraheemdev/modern-unix
alias diff="delta"
alias find="fd"
alias grep="rg"
################## Aliases ##################

# Local customizations, e.g. theme, plugins, aliases, etc.
[ -f $HOME/.zshrc.local ] && source $HOME/.zshrc.local
