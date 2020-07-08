#!/bin/bash
# test for jenkins
if [[ $EUID -ne 0 ]]; then
   	echo "This script must be run as root" 
   	exit 1
else
    dialog_path=/usr/bin/dialog
    if test -f "$dialog_path"; then
        echo "dialog exists , go next"
    else
	sudo apt-get install dialog
    fi
	cmd=(dialog --separate-output --checklist "Please Select Software you want to install:" 22 76 16)
    options=(1 "upgrade system(may take long time)" off
             2 "install timeshift and take snapshot" off
             3 "change apt sources.list" off
             4 "stop apt daily update" off
             5 "reboot" off)
		choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
		clear
		for choice in $choices
		do
		    case $choice in
	        	1)
	            #system upgrade 
				echo "starting system upgrade"
				sudo apt update -y 
                sudo apt -o Dpkg::Options::=--force-confold -o Dpkg::Options::=--force-confdef -y --allow-downgrades --allow-remove-essential --allow-change-held-packages upgrade
				;;
			    2)
                # install timeshift and take snapshot
                echo "install timeshift and take snapshot"
                sudo apt install timeshift -y
                sudo timeshift --create --comment "first snapshot after bootstrap"
				;;
                3)
                wget http://192.168.1.7/sources.list -O /etc/apt/sources.list
                sudo apt update
                ;;
                4)
                ## stop apt auto update
                sudo systemctl stop apt-daily.service
                sudo systemctl stop apt-daily.timer
                sudo systemctl stop apt-daily-upgrade.timer
                ;;
                5)
                echo "Reboot now"
                sudo reboot now
                ;;
	    esac
	done
fi

