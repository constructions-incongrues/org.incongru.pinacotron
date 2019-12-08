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
        imagemagick \
        make \
        msttcorefonts-installer \
        poppler-utils && \
    update-ms-fonts

COPY ./src/bin/images /usr/local/bin/images
COPY ./src/bin/posters /usr/local/bin/posters
RUN chmod +x /usr/local/bin/images
RUN chmod +x /usr/local/bin/posters

COPY ./src/Makefile /usr/local/src/pinacotron/Makefile

ARG DOCKER_TAG
ENV PINACOTRON_VERSION=${DOCKER_TAG}

ENTRYPOINT [ "make" ]
