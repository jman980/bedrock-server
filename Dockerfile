FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    unzip \
    libpocketmine-sqlite3 \
    && rm -rf /var/lib/apt/lists/*

# Set up working directory
WORKDIR /server

# Download the PocketMine installer and run it
RUN curl -sL https://pmmp.io | bash -s - -v stable

# Expose the default Minecraft Bedrock port
EXPOSE 19132/udp

# Start the server
CMD ["./start.sh", "--no-wizard"]
