#!/bin/bash
if [ ! -f ~/.bash_profile ]; then
PATH=~/bin:$PATH
echo Add PATH=~/bin
fi

ls /sys/firmware/efi
