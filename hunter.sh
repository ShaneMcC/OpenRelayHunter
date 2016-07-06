#!/bin/bash
# 
# Quick and dirty script to scan a selection of IP ranges for Open SMTP or DNS resolvers
# Prerequisite: 'prips' utility (aptitude install prips) 
# Prerequisite: 'mutt' utility (aptitude install mutt) 
# Author: Johnathan Williamson
# Props: Shane McCormack (prips, open dns resolver snippet) 
# 

touch /tmp/badservers.txt

# These are the IP Ranges we'll be hunting through (note this will work with public or private IP ranges.
IPADDR=("192.168.0.0/30")

# Iterate through each range and push the IP's into a new array
for i in "${IPADDR[@]}"
	do
	# Expand our ranges to list the full IP range

		#Check each IP for open relay status
		for line in `prips $i`
			do
			echo Checking $line
			if [ -z "$(nmap -pT:25 --script smtp-open-relay $line | grep "Server is an open relay")" ]; 
				then
					true	
				else 
					echo "$line is an open SMTP relay. Burn them with unholy bleach." >> /tmp/badservers.txt
			fi

			if [ "$(dig +time=1 +tries=1 +short google.com @$line | grep -v ';;')" != "" ];
				then echo "$line is an open DNS Resolver. Burn them with even unholier bleach." >> /tmp/badservers.txt
			else
				true
			fi
			
		done
done

# Did we catch anybody? If yes, email somebody to do something about them.
if [[ $(find /tmp/badservers.txt -type f -size +1c 2>/dev/null) ]]; then
	mail -r "From@youraddress.com" -s "List of Open DNS and SMTP Servers" "your@recipient.com" < /tmp/badservers.txt

fi

rm -rf /tmp/badservers.txt
