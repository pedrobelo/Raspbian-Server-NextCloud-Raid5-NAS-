#!/bin/bash

#add drive
sudo mdadm /dev/md0 --add $1

#grow array --need to change number of devices
sudo mdadm --grow --raid-devices=4 --backup-file=/root/md0_grow.bak /dev/md0

#see if this works
mdadm --wait /dev/md0

#expand the filesystem
sudo resize2fs /dev/md0
