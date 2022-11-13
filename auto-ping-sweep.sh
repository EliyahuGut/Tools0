#!/bin/bash
readarray -t ip < <(ifconfig | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}')
readarray -t ipfix < <(echo ${ip[@]} | cut -d '.' -f 1,2,3)
for i in {1..254};do
	ping -c 1 ${ipfix[@]}.$i | grep "bytes from" | cut -d ' ' -f4 | tr -d ':' &
done
sleep 2

