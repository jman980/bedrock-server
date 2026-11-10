FROM ubuntu:22.04

# Install basic system utilities
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    unzip \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Set up working directory
WORKDIR /server

# Download the official PocketMine-MP installer and run it
# This script automatically downloads the correct PHP binary and server files
RUN curl -sL https://pmmp.io | bash -s - -v stable

# Expose the default Minecraft Bedrock port
EXPOSE 19132/udp

# Start the server using PocketMine's built-in startup script
CMD ["./start.sh", "--no-wizard"]
