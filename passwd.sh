#!/bin/bash
#
## file:        passwd.sh
## description: Copy password to clipboard. How to encrypt and decrypt file: http://how-to.linuxcareer.com/using-openssl-to-encrypt-messages-and-files
## author:      Borysenko Roman
## date:        Mon Jul  7 10:28:04 SGT 2014
## version:     0.0.1
#

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

set -e

private_key="$HOME/.ssh/private_key.pem"
passwd_file="$HOME/passwd.dat"

res=$(openssl rsautl -decrypt -inkey "$private_key" -in "$passwd_file") \
  || exit 1

i=0
while read line
do
  if [ ! -z "$line" ]; then
    data[$i]=$line
    echo -e "$i\t$line"
    i=$((i+1))
  fi
done <<<"$res"

echo  -n "Please enter a number: "
read number
[[ ! $number =~ ^[0-9]+$ || -z ${data[number]} ]] && \
  echo "ERROR: Please select correct number" && \
  exit
IFS=':' read -a name <<< "${data[$number]}"
echo -n ${name[1]} | xclip -selection clipboard
echo -e "You selected \"${name[0]}\".\nYou can paste your selection now."; sleep 3; reset