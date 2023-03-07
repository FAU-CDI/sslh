FROM alpine:latest as build

ADD . /sslh


# HACK HACK HACK to tell the makefile to not rebuild these
# because the docker container doesn't have conf2struct
RUN touch /sslh/sslh-conf.c /sslh/sslh-conf.h

RUN \
  apk add \
    gcc \
    libconfig-dev \
    make \
    musl-dev \
    pcre2-dev \
    perl && \
  cd /sslh && \
  make sslh-select && \
  strip sslh-select

FROM alpine:latest

COPY --from=build /sslh/sslh-select /sslh

RUN apk --no-cache add libconfig pcre2

ENTRYPOINT [ "/sslh", "--foreground"]
