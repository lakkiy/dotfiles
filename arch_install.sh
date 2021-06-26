#!/bin/bash

SWAP=/dev/sda1
ARCH_FILE_SYSTEM=/dev/sda2
HOST_NAME=arch

# CONNECT WIFI
# use iwctl to connect to wifi
# [iwd]# help
# [iwd]# device list
# [iwd]# station device scan
# [iwd]# station device get-networks
# [iwd]# station device connect SSID

# INIT FILE SYSTEM
# use fdisk to init disk
# 8G for swap
# other is /(root) partition
# fdisk-
#       g
#       n
#       +300M   (boot)
#       n
#       +8G     (swap)
#       n
#       (enter)
#       t (changing partition type)
#       1
#       (Choose swap)

mkswap $SWAP
swapon $SWAP

mkfs.btrfs $ARCH_FILE_SYSTEM


# Now we must mount the partitions that we just created 
# (except swap as it is not used to store static files).

mount $ARCH_FILE_SYSTEM /mnt


# Now that we have mounted the root subvolume, we must create subvolumes for btrfs.
# We create subvolumes to better organize our data and to exclude them from btrfs snapshots. Also, if you’re using multiple disks for a single OS (eg. Windows C: and D: drives are on different disks), subvolumes enable you to store even system files on another directory. On my personal setup, I have the @var and @tmp subvolumes on my HDD so as to save space on my SSD where Arch is installed.

btrfs su cr /mnt/@
btrfs su cr /mnt/@home
btrfs su cr /mnt/@.snapshots
umount /mnt

# This is for HDD. TODO SSD
mount -o noatime,commit=120,compress=zstd,space_cache,subvol=@ $ARCH_FILE_SYSTEM /mnt
# You need to manually create folder to mount the other subvolumes at
mkdir /mnt/home
mkdir /mnt/.snapshots
mount -o noatime,commit=120,compress=zstd,space_cache,subvol=@home $ARCH_FILE_SYSTEM /mnt/home
mount -o noatime,commit=120,compress=zstd,space_cache,subvol=@.snapshots $ARCH_FILE_SYSTEM /mnt/.snapshots


# for amd cpu change intel-ucode to amd-ucode, for vms just delete this.
pacstrap -i /mnt base linux linux-firmware base-devel vim nano snapper intel-ucode btrfs-progs


# basic config
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
hostnamectl set-hostname $HOST_NAME

# append this to /etc/hosts
echo "127.0.0.1	localhost" >> /etc/hosts
echo "::1		localhost" >> /etc/hosts
echo "127.0.1.1	$HOST_NAME.localdomain	$HOST_NAME" >> /etc/hosts

# setting password for root
passwd

# efibootmgr
pacman -S grub grub-btrfs grub-bios base-devel linux-headers networkmanager network-manager-applet wpa_supplicant dialog os-prober mtools dosfstools reflector git bluez bluez-utils xdg-utils xdg-user-dirs
systemctl enable NetworkManager
## If you installed bluez
systemctl enable bluetooth


# Step 18: Adding btrfs module to mkinitcpio
# 
# nano /etc/mkinitcpio.conf
# Add btrfs in MODULES=()
# 
# Now to recreate the image:
# 
# mkinitcpio -p linux
# Replace linux with linux-lts if you installed the lts kernel
