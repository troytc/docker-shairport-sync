FROM alpine:edge
MAINTAINER kevineye@gmail.com

RUN apk -U add \
        git \
        build-base \
        autoconf \
        automake \
        libtool \
        alsa-lib-dev \
        libdaemon-dev \
        popt-dev \
        pulseaudio-dev \
        libressl-dev \
        soxr-dev \
        avahi-dev \
        libconfig-dev \
        mosquitto-dev \

 && cd /root \
 && git clone https://github.com/mikebrady/shairport-sync.git -b unstable \
 && cd shairport-sync \

 && autoreconf -i -f \
 && ./configure \
        --with-alsa \
        --with-pipe \
        --with-pa \
        --with-avahi \
        --with-ssl=openssl \
        --with-soxr \
        --with-metadata \
        --with-mqtt-client \
 && make \
 && make install \

 && cd / \
 && apk --purge del \
        git \
        build-base \
        autoconf \
        automake \
        libtool \
        alsa-lib-dev \
        libdaemon-dev \
        popt-dev \
        libressl-dev \
        pulseaudio-dev \
        soxr-dev \
        avahi-dev \
        libconfig-dev \
        mosquitto-dev \
 && apk add \
        dbus \
        alsa-lib \
        libdaemon \
        popt \
        libressl \
        pulseaudio \
        soxr \
        avahi \
        libconfig \
        mosquitto \
 && rm -rf \
        /etc/ssl \
        /var/cache/apk/* \
        /lib/apk/db/* \
        /root/shairport-sync

COPY start.sh /start

ENV AIRPLAY_NAME Docker

ENTRYPOINT [ "/start" ]
