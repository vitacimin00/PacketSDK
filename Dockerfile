# Dockerfile for running PacketSDK binary (no Android SDK needed)
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    unzip \
    curl \
    wget && \
    apt-get clean

# Create working directory
WORKDIR /app

# Copy PacketSDK zip file from build context
COPY sdk.zip /app/

# Extract and set up PacketSDK binary based on architecture
RUN unzip sdk.zip && rm sdk.zip && \
    ARCH=$(uname -m) && \
    case "$ARCH" in \
        x86_64) BIN_PATH="packet_sdk_linux-1.0.2/x86_64/packet_sdk" ;; \
        aarch64) BIN_PATH="packet_sdk_linux-1.0.2/aarch64/packet_sdk" ;; \
        armv7l) BIN_PATH="packet_sdk_linux-1.0.2/armv7l/packet_sdk" ;; \
        i386) BIN_PATH="packet_sdk_linux-1.0.2/i386/packet_sdk" ;; \
        *) echo "Unsupported architecture: $ARCH" && exit 1 ;; \
    esac && \
    chmod +x "$BIN_PATH" && \
    ln -s "/app/$BIN_PATH" /usr/local/bin/packetsdk

# Environment variable for your APPKEY
ENV APPKEY=YOUR_APPKEY_HERE

# Run the binary with appkey
CMD ["packetsdk", "-appkey=YOUR_APPKEY_HERE"]

# === Additional Files ===
# build.sh - untuk build & run docker container
# docker-compose.yml - untuk manajemen container otomatis
