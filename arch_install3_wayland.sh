#!/bin/bash
# Install wayland for archlinux

# Install for intel graph card

sudo pacman -S sway alacritty waybar wofi xorg-xwayland xorg-xlsclients qt5-wayland glfw-wayland xf86-video-intel xterm firefox

ln -sf sway ~/.config/sway
# change alacritty to xterm
cd ~/.config
mkdir sway
cd sway
cp /etc/sway/config .

sway

# install yay
pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# display manager
git clone https://github.com/nullgemm/ly.git
make github
make
sudo make install
systemctl enable ly

# archlinux cn
sudo echo "[archlinuxcn]
Server = https://repo.archlinuxcn.org/$arch" >> /etc/pacman.conf
sudo pacman -Syu
sudo pacman -S archlinuxcn-keyring

# qv2ray
sudo pacman -S qv2ray

# 修正系统时间
sudo date -s 10:10:10
sudo hwclock -w

# file manager
sudo pacman -S thunar

# 显示中文字体
sudo pacman -S noto-fonts-cjk
