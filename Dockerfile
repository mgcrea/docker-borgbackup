FROM ubuntu:16.04
MAINTAINER Silvio Fricke <silvio.fricke@gmail.com>

WORKDIR /borg
ARG IMAGE_VERSION
ENV IMAGE_VERSION ${IMAGE_VERSION:-1.0.0}
ENV DEBIAN_FRONTEND noninteractive

RUN echo 'APT::Install-Recommends 0;' >> /etc/apt/apt.conf.d/01norecommends \
 && echo 'APT::Install-Suggests 0;' >> /etc/apt/apt.conf.d/01norecommends \
  && apt-get update -y \
  && apt-get install -y \
    openssh-server \
    realpath \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/*

ADD https://github.com/borgbackup/borg/releases/download/${IMAGE_VERSION}/borg-linux64 /usr/bin/borg
RUN chmod +x /usr/bin/borg

ADD misc/shini/shini.sh /usr/bin/shini
RUN chmod +x /usr/bin/shini

ADD adds/borgctl /usr/bin/borgctl
RUN chmod +x /usr/bin/borgctl

ADD misc/borgbackup.ini /borg/example.ini

RUN mkdir -p /REPO /BACKUP /RESTORE /STORAGE;

ENTRYPOINT ["/usr/bin/borgctl"]
CMD ["--help"]