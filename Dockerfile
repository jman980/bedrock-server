FROM ubuntu:22.04

# Install basic system utilities
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    unzip \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install ngrok using the official script method to prevent GPG errors
RUN curl -s https://amazonaws.com | tee /etc/apt/trusted.gpg.md/ngrok.asc >/dev/null \
    && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | tee /etc/apt/sources.list.d/ngrok.list \
    && apt-get update && apt-get install -y ngrok

WORKDIR /server

# Download the final stable PocketMine-MP phar directly from GitHub
RUN wget https://github.com

# Download the pre-compiled Linux PHP binary required to run it
RUN wget https://github.com \
    && tar -xvf PHP-Linux-x86_64-PM5.tar.gz \
    && rm PHP-Linux-x86_64-PM5.tar.gz

# Pre-accept the Minecraft EULA and disable the setup wizard
RUN echo "eula=true" > eula.txt \
    && echo "skip-wizard=1" > pocketmine.yml

EXPOSE 19132/udp

# Custom startup script to start ngrok AND the server at the same time
RUN echo '#!/bin/bash\n\
if [ -n "$NGROK_AUTHTOKEN" ]; then\n\
  ngrok config add-authtoken "$NGROK_AUTHTOKEN"\n\
  ngrok tcp 19132 --log=stdout &\n\
fi\n\
./bin/php PocketMine-MP.phar --no-wizard\n\
' > start_all.sh && chmod +x start_all.sh

CMD ["./start_all.sh"]