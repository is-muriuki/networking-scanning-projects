#!/bin/bash
# Quick SYN scan of top 1000 ports 
echo "[+] Scanning $1"
sudo nmap -sS -T4 --top-ports 1000 $1
