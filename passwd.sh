#!/bin/bash
#
# How to encrypt and decrypt file: http://how-to.linuxcareer.com/using-openssl-to-encrypt-messages-and-files
# Copy password to clipboard
#  

private_key="$HOME/.ssh/private_key.pem"
passwd_file="$HOME/passwd.dat"

i=0
while read line           
do
	if [ ! -z "$line" ]; then
		data[$i]=$line
		echo -e "$i\t$line"
		i=$((i+1))
	fi
done < <(openssl rsautl -decrypt -inkey "$private_key" -in "$passwd_file")

echo  -n "Please enter a number: "
read number
[[ ! $number =~ ^[0-9]+$ || -z ${data[number]} ]] && \
	echo "ERROR: Please select correct number" && \
	exit
IFS=':' read -a name <<< "${data[$number]}"
echo -n ${name[1]} | xclip -selection clipboard
echo "You selected \"${name[0]}\""
