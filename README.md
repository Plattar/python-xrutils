[![Twitter: @plattarglobal](https://img.shields.io/badge/contact-@plattarglobal-blue.svg?style=flat)](https://twitter.com/plattarglobal)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg?style=flat)](LICENSE)

_Python XRUtils_ is a docker image that contains a number of pre-built tools useful for 3D file conversions. These tools typically take a long time to build from source. This image can serve as a useful base for other applications. Check out the Plattar [dockerhub](https://hub.docker.com/r/plattar/python-xrutils) repository for the latest pre-built images.

* * *

### About

-   Convert GLTF2 models into USDZ
-   Convert FBX models into GLTF2

### Quickstart

Prebuilt containers are available from Plattar [dockerhub](https://hub.docker.com/r/plattar/python-xrutils) repository.

##### Building/Running Locally

```sh
# to build a local version of this repository run the following script
docker-compose -f live.yml build

# once built, run the following script to bring up the container
docker-compose -f live.yml up

# once the container is running, the user can exec into it with the following command
docker exec -it plattar-xrutils /bin/sh

# to clean everything run the following script as follows
sh nuke.sh
```

### Usage

Built container places all executables in the PATH environment and can be accessed as follows.

```sh
# Use Assimp assimp tool for 3D file conversions
assimp export $FROM_MODEL_FILE_PATH $TO_MODEL_FILE_PATH

# Apple usdzconvert tool, convert GLTF to USDZ
usdzconvert $FROM_MODEL_FILE_PATH $TO_MODEL_FILE_PATH
```

### Acknowledgements

This tool relies on the following open source projects.

-   [Facebook Incubator FBX to GLTF Converter](https://github.com/facebookincubator/FBX2glTF)
-   [Pixar Animation Studio USD Toolchain](https://github.com/PixarAnimationStudios/USD)
-   [Plattar Python USD for AR](https://github.com/Plattar/python-usd-ar)