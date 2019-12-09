# Pinacotron

## Installation

```sh
curl https://raw.githubusercontent.com/constructions-incongrues/org.incongru.pinacotron/master/bin/pinacotron | sudo tee /usr/local/bin/pinacotron
sudo chmod +x /usr/local/bin/pinacotron
```

## Getting started

- Create a dedicated directory :

  ```sh
  mkdir -p myproject
  cd myproject
  ```

- Bootstrap configuration :

  ```sh
  pinacotron init
  ```

- Download collection images :

  ```sh
  pinacotron download
  ```

- Start image gallery service :

  ```sh
  pinacotron gallery start
  ```

- Browse image gallery service :

  ```sh
  pinacotron gallery browse
  ```

## Usage

### Configuration files

- `etc/pinacotron/collections/<collection>/keywords.txt`
- `etc/pinacotron/collections/<collection>/parameters.txt`
- `etc/pinacotron/words/words.txt`

### Commands

#### help

Displays help.

```sh
pinacotron help
```

#### gallery start

Starts a web image gallery service on <http://localhost:8000>.

##### Parameters

- `-p` : Image gallery port (default : `8000`)

##### Examples

```sh
# Default configuration
pinacotron gallery start

# Custom port
pinacotron gallery start -p 9000
```

#### gallery stop

Stops the web image gallery service.

##### Examples

```sh
pinacotron gallery stop
```

#### download

Downloads images from collections.

##### Parameters

- `-P` : Purge images folder

##### Examples

```sh
pinacotron download
```

#### init

Creates a stub configuration.

##### Examples

```sh
pinacotron init
```

#### posters

Combine images with words.

##### Parameters

- `-c` : Convert parameters for text (default : `-gravity South -pointsize 196 -stroke black -fill "#FFFFFF" -colorspace Gray -separate -average -annotate 0`)
- `-P` : Purge posters folder
- `-w` : List of words in `words/` directory (default : `default.txt`)

##### Examples

```sh
# Default configuration
pinacotron posters

# Purge existing posters
pinacotron posters -P

## Red text
pinacotron posters -c '-gravity South -pointsize 196 -stroke black -fill "#FF0000" -colorspace Gray -separate -average -annotate 0'
```

#### version

Show Pinacotron version information.

```sh
pinacotron version
```
