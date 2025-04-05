#!/bin/bash

# === CONFIG ===
APPKEY="ISI_APPKEY_MU"
FOLDER="$HOME/packetsdk_docker"
CONTAINER_NAME="packetsdk_container"
SDK_ZIP_URL="https://github.com/gunturyogatama404/testAJA/raw/refs/heads/main/packet_sdk_linux-1.0.2.zip"

# === START ===
echo "[+] Install Docker & dependencies..."
sudo apt update && sudo apt install -y docker.io docker-compose unzip curl

echo "[+] Setup folder kerja di $FOLDER"
mkdir -p "$FOLDER"
cd "$FOLDER"

echo "[+] Download SDK ZIP..."
wget -O sdk.zip "$SDK_ZIP_URL"

echo "[+] Clone repo & build Docker container..."
git clone REPO_KAMU .
sed -i "s/YOUR_APPKEY_HERE/$APPKEY/g" Dockerfile

docker-compose up -d

echo "[✓] Done! PacketSDK berjalan sebagai container: $CONTAINER_NAME"
