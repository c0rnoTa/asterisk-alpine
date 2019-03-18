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

unixodbc-dev
(1/7) Installing pkgconf (1.6.0-r0)
(2/7) Installing ncurses-terminfo-base (6.1_p20190105-r0)
(3/7) Installing ncurses-terminfo (6.1_p20190105-r0)
(4/7) Installing ncurses-libs (6.1_p20190105-r0)
(5/7) Installing readline (7.0.003-r1)
(6/7) Installing unixodbc (2.3.7-r0)
(7/7) Installing unixodbc-dev (2.3.7-r0)

  
2. psqlodbc - PostgreSQL ODBC connector
   1. Installing db
   2. Installing libsasl
   3. Installing libldap
   4. Installing libpq
   5. Installing psqlodbc
   
3. git - Build MariaDB dependencies
   1. Installing ca-certificates (20190108-r0)
   1. Installing nghttp2-libs (1.35.1-r0)
   1. Installing libssh2 (1.8.0-r4)
   1. Installing libcurl (7.64.0-r1)
   1. Installing expat (2.2.6-r0)
   1. Installing pcre2 (10.32-r1)
   1. Installing git (2.20.1-r0)

4. cmake - Compile ODBC
   1. (1/19) Installing libattr (2.4.47-r7)
   1. (2/19) Installing libacl (2.2.52-r5)
   1. (3/19) Installing libbz2 (1.0.6-r6)
   1. (4/19) Installing expat (2.2.6-r0)
   1. (5/19) Installing lz4-libs (1.8.3-r2)
   1. (6/19) Installing xz-libs (5.2.4-r0)
   1. (7/19) Installing libarchive (3.3.2-r4)
   1. (8/19) Installing ca-certificates (20190108-r0)
   1. (9/19) Installing nghttp2-libs (1.35.1-r0)
   1. (10/19) Installing libssh2 (1.8.0-r4)
   1. (11/19) Installing libcurl (7.64.0-r1)
   1. (12/19) Installing ncurses-terminfo-base (6.1_p20190105-r0)
   1. (13/19) Installing ncurses-terminfo (6.1_p20190105-r0)
   1. (14/19) Installing ncurses-libs (6.1_p20190105-r0)
   1. (15/19) Installing libgcc (8.2.0-r2)
   1. (16/19) Installing rhash-libs (1.3.6-r2)
   1. (17/19) Installing libstdc++ (8.2.0-r2)
   1. (18/19) Installing libuv (1.23.2-r0)
   1. (19/19) Installing cmake (3.13.0-r0)

5. libressl - SSL ODBC
(1/4) Installing libressl2.7-libcrypto (2.7.5-r0)
(2/4) Installing libressl2.7-libssl (2.7.5-r0)
(3/4) Installing libressl2.7-libtls (2.7.5-r0)
(4/4) Installing libressl (2.7.5-r0)


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