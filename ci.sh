#!/bin/bash

# curl -o /home/ci.sh https://raw.githubusercontent.com/cchive/sandbox/main/ci.sh
#chmod 777 /home/ci.sh

ls /sys/firmware/efi

if [[ $(ls /sys/firmware/efi | grep 'efivars') == *efivars* ]]; then
  echo "Found a efivars!"
else
  echo "Not UEFI!"
  exit 1
fi

lsblk | grep -v 'rom\|loop\|airoot'
