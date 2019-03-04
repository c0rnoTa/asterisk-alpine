### NOTES

build-base
---
* (1/19) Installing binutils (2.31.1-r2)
* (2/19) Installing libmagic (5.35-r0)
* (3/19) Installing file (5.35-r0)
* (4/19) Installing gmp (6.1.2-r1)
* (5/19) Installing isl (0.18-r0)
* (6/19) Installing libgomp (8.2.0-r2)
* (7/19) Installing libatomic (8.2.0-r2)
* (8/19) Installing libgcc (8.2.0-r2)
* (9/19) Installing mpfr3 (3.1.5-r1)
* (10/19) Installing mpc1 (1.0.3-r1)
* (11/19) Installing libstdc++ (8.2.0-r2)
* (12/19) Installing gcc (8.2.0-r2)
* (13/19) Installing musl-dev (1.1.20-r3)
* (14/19) Installing libc-dev (0.7.1-r0)
* (15/19) Installing g++ (8.2.0-r2)
* (16/19) Installing make (4.2.1-r2)
* (17/19) Installing fortify-headers (1.0-r0)

asterisk deps
---
* ncurses-dev - termcap support
  * (1/5) Installing ncurses-terminfo-base (6.1_p20190105-r0)
  * (2/5) Installing ncurses-terminfo (6.1_p20190105-r0)
  * (3/5) Installing ncurses-libs (6.1_p20190105-r0)
  * (4/5) Installing pkgconf (1.6.0-r0)
  * (5/5) Installing ncurses-dev (6.1_p20190105-r0)

* util-linux-dev - uuid support
  * (1/6) Installing libuuid (2.33-r0)
  * (2/6) Installing libblkid (2.33-r0)
  * (3/6) Installing libfdisk (2.33-r0)
  * (4/6) Installing libmount (2.33-r0)
  * (5/6) Installing libsmartcols (2.33-r0)
  * (6/6) Installing util-linux-dev (2.33-r0)

* jansson-dev - JSON support
  * (1/2) Installing jansson (2.11-r0)
  * (2/2) Installing jansson-dev (2.11-r0)

* libxml2-dev - The Asterisk menuselect tool
  * (1/3) Installing zlib-dev (1.2.11-r1)
  * (2/3) Installing libxml2 (2.9.9-r1)
  * (3/3) Installing libxml2-dev (2.9.9-r1)

* sqlite-dev - Asterisk now uses SQLite3 
  * (1/2) Installing sqlite-libs (3.26.0-r3)
  * (2/2) Installing sqlite-dev (3.26.0-r3)
 
* bsd-compat-headers - sys/cdefs.h: No such file or directory

patches
---
Installed `patch` to apply musl patches.\ 
https://paulgorman.org/technical/asterisk-alpine-lxc.txt \
https://issues.asterisk.org/jira/browse/ASTERISK-24154

Musl patches are:
* musl-glob-compat.patch - Fix ael.flex: error: 'GLOB_NOMAGIC' undeclared | ael.flex: error: 'GLOB_BRACE' undeclared
* musl-mutex-init.patch - PTHREAD_MUTEX_INITIALIZER should not be assumed to be recursive mutex