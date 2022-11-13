#!/bin/bash

if [ -z $1 ]; then 
	echo "This script is build to transfer a zone-file against a given domain
[Usage] $0 [domain.com]"
fi
if [[ $1 =~ [a-z0-9]+\.[a-z]+ ]]; then
	echo "                                  _    __  _______ ____    $1
                                 / \   \ \/ /  ___|  _ \   $1
                                / _ \   \  /| |_  | |_) |  $1
                               / ___ \  /  \|  _| |  _ <   $1
                              /_/   \_\/_/\_\_|   |_| \_\  $1
				                          "
fi			      
readarray -t Filename < <(echo $1 | cut -d '.' -f1)
readarray -t ns < <(host -t ns $1 | cut -d ' ' -f4)
for i in ${ns[@]}; do
	date
	host -t axfr $1 $i | tee -a ${Filename[@]}-axfr.txt ;	
done
echo "The data is stored a file called:
${Filename[@]}-axfr.txt"
echo
echo "Be aware every time you will run the script with the same domain,
the data will be appended on the old data..
but its ok the script places time and date OnTop every axfr scan :]"
