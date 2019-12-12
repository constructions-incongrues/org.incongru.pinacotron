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
  pinacotron google download
  ```

- Start image gallery service :

  ```sh
  pinacotron gallery start
  ```

## Usage

### Display commands help

```sh
# Global help
pinacotron help

# Help for a specific command
pinacotron help <command>
```
