#!/bin/bash

# curl -o /home/ci.sh https://raw.githubusercontent.com/cchive/sandbox/main/ci.sh
# chmod 777 /home/ci.sh
# ls /sys/firmware/efi
# lsblk | grep -v 'rom\|loop\|airoot'

if [[ $(ls /sys/firmware/efi | grep 'efivars') == *efivars* ]]; then
  echo "Found a efivars!"
else
  echo "Not UEFI!"
  exit 1
fi

lsblk | grep -v 'rom\|loop\|airoot'
# exit 1

DEVICE=/dev/sda
DEVICE_1_EFI_=${!DEVICE}1
DEVICE_2_BOOT=${!DEVICE}2
DEVICE_3_MNT_=${!DEVICE}3

echo sgdisk -z ${!DEVICE}
echo sgdisk -n 1:0:+512M -t 1:ef00 -c 1:"EFI System" ${!DEVICE}
echo sgdisk -n 2:0:+512M -t 2:8300 -c 2:"Linux filesystem"　${!DEVICE}
echo sgdisk -n 3:0: -t 3:8300 -c 3:"Linux filesystem" ${!DEVICE}

echo mkfs.vfat -F32 ${!DEVICE_1_EFI_}
echo mkfs.ext4 ${!DEVICE_2_BOOT}
echo mkfs.ext4 ${!DEVICE_3_MNT_}

echo mount ${!DEVICE_3_MNT_} /mnt
echo mkdir /mnt/boot
echo mount ${!DEVICE_2_BOOT} /mnt/boot
echo mkdir /mnt/boot/efi
echo mount ${!DEVICE_1_EFI_} /mnt/boot/efi
