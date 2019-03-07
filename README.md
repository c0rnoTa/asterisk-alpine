# Usage
```bash
# Clone the repository
git clone https://github.com/c0rnoTa/asterisk-alpine
# Download asterisk sources to `src` direcotry
cd asterisk-alpine/src
wget https://downloads.asterisk.org/pub/telephony/certified-asterisk/asterisk-certified-13.21-cert3.tar.gz
# Run the composer
cd ..
docker-compose up
```

# Notes

build-base
---
1. Installing binutils
2. Installing libmagic
3. Installing file
4. Installing gmp
5. Installing isl
6. Installing libgomp
7. Installing libatomic
8. Installing libgcc
9. Installing mpfr3
10. Installing mpc1
11. Installing libstdc++
12. Installing gcc
13. Installing musl-dev
14. Installing libc-dev
15. Installing g++
16. Installing make
17. Installing fortify-headers

odbc deps
---
1. unixodbc-dev - UnixODBC package
   1. Installing readline
   2. Installing unixodbc
   3. Installing unixodbc-dev
  
2. psqlodbc - PostgreSQL ODBC connector
   1. Installing db
   2. Installing libsasl
   3. Installing libldap
   4. Installing libpq
   5. Installing psqlodbc
   
3. mariadb-connector-c - MySQL ODBC connector (MariaDB originally)


asterisk deps
---
* ncurses-dev - termcap support
   1. Installing ncurses-terminfo-base
   2. Installing ncurses-terminfo
   3. Installing ncurses-libs
   4. Installing pkgconf
   5. Installing ncurses-dev

* util-linux-dev - uuid support
   1. Installing libuuid
   2. Installing libblkid
   3. Installing libfdisk
   4. Installing libmount
   5. Installing libsmartcols
   6. Installing util-linux-dev

* jansson-dev - JSON support
   1. Installing jansson
   2. Installing jansson-dev

* libxml2-dev - The Asterisk menuselect tool
   1. Installing zlib-dev
   2. Installing libxml2
   3. Installing libxml2-dev

* sqlite-dev - Asterisk now uses SQLite3 
   1. Installing sqlite-libs
   2. Installing sqlite-dev
 
* bsd-compat-headers - sys/cdefs.h: No such file or directory

patches
---
Installs `patch` to apply musl and third-party patches.\ 
https://paulgorman.org/technical/asterisk-alpine-lxc.txt \
https://issues.asterisk.org/jira/browse/ASTERISK-24154

Musl patches are:
* musl-glob-compat.patch - Fix ael.flex: error: 'GLOB_NOMAGIC' undeclared | ael.flex: error: 'GLOB_BRACE' undeclared
* musl-mutex-init.patch - PTHREAD_MUTEX_INITIALIZER should not be assumed to be recursive mutex

Third-party patches are:
* asterisk-addon-mp3-r201.patch - MP3 Decoder