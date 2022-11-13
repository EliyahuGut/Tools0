#!/bin/bash

if [ -z $1 ]; then
	echo "This script is made for 
	Active every-day IP & Port 
		scanning of a given network.
			Example: 192.168.80.0/24"
			exit 0
fi

networkid=$(echo $1 | cut -d '/' -f1)
folder=$"$HOME/nmap-scans/$networkid"
date=$(date +%d-%m-%Y)
yesterday=$(date --date="yesterday" +%d-%m-%Y)

[[ -d $folder ]] || mkdir -p $folder

nmap -n -sT -p 1-1024 $1 --max-retries 3 -oX $folder/$date.xml 

xsltproc $folder/$date.xml -o $folder/$date.html

# Checking if the user has ndiff installed
test -f /usr/bin/ndiff
if [ $? -ne 0 ]; then
	read -p "you do not have ndiff in your device,
       	to compare between two scans,
		you need to install it.. 
			do you want to install it?: (Y/N)" ans
	if [[ $ans = yes ]] || [[ $ans = Y ]] || [[ $ans = y ]]; then
		sudo apt install ndiff -y
	fi
fi
if [ -f $folder/$yesterday.xml ]; then
	ndiff $folder/$yesterday.xml $folder/$date.xml | tee $folder/$networkid.txt
fi
echo
echo "this is the name of todays scan with the path:
$folder/$date.html

you can open it with firefox like:
firefox $date.html"
echo
exit 0
