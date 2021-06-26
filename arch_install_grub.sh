#!/bin/bash

ARCH_FILE_SYSTEM=/dev/sda
USER=test

# Installing grub:

# UEFI
# grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id = Arch

# BIOS
grub-install $ARCH_FILE_SYSTEM


# Now to generate the configuration file:
grub-mkconfig -o /boot/grub/grub.cfg


# Adding a user:
useradd -mG wheel $USER
# Giving a password to the user:
passwd $USER
# Now to give usersfrom the wheel group full sudo access:
visudo
# Uncomment the line which says %wheel ALL=(ALL) ALL

# Step 22: Restarting into Arch
# 
# ## Exiting the installation
# exit
# ## Unmounting all drives
# umount -l /mnt
# ## If you're installing Arch on VM
# shutdown now
# ## If you're dual booting/installing on a device
# reboot

