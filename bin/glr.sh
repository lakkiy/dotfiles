#!/bin/bash
# get github latest release tag

set -u

project_name=$1

tag=$(command curl -L
      https://github.com/$project_name/releases/latest |egrep -o
      "$project_name/releases/tag/[^\"]*\" data-view-component" |cut
      -d'"' -f1 |rev|cut -d'/' -f1 |rev)

echo "$tag"

# download latest binary with release tag
# folder=~/utils/modern-unix-commands/bin
# mkdir -p $folder
# tag=$(glr ducaale/xh)
# url=https://github.com/ducaale/xh/releases/download/${tag}/xh-${tag}-x86_64-unknown-linux-musl.tar.gz
# echo $url
# curl -L $url -o $folder/xh.tar.gz && tar xvf $folder/xh.tar.gz -C
# $folder && rm -f $folder/xh.tar.gz
