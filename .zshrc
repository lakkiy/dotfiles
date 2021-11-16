# where should we store your Zsh plugins?
ZPLUGINDIR=$HOME/.zsh/plugins

# if you want to use unplugged, you can copy/paste plugin-clone here, or just pull the repo
if [[ ! -d $ZPLUGINDIR/zsh_unplugged ]]; then
  git clone https://github.com/mattmc3/zsh_unplugged $ZPLUGINDIR/zsh_unplugged
fi
source $ZPLUGINDIR/zsh_unplugged/unplugged.zsh

autoload -U compinit
compinit

# add your plugins to this list
plugins=(
  # NOTE: fzf-tab needs to be loaded after compinit, 
  # but before plugins which will wrap widgets, 
  # such as zsh-autosuggestions or fast-syntax-highlighting!!
  Aloxaf/fzf-tab

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

# clone, source, and add to fpath
for repo in $plugins; do
    plugin-load https://github.com/${repo}.git
done
unset repo

PS1='%~ %(?.%F{cyan}.%F{magenta})» '

zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b' 
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':fzf-tab:*' switch-group ',' '.'

alias ls="ls --color"
alias python="python3"

# Local customizations, e.g. theme, plugins, aliases, etc.
[ -f $HOME/.zshrc.local ] && source $HOME/.zshrc.local
