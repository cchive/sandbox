PATH=/use/bin
#!/bin/bash
if [ ! -f ~/.bash_profile ]; then
PATH=~/bin:/use/bin:$PATH
echo Add PATH=~/bin
fi

ls /sys/firmware/efi
