FROM ubuntu:22.04

LABEL author="Gemini" maintainer="your-email@example.com"

ENV DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        gnupg2 \
        software-properties-common \
        wget \
        xauth \
        xvfb \
        python3 \
        python3-pip \
    && mkdir -pm755 /etc/apt/keyrings \
    && wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key \
    && wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get update \
    && apt-get install -y --install-recommends \
        iproute2 \
        libasound2 \
        libgbm-dev \
        libgconf-2-4 \
        libnss3 \
        libx11-xcb1 \
        libxshmfence1 \
        libxtst6 \
        locales \
        nodejs \
        tzdata \
        winehq-stable \
        libgl1-mesa-dri \
        libgl1-mesa-glx \
        libegl1-mesa \
        mesa-utils \
        
    && npm install -g npm@latest \
    && npx playwright install-deps chromium firefox \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -d /home/container container

ENV USER=container \
    HOME=/home/container \
    NPM_CONFIG_PREFIX=/home/container/.npm-global \
    PYTHONUSERBASE=/home/container/.pip-global \
    DISPLAY=:99 \
    WINEDEBUG=-all \
    WINEPREFIX=/home/container/.wine
ENV PATH="/home/container/.npm-global/bin:/home/container/.pip-global/bin:${PATH}"

USER container
WORKDIR /home/container

RUN mkdir -p /home/container/.npm-global /home/container/.pip-global

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]

