ARG SOURCE_DATE_EPOCH=0
ARG LANG=${LANG:-en_US.UTF-8}

FROM debian:sid-slim AS build
ARG SOURCE_DATE_EPOCH
ARG LANG
ENV DEBCONF_NONINTERACTIVE_SEEN=true
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y \
  ca-certificates \
  expect \
  openjdk-11-jdk \
  curl \
  iproute2 \
  gnupg \
  binutils \
	locales

RUN update-java-alternatives -s java-1.11.0-openjdk-amd64
RUN mkdir -p /root/app /tmp/.X11-unix
COPY --chmod=+x ./docker-entrypoint.sh /

RUN apt autoremove -y && apt-get clean -y && rm -rf /usr/share/man/* /var/log/* /var/lib/apt/lists/*

FROM scratch
ARG SOURCE_DATE_EPOCH
ARG LANG
COPY --from=build / /
ENV LANG=${LANG:-en_US.UTF-8}

ENV http_proxy= \
    no_proxy= \
    NO_PROXY= \
    https_proxy= \
    HTTP_PROXY= \
    HTTPS_PROXY= \
    HOSTNAME=app \
    SSH_CONNECTION= \
    SSH_CLIENT=

WORKDIR /root/app
EXPOSE 50050 80 443
ENTRYPOINT ["/docker-entrypoint.sh"]
