#!/bin/bash
if [[ $(ls /sys/firmware/efi | grep 'efivars') == *efivars* ]]; then
  echo Found.
else
  echo Not Found.
fi
echo exit($?)
