#!/bin/bash
function is_uefi() {
  [[ $(ls /sys/firmware/efi | grep 'efivars') == *efivars* ]]
}

is_uefi
exit $?

# example
if is_uefi; then
  echo UEFI
else
  echo NOT UEFI
fi
