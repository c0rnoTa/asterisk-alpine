FROM alpine:latest

MAINTAINER Anton Zakharov hello@antonzakharov.ru

WORKDIR /usr/src

# Copy sources to /usr/src/asterisk directory
ADD src/*.tar.gz ./
RUN mv asterisk-* asterisk

COPY patches/musl-glob-compat.patch asterisk/
COPY patches/musl-mutex-init.patch asterisk/

# Install compile deps
RUN apk update \
    && apk add --virtual .build-deps \
     # Apply patches
     patch \
     # Core compile dependencies
     build-base ncurses-dev util-linux-dev jansson-dev libxml2-dev sqlite-dev bsd-compat-headers

WORKDIR asterisk

RUN patch -p1 < ./musl-glob-compat.patch
RUN patch -p1 < ./musl-mutex-init.patch

RUN ./configure && make && make install

COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]