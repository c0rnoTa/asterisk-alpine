FROM alpine:latest

WORKDIR /root/

COPY patches ./src

ADD src/*.tar.gz ./

RUN apk update \
  && apk add libtool libuuid jansson libxml2 sqlite-libs readline libcurl libressl zlib libsrtp lua5.1-libs spandsp \
  && apk add --virtual .build-deps build-base patch bsd-compat-headers util-linux-dev ncurses-dev libresample \
        jansson-dev libxml2-dev sqlite-dev readline-dev curl-dev libressl-dev \
        zlib-dev libsrtp-dev lua-dev spandsp-dev

RUN mv asterisk-* asterisk \
  && cd asterisk/ \
  # https://git.alpinelinux.org/aports/plain/main/asterisk/APKBUILD
  && sed -i -e 's/ASTSSL_LIBS:=$(OPENSSL_LIB)/ASTSSL_LIBS:=-Wl,--no-as-needed $(OPENSSL_LIB) -Wl,--as-needed/g' main/Makefile \
  # Musl patches according to
  # https://paulgorman.org/technical/asterisk-alpine-lxc.txt
  # https://git.alpinelinux.org/aports/plain/main/asterisk/APKBUILD
  && patch -p1 < ../src/musl-mutex-init.patch \
  && patch -p1 < ../src/musl-glob-compat.patch \
  && cp ../src/9000-libressl.patch third-party/pjproject/patches/

RUN cd asterisk/ \
  && ./configure --with-pjproject-bundled \
  && make menuselect.makeopts \
  && ./menuselect/menuselect \
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
  && make install \
  && cd .. \
  && apk del .build-deps \
  && rm -rf ./asterisk* \
  && rm -rf src \
  && rm -rf /var/cache/apk/*
