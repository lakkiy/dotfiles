if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -g fish_greeting

# envioronment variable {
set LANG "en_US.UTF-8"
set EDITOR vim

# sdcv
set STARDICT_DATA_DIR $HOME/.sdcv-dict

# golang
set GOPROXY https://goproxy.cn
set GO111MODULE on
set GOPATH $HOME/go
set PATH $PATH $GOPATH/bin

# for osx tui emacs paste non-ascii mess-up problem
set LC_ALL en_US.UTF-8

# gnu global && emacs citre-global
# Set this to save gtags database to GTAGSOBJDIRPREFIX/<project-root>.  This
# requires --objdir option in gtags command line, see citre-global-gtags-args.
set GTAGSOBJDIRPREFIX ~/.cache/gtags/
# Make sure you use the path to the default config file on your machine.  This
# file contains the definition for Pygments plugin parser.
set GTAGSCONF ~/.globalrc
# Use gtags built in parse for native support language and others use pygments.
set GTAGSLABEL native-pygments

#}

# aliases {
alias h history
alias c clear

switch (uname)
    case Darwin
        alias bu 'brew update && brew upgrade'
        alias bcu 'brew cu --all --yes --cleanup'
        alias bua 'bu && bcu'
    case Linux
        # TODO Archlinux aliases, maybe debian or ubuntu
end

#}

# Local customizations, e.g. theme, plugins, aliases, etc.
if test -e ~/.local.fish
    source ~/.local.fish
end
