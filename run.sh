#!/bin/bash

# === CONFIG ===
APPKEY="yEPIX6DX1ZnvLbPn"
FOLDER="$HOME/packetsdk_docker"
CONTAINER_NAME="packetsdk_container"
SDK_ZIP_URL="https://github.com/ukmseni/InternetIncomeXpacketSDK/raw/refs/heads/main/sdk.zip"

# === MULAI ===
echo "[+] Install Docker & Docker Compose..."
sudo apt update && sudo apt install -y docker.io docker-compose unzip curl

echo "[+] Buat folder kerja di $FOLDER"
mkdir -p "$FOLDER"
cd "$FOLDER"

echo "[+] Download SDK dari GitHub..."
wget -O sdk.zip "$SDK_ZIP_URL"

echo "[+] Buat Dockerfile..."
cat > Dockerfile <<EOF
FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y unzip curl && apt-get clean
WORKDIR /app
COPY sdk.zip /app/
RUN unzip sdk.zip && rm sdk.zip

# Deteksi arsitektur & link-kan binary sesuai folder
RUN ARCH=\$(uname -m) && \\
    case "\$ARCH" in \\
        x86_64) BIN_PATH="packet_sdk_linux-1.0.2/x86_64/packet_sdk" ;; \\
        aarch64) BIN_PATH="packet_sdk_linux-1.0.2/aarch64/packet_sdk" ;; \\
        armv7l) BIN_PATH="packet_sdk_linux-1.0.2/armv7l/packet_sdk" ;; \\
        i386) BIN_PATH="packet_sdk_linux-1.0.2/i386/packet_sdk" ;; \\
        *) echo "Unsupported arch: \$ARCH" && exit 1 ;; \\
    esac && \\
    chmod +x "\$BIN_PATH" && \\
    ln -s "/app/\$BIN_PATH" /usr/local/bin/packetsdk

ENV APPKEY=$APPKEY
CMD ["packetsdk", "-appkey=$APPKEY"]
EOF

echo "[+] Buat docker-compose.yml..."
cat > docker-compose.yml <<EOF
version: '3.8'
services:
  sdk:
    build: .
    container_name: $CONTAINER_NAME
    restart: always
EOF

echo "[+] Build & run container..."
docker-compose up -d

echo "[✓] DONE! PacketSDK sekarang jalan di container '$CONTAINER_NAME'"
echo "[i] Cek log jalan: docker logs -f $CONTAINER_NAME"
