#!/bin/bash
NAME=$1
IP=$2
WIKIPATH=/mnt/Synology/Obsidian/vimwiki/TCM-Sec
if [ -z "$NAME" ]; then
  echo "Error: NAME is empty"
  exit 1  # Exit with an error code (optional)
fi
if [ -z "$IP" ]; then
  echo "Error: IP is empty"
  exit 1  # Exit with an error code (optional)
fi
nmap -vvvv -sT -p- $IP --min-rate=10000 --open -oN /tmp/$NAME --stats-every 5s;
cp /usr/share/markdown.txt /tmp/$NAME.tcp;
cat /tmp/$NAME | awk -F '[[:space:]]+|/' '/^[0-9]/ {printf "| %-5s | %-8s | %-5s | [%s](%s.tcp.md) |\n", $1, $2, $3, $4, $1}' >> /tmp/$NAME.tcp
echo >> $WIKIPATH/$NAME/$NAME.md
cat /tmp/$NAME.tcp >> $WIKIPATH/$NAME/$NAME.md

nmap -vvvv -sU -p- $IP --max-retries=1 -T5 --min-rate=10000 --open -oN /tmp/$NAME --stats-every 5s;
cat /tmp/$NAME | awk -F '[[:space:]]+|/' '/^[0-9]/ {printf "| %-5s | %-8s | %-5s | [%s](%s.udp.md) |\n", $1, $2, $3, $4, $1}' | grep -v 'filtered' >> /tmp/$NAME.udp
cat /tmp/$NAME.udp >> $WIKIPATH/$NAME/$NAME.md
echo "" >> $WIKIPATH/$NAME/$NAME.md
