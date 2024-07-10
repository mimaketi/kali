#!/bin/sh
sudo apt install fzf
sudo mv ./ffuf /usr/bin/ffuf
sudo wget https://raw.githubusercontent.com/carlospolop/Auto_Wordlists/main/wordlists/bf_directories.txt -o /usr/share/wordlists/dirb/bf_dict.txt
