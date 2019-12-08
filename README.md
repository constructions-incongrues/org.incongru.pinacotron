# Pinacotron

## Usage

### Configuration

- `/etc/pinacotron/collections/<collection>/keywords.txt`
- `/etc/pinacotron/collections/<collection>/parameters.txt`
- `/etc/pinacotron/words/words.txt`

### Commands

Displays help.

#### help

```sh
docker run \
    --rm \
    constructionsincongrues/pinacotron \
    help
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
