#!/bin/bash

# curl -o /home/cc.sh https://raw.githubusercontent.com/cchive/sandbox/main/cc.sh
# chmod 744 /home/cc.sh

function is_uefi() {
  [[ $(ls /sys/firmware/efi | grep 'efivars') == *efivars* ]]
}

function disp_device_list() {
  lsblk | grep -v 'rom\|loop\|airoot'
}

function format_partition() {
  DEVICE="/dev/$1"
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
}

if [ "x$1" = "x-h" -o "x$1" = "x--help" ]; then
  echo "Usage: $0 [-h|--help]"
  exit 0
fi
if [ "x$1" = "x-f" -o "x$1" = "x--format" ]; then
  if [[ $(lsblk | grep -v 'rom\|loop\|airoot' | grep '$2') == *$2* ]]; then
    echo format_partition $2
  fi
  exit 0
fi



if is_uefi; then
  :
else
  echo NOT UEFI!
  exit 1
fi

disp_device_list
exit 0
