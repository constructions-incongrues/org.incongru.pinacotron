FROM constructionsincongrues/google-image-download:2.8.0-alpine3.10

VOLUME [ "/var/local/pinacotron" ]
VOLUME [ "/etc/pinacotron" ]

WORKDIR /usr/local/src/pinacotron

RUN apk --update --no-cache add \
        gawk \
        bash \
        curl \
        docker \
        git \
        imagemagick \
        jq \
        make \
        msttcorefonts-installer \
        poppler-utils && \
    update-ms-fonts

RUN addgroup -g 1000 pinacotron && \
    adduser -u 1000 -G pinacotron -h /home/pinacotron -s /bin/sh -D pinacotron
RUN USER=pinacotron && \
    GROUP=pinacotron && \
    curl -SsL https://github.com/boxboat/fixuid/releases/download/v0.4/fixuid-0.4-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf - && \
    chown root:root /usr/local/bin/fixuid && \
    chmod 4755 /usr/local/bin/fixuid && \
    mkdir -p /etc/fixuid && \
    printf "user: $USER\ngroup: $GROUP\n" > /etc/fixuid/config.yml

COPY --chown=pinacotron:pinacotron ./src /usr/local/src/pinacotron/

ARG PINACOTRON_VERSION=1.4.0
ENV PINACOTRON_VERSION=${PINACOTRON_VERSION}

RUN mkdir -p /var/local/pinacotron /usr/local/src/pinacotron /etc/pinacotron && \
    chown -R pinacotron:pinacotron /var/local/pinacotron /usr/local/src/pinacotron /etc/pinacotron

USER pinacotron:pinacotron
ENTRYPOINT [ "fixuid", "-q", "make" ]
