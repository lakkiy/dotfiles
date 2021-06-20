#!/bin/bash

# Go packages
packages=(
    github.com/go-delve/delve/cmd/dlv # debug go program
    github.com/josharian/impl # auto implement interface
    github.com/cweill/gotests/... # run go test
    github.com/fatih/gomodifytags # autp add/remove tags for struct
    golang.org/x/tools/cmd/guru # ask me !
    golang.org/x/tools/cmd/goimports # go fmt with sort import
    # golang.org/x/tools/cmd/gorename
    # github.com/google/gops
    # github.com/aarzilli/gdlv
    # github.com/davidrjenni/reftools/cmd/fillstruct
    # github.com/acroca/go-symbols
    # github.com/haya14busa/goplay/cmd/goplay
    # golang.org/x/tools/cmd/gotype
)

# Do not use the -u flag for gopls, as it will update the dependencies to incompatible versions
# https://github.com/golang/tools/blob/master/gopls/doc/user.md#installation
packages_no_update=(
    golang.org/x/tools/gopls@latest
)

# Use colors, but only if connected to a terminal, and that terminal
# supports them.
if command -v tput >/dev/null 2>&1; then
    ncolors=$(tput colors)
fi
if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    BOLD="$(tput bold)"
    NORMAL="$(tput sgr0)"
else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    BOLD=""
    NORMAL=""
fi

YES=0
NO=1
function promote_yn() {
    eval ${2}=$NO
    read -p "$1 [y/N]: " yn
    case $yn in
        [Yy]* )    eval ${2}=$YES;;
        [Nn]*|'' ) eval ${2}=$NO;;
        *)         eval ${2}=$NO;;
    esac
}

function check() {
    if ! command -v go >/dev/null 2>&1; then
        echo "${RED}Error: go is not installed${NORMAL}" >&2
        exit 1
    fi
}

function install() {
    for p in ${packages_no_update[@]}; do
        printf "${BLUE} ➜  Installing ${p}...${NORMAL}\n"
        go install ${p}
    done

    for p in ${packages[@]}; do
        printf "${BLUE} ➜  Installing ${p}...${NORMAL}\n"
        go get -u ${p}
    done
}

function goclean() {
    go clean -i -n $1
    go clean -i $1
    rm -rf $GOPATH/src/$1
    if [ -d $GOPATH/pkg/${sysOS:l}_amd64/$1 ]; then
        rm -rf $GOPATH/pkg/${sysOS:l}_amd64/$1;
    fi
}

function clean() {
    for p in ${x_tools[@]}; do
        goclean ${p}
    done

    for p in ${packages[@]}; do
        goclean ${p}
    done
}

function main() {
    check

    promote_yn "Clean all packages?" "continue"
    if [ $continue -eq $YES ]; then
        clean
    else
        install
    fi
}

main
