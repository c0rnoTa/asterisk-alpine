FROM alpine:latest

MAINTAINER Anton Zakharov hello@antonzakharov.ru

ENV ASTERISK_MODULES_ENABLE format_mp3 chan_sip pbx_ael cdr_odbc
ENV ASTERISK_MODULES_DISABLE BUILD_NATIVE
ENV ASTERISK_CATEGORY_DISABLE MENUSELECT_CORE_SOUNDS MENUSELECT_MOH MENUSELECT_EXTRA_SOUNDS

WORKDIR /usr/src

# Copy sources to /usr/src/asterisk directory
ADD src/*.tar.gz ./
RUN mv asterisk-* asterisk

COPY patches/musl-glob-compat.patch patches/musl-mutex-init.patch asterisk/
COPY patches/asterisk-addon-mp3-r201.patch asterisk/addons/

# Install compile deps
RUN apk update \
    && apk add --virtual .build-deps \
     # Apply patches
     patch \
     # Core compile dependencies
     build-base ncurses-dev util-linux-dev jansson-dev libxml2-dev sqlite-dev bsd-compat-headers \
     # ODBC compile dependencies
     # git cmake
     libressl-dev unixodbc-dev

# Install ODBC
#RUN git clone https://github.com/MariaDB/mariadb-connector-odbc.git \
#    && cd mariadb-connector-odbc && git checkout v3.0.8-release \
#    && cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCONC_WITH_UNIT_TESTS=Off -DCONC_WITH_MSI=OFF -DCMAKE_INSTALL_PREFIX=/usr/ . \
#    && cmake --build . --config RelWithDebInfo \
#    && make install

COPY lib/ /usr/lib/

WORKDIR asterisk

# Apply patches
RUN patch -p1 < ./musl-glob-compat.patch && patch -p1 < ./musl-mutex-init.patch
RUN cd addons; patch -p1 < ./asterisk-addon-mp3-r201.patch

# Configure installer
RUN ./configure && make menuselect.makeopts

# Select and deselect modules
RUN set -ex; menuselect/menuselect \
    # Enable modules
    $(for MODULE in $ASTERISK_MODULES_ENABLE; do echo --enable $MODULE; done;) \
    # Disable modules
    $(for MODULE in $ASTERISK_MODULES_DISABLE; do echo --disable $MODULE; done;) \
    # Disable categories
    $(for CATEGORY in $ASTERISK_CATEGORY_DISABLE; do echo --disable-category $CATEGORY; done;) menuselect.makeopts \
    && make -j "$(nproc)" && make install

#EXPOSE 5060/udp 10000-20000/udp

COPY etc/odbc* /etc/

COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]