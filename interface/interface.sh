#!/bin/bash

function drives_list {
	disks=$(hwinfo --disk --short)
	disk_f=$(echo ${disks} | sudo sed -e 's/^/ /g' -e 's/ [^/][^ ]*//g' -e 's/^ *//g')
	echo $disk_f
}

function raid5 (){
	HEIGHT=15
	WIDTH=70
	CHOICE_HEIGHT=$#
	TITLE1="Please choose the disks that you want to use for the RAID5. Use the space bar to select them."

	i=0
	for word in $@; do 
		options+=(${word} "" "off")
	done


	while true; do
		CHOICE=$(dialog --clear \
				--checklist "$TITLE1" \
				$HEIGHT $WIDTH $CHOICE_HEIGHT \
				"${options[@]}" \
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
			./../RAID5/create_array.sh $(raid5 $(drives_list))
			./../NAS/setup_NAS.sh
			./../nextcloud/nextcloud.sh
			;;
		Create_RAID5)
			./../RAID5/create_array.sh $(raid5 $(drives_list))
			;;
		Add_disk)
			./../RAID5/add_drive.sh $(raid5 $(drives_list))
			;;
		Remove_disk)
			./../RAID5/remove_drive.sh $(raid5 $(drives_list))
			;;
		Create_NAS)
			./../NAS/setup_NAS.sh
			;;
		Install_Nextcloud)
			./../nextcloud/nextcloud.sh
			;;

esac


