FROM alpine:latest

MAINTAINER Anton Zakharov hello@antonzakharov.ru

ENV ASTERISK_VERSION 13.20.0
ENV PATCH_VERSION 2.7.6
ENV ASTERISK_MODULES chan_oss \
                     chan_sip \
                     chan_ooh323 \
                     format_mp3 \
                     cdr_adaptive_odbc \
                     pbx_realtime \
                     pbx_ael \
                     res_fax_spandsp \
                     res_http_websocket \
                     res_config_odbc \
                     res_crypto \
                     res_srtp \
                     CORE-SOUNDS-RU-WAV \
                     CORE-SOUNDS-RU-ULAW \
                     CORE-SOUNDS-RU-ALAW \
                     CORE-SOUNDS-RU-GSM \
                     CORE-SOUNDS-RU-G729 \
                     CORE-SOUNDS-RU-G722 \
                     CORE-SOUNDS-RU-SLN16 \
                     CORE-SOUNDS-RU-SIREN7 \
                     CORE-SOUNDS-RU-SIREN14

WORKDIR /usr/src

ADD src/asterisk*.tar.gz ./
# Download and extract Asterisk sources
RUN set -xe \
#    wget -O asterisk.tar.gz http://downloads.asterisk.org/pub/telephony/asterisk/releases/asterisk-$ASTERISK_VERSION.tar.gz \
#    && tar xfz asterisk.tar.gz \
#    && rm asterisk.tar.gz \
    && mv asterisk-* asterisk

# Install ODBC
#RUN set -xe \
#    && apk add --no-cache --virtual .odbc-deps \
#       psqlodbc \
#       unixodbc-dev \
#       mariadb-connector-c

# Musl patches according to
# https://paulgorman.org/technical/asterisk-alpine-lxc.txt
# https://git.alpinelinux.org/aports/plain/main/asterisk/APKBUILD
COPY ["patches/musl*.patch","./asterisk/"]

RUN cd asterisk; for PATCH_FILE in $(ls *.patch); do patch -p1 < $PATCH_FILE; done

# Install compiler librarites and native patch command
RUN set -xe \
    && apk add --no-cache --virtual .build-deps \
        build-base sqlite sqlite-dev sqlite-libs bsd-compat-headers \
       subversion \
       ncurses-dev \
       util-linux-dev \
       jansson-dev \
       libxml2-dev \
       sqlite-dev \
       alsa-lib-dev \
       spandsp-dev \
       tiff-dev \
       openssl-dev \
       curl-dev \
       neon-dev \
       gmime-dev \
       net-snmp-dev \
       gnutls-dev \
       libsrtp-dev \
       libical-dev

RUN set -xe; \
    ./usr/src/patch/configure --prefix=/usr && make && make install \
    && cd ../asterisk \
    && rm -Rf /usr/src/patch && make clean && make distclean && ./contrib/scripts/get_mp3_source.sh \
    # https://git.alpinelinux.org/aports/plain/main/asterisk/APKBUILD
    && sed -i -e 's/ASTSSL_LIBS:=$(OPENSSL_LIB)/ASTSSL_LIBS:=-Wl,--no-as-needed $(OPENSSL_LIB) -Wl,--as-needed/g' main/Makefile \
    && ./configure --with-pjproject-bundled && make menuselect.makeopts \
    # Enable selected modules
    && menuselect/menuselect $(for SELECTED_MODULE in $ASTERISK_MODULES; do echo --enable $SELECTED_MODULE; done;) menuselect.makeopts \
    # Disable modules
    && menuselect/menuselect \
        --disable BUILD_NATIVE \
        --disable-category MENUSELECT_CORE_SOUNDS \
        --disable-category MENUSELECT_MOH \
        --disable-category MENUSELECT_EXTRA_SOUNDS \
        menuselect.makeopts \
    && make -j$(getconf _NPROCESSORS_ONLN) ASTCFLAGS="-Os -fomit-frame-pointer" ASTLDFLAGS="-Wl,--as-needed" \
    && scanelf --recursive --nobanner --osabi --etype "ET_DYN,ET_EXEC" . \
        | while read type osabi filename ; do \
          [ "$osabi" != "STANDALONE" ] || continue ; \
          strip "${filename}" ; \
    done \
    && make install && make samples

ADD docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 5060/udp

ENTRYPOINT ["/docker-entrypoint.sh"]

#CMD ["/usr/sbin/asterisk", "-vvvdddfn", "-T", "-U", "root", "-p"]