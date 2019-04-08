FROM alpine:latest

MAINTAINER Anton Zakharov hello@antonzakharov.ru

ENV ASTERISK_SOURCE http://downloads.asterisk.org/pub/telephony/asterisk/releases/asterisk-13.21.1.tar.gz
ENV ASTERISK_MODULES_ENABLE format_mp3 chan_sip pbx_ael cdr_odbc
ENV ASTERISK_MODULES_DISABLE BUILD_NATIVE
ENV ASTERISK_CATEGORY_DISABLE MENUSELECT_CORE_SOUNDS MENUSELECT_MOH MENUSELECT_EXTRA_SOUNDS

WORKDIR /usr/src

COPY patches/* patches/
COPY lib/ /usr/lib/
COPY etc/odbc* /etc/

# Install compile deps and install Asterisk
RUN set -ex; apk update \
    && apk add --no-cache --virtual .runtime-deps \
      # ncurses-dev
      ncurses-terminfo-base ncurses-terminfo ncurses-libs \
      # util-linux-dev
      libuuid libblkid libfdisk libmount libsmartcols \
      # jansson-dev
      jansson \
      # libxml2-dev
      libxml2 \
      # sqlite-dev
      sqlite-libs \
      # ODBC
      libressl readline unixodbc \
    && apk add --no-cache --virtual .build-deps \
      # Apply patches
      wget patch \
      # Core compile dependencies
      build-base ncurses-dev util-linux-dev jansson-dev libxml2-dev sqlite-dev bsd-compat-headers \
      # ODBC dependencies
      libressl-dev unixodbc-dev \
    && wget -O asterisk.tar.gz $ASTERISK_SOURCE; tar vxfz asterisk.tar.gz; rm asterisk.tar.gz \
    && mv asterisk-* asterisk \
    && cp patches/musl-glob-compat.patch patches/musl-mutex-init.patch asterisk/; cp patches/asterisk-addon-mp3-r201.patch asterisk/addons/ \
    && cd asterisk; patch -p1 < ./musl-glob-compat.patch && patch -p1 < ./musl-mutex-init.patch && cd addons; patch -p1 < ./asterisk-addon-mp3-r201.patch && cd .. \
    && ./configure && make menuselect.makeopts \
    && menuselect/menuselect \
           # Enable modules
           $(for MODULE in $ASTERISK_MODULES_ENABLE; do echo --enable $MODULE; done;) \
           # Disable modules
           $(for MODULE in $ASTERISK_MODULES_DISABLE; do echo --disable $MODULE; done;) \
           # Disable categories
           $(for CATEGORY in $ASTERISK_CATEGORY_DISABLE; do echo --disable-category $CATEGORY; done;) menuselect.makeopts \
    && make -j "$(nproc)" && make install && make basic-pbx \
    # Cleanup build files
    && cd ..; rm -Rf asterisk \
    && apk del .build-deps

COPY /etc/asterisk/basic-pbx/ /etc/asterisk/

EXPOSE 5060/udp

COPY docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]