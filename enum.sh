#!/bin/sh
NAME=$1
IP=$2
WIKIPATH=/mnt/Synology/Obsidian/vimwiki/TCM-Sec
FP=$WIKIPATH/$NAME/80.tcp.md
if [ -z "$NAME" ]; then
  echo "Error: NAME is empty"
  exit 1  # Exit with an error code (optional)
fi
if [ -z "$IP" ]; then
  echo "Error: IP is empty"
  exit 1  # Exit with an error code (optional)
fi
if [ ! -d "$WIKIPATH/$NAME" ]; then
  echo "PATH DOES NOT EXIST: $WIKIPATH/$NAME"
  exit 1
fi
echo "## Whatweb\n" | tee -a $FP
whatweb -a 3 http://$IP | tee -a $FP
echo "\n\n## ffuf\n" | tee -a $FP
ffuf -mc 200-399 -recursion -recursion-depth 2 -recursion-strategy greedy -c -w /usr/share/wordlists/dirb/big.txt -u http://$IP/FUZZ | sed '/^true$/d' | tee -a $FP
echo "\n\n## ffuf error pages\n" | tee -a $FP
ffuf -mc 401,403,405,500 -w /usr/share/wordlists/dirb/big.txt -u http://$IP/FUZZ | sed '/^true$/d' | tee -a $FP
echo "\n\n## gospider\n" | tee -a $FP
gospider -s http://$IP | tee -a $FP
echo "\n\n## vhost search\n" | tee -a $FP
gobuster vhost -q -u http://$IP -w /usr/share/wordlists/dirb/big.txt | tee -a $FP
echo "Gobuster running in background..."
echo "\n\n## nikto\n" |tee -a $FP
nikto -host http://$IP | tee -a $FP
