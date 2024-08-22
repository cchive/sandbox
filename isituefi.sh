#!/bin/bash
if [[ $(ls /sys/firmware/efi | grep 'efivars') == *efivars* ]]; then
  exit 1
else
  exit -1
fi
