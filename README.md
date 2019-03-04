### NOTES

build-base
---
* (1/19) Installing binutils
* (2/19) Installing libmagic
* (3/19) Installing file
* (4/19) Installing gmp
* (5/19) Installing isl
* (6/19) Installing libgomp
* (7/19) Installing libatomic
* (8/19) Installing libgcc
* (9/19) Installing mpfr3
* (10/19) Installing mpc1
* (11/19) Installing libstdc++
* (12/19) Installing gcc
* (13/19) Installing musl-dev
* (14/19) Installing libc-dev
* (15/19) Installing g++
* (16/19) Installing make
* (17/19) Installing fortify-headers

asterisk deps
---
* ncurses-dev - termcap support
  * (1/5) Installing ncurses-terminfo-base
  * (2/5) Installing ncurses-terminfo
  * (3/5) Installing ncurses-libs
  * (4/5) Installing pkgconf
  * (5/5) Installing ncurses-dev

* util-linux-dev - uuid support
  * (1/6) Installing libuuid
  * (2/6) Installing libblkid
  * (3/6) Installing libfdisk
  * (4/6) Installing libmount
  * (5/6) Installing libsmartcols
  * (6/6) Installing util-linux-dev

* jansson-dev - JSON support
  * (1/2) Installing jansson
  * (2/2) Installing jansson-dev

* libxml2-dev - The Asterisk menuselect tool
  * (1/3) Installing zlib-dev
  * (2/3) Installing libxml2
  * (3/3) Installing libxml2-dev

* sqlite-dev - Asterisk now uses SQLite3 
  * (1/2) Installing sqlite-libs
  * (2/2) Installing sqlite-dev
 
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