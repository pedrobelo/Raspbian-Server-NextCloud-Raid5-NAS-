#!/bin/bash

echo "Creating RAID5 array"

#install raid software
sudo apt-get install mdadm

#create the array with all the disks passed as arguments
echo -e "yes\n" | sudo mdadm --create --verbose /dev/md0 --level=5 --raid-devices=$# $@ 2>/dev/null

#see if this works
sudo mdadm --wait /dev/md0

#create file system on the array
sudo mkfs.ext4 -F /dev/md0

#mount point to attach the new filesystem
sudo mkdir -p /mnt/md0

#mount the file system
sudo mount /dev/md0 /mnt/md0

#append the file
sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf

#sutomatic mount at boot
echo '/dev/md0 /mnt/md0 ext4 defaults,nofail,discard 0 0' | sudo tee -a /etc/fstab
