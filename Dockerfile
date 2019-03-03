FROM alpine:latest

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

# Download and extract Asterisk sources
RUN set -xe; \
    wget -O asterisk.tar.gz http://downloads.asterisk.org/pub/telephony/asterisk/releases/asterisk-$ASTERISK_VERSION.tar.gz \
    && tar xfz asterisk.tar.gz \
    && rm asterisk.tar.gz \
    && mv asterisk-* asterisk

# Download and extract native patch sources
RUN set -xe; \
    wget -O patch.tar.gz ftp://ftp.gnu.org/gnu/patch/patch-$PATCH_VERSION.tar.gz \
    && tar xfz patch.tar.gz \
    && rm patch.tar.gz \
    && mv patch-* patch

# Install ODBC
RUN set -xe \
    && apk add --no-cache --virtual .odbc-deps \
       psqlodbc \
       unixodbc-dev \
       mariadb-connector-c

# Musl patch. According to https://paulgorman.org/technical/asterisk-alpine-lxc.txt
COPY ["patches/*.patch","./asterisk/"]

RUN cd asterisk; for PATCH_FILE in $(ls *.patch); do patch -p1 < $PATCH_FILE; done

# Install compiler librarites and native patch command
RUN set -xe \
    && apk add --no-cache --virtual .build-deps \
        build-base sqlite sqlite-dev sqlite-libs bsd-compat-headers \
#       autoconf \
#       build-base \
#       musl-dev \
#       file \
#       bsd-compat-headers \
#       flex \
#       g++ \
#       gcc \
#       libc-dev \
#       make \
#       cmake \
#       pkgconf \
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
       libical-dev \
    && cd patch && ./configure --prefix=/usr && make && make install \
    && cd ../asterisk && rm -Rf /usr/src/patch && make clean && make distclean && ./contrib/scripts/get_mp3_source.sh && ./configure --with-pjproject-bundled \
    && make menuselect.makeopts && for SELECTED_MODULE in $ASTERISK_MODULES; do menuselect/menuselect --enable $SELECTED_MODULE menuselect.makeopts; done; \
    make && make install && make samples

ENTRYPOINT ["/usr/sbin/asterisk","-cvvvddd"]