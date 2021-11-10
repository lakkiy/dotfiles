if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -g fish_greeting

# envioronment variable {
set -gx LANG "en_US.UTF-8"
set -gx EDITOR vim

# sdcv
set -gx STARDICT_DATA_DIR $HOME/.sdcv-dict

# golang
set -gx GOPROXY https://goproxy.cn
set -gx GO111MODULE on
set -gx GOPATH $HOME/go
fish_add_path $GOPATH/bin

# for osx tui emacs paste non-ascii mess-up problem
set -gx LC_ALL en_US.UTF-8

# gnu global && emacs citre-global
# Set this to save gtags database to GTAGSOBJDIRPREFIX/<project-root>.  This
# requires --objdir option in gtags command line, see citre-global-gtags-args.
set -gx GTAGSOBJDIRPREFIX ~/.cache/gtags/
# Make sure you use the path to the default config file on your machine.  This
# file contains the definition for Pygments plugin parser.
set -gx GTAGSCONF ~/.globalrc
# Use gtags built in parse for native support language and others use pygments.
set -gx GTAGSLABEL native-pygments

# fzf
set -g FZF_DEFAULT_COMMAND "fd --type f --hidden --follow --exclude .git || git ls-tree -r --name-only HEAD || rg --hidden --files || find ."
set -g FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -g FZF_CTRL_T_OPTS "--preview '(bat --style=numbers --color=always {} || cat {} || tree -NC {}) 2> /dev/null | head -200'"
set -g FZF_CTRL_R_OPTS "--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview' --exact"
set -g FZF_ALT_C_OPTS "--preview 'tree -NC {} | head -200'"

#}

# aliases {
alias ls "ls --color"
# reinstall vim and neovim for python3 support
function python
    python3
end

# FIXME https://github.com/jorgebucaran/cookbook.fish#aliases
switch (uname)
    case Darwin
        function bu
            brew update && brew upgrade
        end
        function bcu
            brew cu --all --yes --cleanup
        end
        function bua
            command bu && bcu
        end
        function set-homebrew-mirror
        # TODO
        end
        function reset-homebrew-mirror
        # TODO
        end
    case Linux
        # TODO Archlinux aliases, maybe debian or ubuntu
end

#}

# Local customizations, e.g. theme, plugins, aliases, etc.
if test -e ~/.local.fish
    source ~/.local.fish
end
