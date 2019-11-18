#!/bin/bash

function drives_list {
	disks=$(hwinfo --disk --short)
	disk_f=$(echo ${disks} | sudo sed -e 's/^/ /g' -e 's/ [^/][^ ]*//g' -e 's/^ *//g')
	return $disk_f
}

function raid5 (){
	HEIGHT=15
	WIDTH=70
	CHOICE_HEIGHT=$#
	TITLE1="Please choose the disks that you want to use for the RAID5. Use the space bar to select them."

	i=0
	for word in $@; do 
		OPTIONS+=(${word} "" "off")
	done


	while true; do
		CHOICE=$(dialog --clear \
				--checklist "$TITLE1" \
				$HEIGHT $WIDTH $CHOICE_HEIGHT \
				"${OPTIONS[@]}" \
				2>&1 >/dev/tty)

		if [ $? == 1 ]; then
			return 0
		fi

		TITLE2="You have chosen \"$CHOICE\". Is this correct?"

		dialog --clear --yesno --stdout "$TITLE2" $HEIGHT $WIDTH

		if [ $? == 0 ]; then
			echo $CHOICE
			return 1
		fi

	done
}


CHOICE1=$(raid5 disk1 disk2 disk3)
echo $CHOICE1
exit

sudo apt-get install dialog -y


HEIGHT=15
WIDTH=70
CHOICE_HEIGHT=6
TITLE="Action Selection"
MENU="Choose one of the following options:"

OPTIONS=(Full_Installation "Installs RAID5 -> NAS -> NextCloud"
		 Create_RAID5 "Creates a disk array"
		 Add_disk "Adds a disk to the array"
		 Remove_disk "Removes a disk from the array"
		 Create_NAS "Makes array available to the network"
		 Install_Nextcloud "Installs NextCloud")


CHOICE=$(dialog --clear \
				--title "$TITLE" \
				--menu "$MENU" \
				$HEIGHT $WIDTH $CHOICE_HEIGHT \
				"${OPTIONS[@]}" \
				2>&1 >/dev/tty)

case $CHOICE in
		Full_Installation)
			echo "You chose Option 1"
			;;
		Create_RAID5)
			echo "You chose Option 2"
			;;
		Add_disk)
			echo "You chose Option 3"
			;;
		Remove_disk)
			echo "You chose Option 3"
			;;
		NAS)
			echo "You chose Option 3"
			;;
		Install_Nextcloud)
			echo "You chose Option 3"
			;;

esac


