#!/bin/bash

function is_uefi() {
  if [[ $(ls /sys/firmware/efi | grep 'efivars') == *efivars* ]]; then
    return 1
  else
    return -1
  fi
}

is_uefi
exit $?
