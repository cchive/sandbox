#!/bin/bash

# curl -o /home/ci.sh https://raw.githubusercontent.com/cchive/sandbox/main/ci.sh
# chmod 777 /home/ci.sh
# ls /sys/firmware/efi
# lsblk | grep -v 'rom\|loop\|airoot'

if [ "x$1" = "-h" -o "x$1" = "--help" ]; then
  echo "Usage: $0 [-h|--help]"
fi

if [[ $(ls /sys/firmware/efi | grep 'efivars') == *efivars* ]]; then
  echo "Found a efivars!"
else
  echo "Not UEFI!"
  exit 1
fi

lsblk | grep -v 'rom\|loop\|airoot'
# exit 1

DEVICE="/dev/sda"
DEVICE_1_EFI_="${DEVICE}1"
DEVICE_2_BOOT="${DEVICE}2"
DEVICE_3_MNT_="${DEVICE}3"

echo ${DEVICE}
echo ${DEVICE_1_EFI_}
echo ${DEVICE_2_BOOT}
echo ${DEVICE_3_MNT_}

sgdisk -z ${DEVICE}
sgdisk -n 1:0:+512M -t 1:ef00 -c 1:"EFI System" ${DEVICE}
sgdisk -n 2:0:+512M -t 2:8300 -c 2:"Linux filesystem"　${DEVICE}
sgdisk -n 3:0: -t 3:8300 -c 3:"Linux filesystem" ${DEVICE}

mkfs.vfat -F32 ${DEVICE_1_EFI_}
mkfs.ext4 ${DEVICE_2_BOOT}
mkfs.ext4 ${DEVICE_3_MNT_}

mount ${DEVICE_3_MNT_} /mnt
mkdir /mnt/boot
mount ${DEVICE_2_BOOT} /mnt/boot
mkdir /mnt/boot/efi
mount ${DEVICE_1_EFI_} /mnt/boot/efi

# Install Arch Linux
pacstrap /mnt base base-devel linux linux-firmware grub efibootmgr dosfstools netctl vim
# Add Wifi
# base base-devel linux linux-firmware grub efibootmgr dosfstools netctl vim iw wpa_supplicant networkmanager dialog

# Genarate fstab
genfstab -U /mnt >> /mnt/etc/fstab


arch-chroot /mnt /bin/bash

# vim /etc/locale.gen
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8 UTF-8" > /etc/locale.conf

# tzselect
#  > 5、20、1
ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
hwclock --systohc --utc

echo "ARCH" > /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1 localhost" >> /etc/hosts

mkinitcpio -p linux
# passwd

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB --boot-directory=/boot/efi/EFI --recheck
grub-mkconfig -o /boot/efi/EFI/grub/grub.cfg

# Fallback bootloader
# EFI\boot\bootx64.efi
mkdir -p /boot/efi/EFI\boot\
cp /boot/efi/EFI/grub/grubx64.efi /boot/efi/EFI\boot\bootx64.efi

exit
exit 1
