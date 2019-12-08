FROM constructionsincongrues/google-image-download:2.8.0-alpine3.10

VOLUME [ "/var/local/pinacotron" ]
VOLUME [ "/etc/pinacotron" ]

WORKDIR /usr/local/src/pinacotron

ENV PINACOTRON_IMAGES_PURGE=0
ENV PINACOTRON_POSTERS_CONVERT_PARAMETERS='-gravity South -pointsize 196 -stroke black -fill "#FFFFFF" -colorspace Gray -separate -average -annotate 0'
ENV PINACOTRON_POSTERS_PURGE=0
ENV PINACOTRON_POSTERS_WORDS='default.txt'

RUN apk --update --no-cache add \
        bash \
        curl \
        docker \
        imagemagick \
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

COPY ./src/bin/images /usr/local/bin/images
COPY ./src/bin/posters /usr/local/bin/posters
RUN chmod +x /usr/local/bin/images
RUN chmod +x /usr/local/bin/posters

COPY ./src/Makefile /usr/local/src/pinacotron/Makefile

COPY ./etc/pigallery.json /etc/pigallery.json

ENV PINACOTRON_VERSION=${DOCKER_TAG}

RUN mkdir -p /var/local/pinacotron /usr/local/src/pinacotron /etc/pinacotron && \
    chown -R pinacotron:pinacotron /var/local/pinacotron /usr/local/src/pinacotron /etc/pinacotron

USER pinacotron:pinacotron
ENTRYPOINT [ "fixuid", "-q", "make" ]
