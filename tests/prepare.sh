#!/bin/bash

echo "[*] Retrieving internal IP..."
export INTERNAL_IP=$(ip -o -4 addr show dev `ls /sys/class/net | grep -E "^eth|^en" | head -n 1` | cut -d' ' -f7 | cut -d'/' -f1)

echo "[*] Starting Rancher..."
docker run -d --restart=unless-stopped -p 8080:8080 rancher/server:stable
