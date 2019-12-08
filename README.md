# Pinacotron

## Usage

### Configuration

- `/etc/pinacotron/collections/<collection>/keywords.txt`
- `/etc/pinacotron/collections/<collection>/parameters.txt`
- `/etc/pinacotron/words/words.txt`

### Commands

#### help

Displays help.

```sh
docker run \
    --rm \
    constructionsincongrues/pinacotron \
    help
```

#### gallery-start

Starts a web image gallery service on <http://localhost:8000>.

##### Parameters

- `GALLERY_IMAGES_DIR`
- `GALLERY_PORT=8000`
- `HOST_GID`
- `HOST_UID`

##### Examples

```sh
docker run \
    --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v ${PWD}/var:/var/local/pinacotron/ \
    -e GALLERY_IMAGES_DIR=$PWD/var \
    -e HOST_UID=$(id -u) \
    -e HOST_GID=$(id -g) \
    constructionsincongrues/pinacotron \
    gallery-start
```

#### gallery-stop

Stops the web image gallery service.

##### Examples

```sh
docker run \
    --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    constructionsincongrues/pinacotron \
    gallery-stop
```

#### images

Downloads images from collections.

##### Parameters

- `PINACOTRON_IMAGES_PURGE=0`

##### Examples

```sh
docker run \
    --rm \
    -v ${PWD}/etc/pinacotron:/etc/pinacotron \
    -v ${PWD}/var:/var/local/pinacotron \
    constructionsincongrues/pinacotron \
    images
```

#### posters

Combine images with words.

##### Parameters

- `PINACOTRON_POSTERS_CONVERT_PARAMETERS=-gravity South -pointsize 196 -stroke black -fill "#FFFFFF" -colorspace Gray -separate -average -annotate 0`
- `PINACOTRON_POSTERS_PURGE=0`
- `PINACOTRON_POSTERS_WORDS=default.txt`

##### Examples

```sh
docker run \
    --rm \
    -v ${PWD}/etc/pinacotron:/etc/pinacotron \
    -v ${PWD}/var:/var/local/pinacotron \
    constructionsincongrues/pinacotron \
    posters
```

#### version

Displays version.

```sh
docker run \
    --rm \
    constructionsincongrues/pinacotron \
    version
```
