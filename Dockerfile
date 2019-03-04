FROM alpine:latest

MAINTAINER Anton Zakharov hello@antonzakharov.ru

WORKDIR /usr/src

ADD src/*.tar.gz ./



COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]