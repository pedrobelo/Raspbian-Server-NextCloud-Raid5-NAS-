#!/bin/bash

echo "Removing drive from array"

#mark drive as faulty
sudo mdadm /dev/md0 --fail $1

#remove drive
sudo mdadm /dev/md0 --remove /dev/sdc
