#!/bin/bash

touch /tmp/ips.txt
touch /tmp/badservers.txt

# These are the IP Ranges we'll be hunting through (note this will work with public or private IP ranges.
IPADDR=("192.168.0.0/24")

# Iterate through each range and push the IP's into a new array
for i in "${IPADDR[@]}"
	do
	# Expand our ranges to list the full IP range
	nmap -sL $i | grep "Nmap scan report" | tr -d '(' | tr -d ')' | awk '{print $NF}' > /tmp/ips.txt
		#Check each IP for open relay status
		for line in $(cat /tmp/ips.txt)
			do
			if [ -z "$(nmap --script smtp-open-relay $line | grep "Server is an open relay")" ]; 
				then
					true	
				else 
					echo "$line is an open relay. Burn them with unholy bleach." >> /tmp/badservers.txt
			fi
		done
done

# Did we catch anybody? If yes, email somebody to do something about them.
if [[ $(find /tmp/badservers.txt -type f -size +1c 2>/dev/null) ]]; then
	cat /tmp/badservers.txt
fi

rm -rf /tmp/ips.txt
rm -rf /tmp/badservers.txt
