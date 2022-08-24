#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

### History ignore dup
export HISTCONTROL=ignoredups

### init zoxide for z command
eval "$(zoxide init bash)"

### enable fzf bindings
# curl -fsSL https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.bash >> ~/.fzf.bash
# curl -fsSL https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.bash >> ~/.fzf.bash
[[ -f ~/.fzf.bash ]] && . ~/.fzf.bash

### alias
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
    # use C-c C-l to clear vterm buffer
    function clear(){
        vterm_printf "51;Evterm-clear-scrollback";
        tput clear;
    }
    source $HOME/.vterm
fi

### local
[[ -f ~/.bashrc_local ]] && . ~/.bashrc_local
