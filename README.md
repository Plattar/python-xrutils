[![Twitter: @plattarglobal](https://img.shields.io/badge/contact-@plattarglobal-blue.svg?style=flat)](https://twitter.com/plattarglobal)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg?style=flat)](LICENSE)

_Python XRUtils_ is a docker image that contains a number of pre-built tools useful for 3D/2D file conversions. These tools typically take a long time to build from source. This image can serve as a useful base for other applications. Check out the Plattar [dockerhub](https://hub.docker.com/r/plattar/python-xrutils) repository for the latest pre-built images.

* * *

### About

-   Convert GLTF2 models into USDZ
-   Convert FBX models into GLTF2
-   Check image tracking quality, useful for assigning as a marker image
-   Convert images into BASIS format
-   Convert images into KTX2 format

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
# Use Google ARCore arcoreimg tool
arcoreimg eval-img --input_image_path=$IMAGE_PATH

# Use Assimp assimp tool
assimp export $FROM_MODEL_FILE_PATH $TO_MODEL_FILE_PATH

# Use Facebook fbx2gltf tool
fbx2gltf --verbose --input $FROM_MODEL_FILE_PATH --output $TO_MODEL_FILE_PATH

# Use Google USD from GLTF tool
usd_from_gltf $FROM_MODEL_FILE_PATH $TO_MODEL_FILE_PATH

# Use Basis Universal tool
basisu $FROM_IMAGE_FILE_PATH
```

### Acknowledgements

This tool relies on the following open source projects.

-   [Facebook Incubator FBX to GLTF Converter](https://github.com/facebookincubator/FBX2glTF)
-   [Pixar Animation Studio USD Toolchain](https://github.com/PixarAnimationStudios/USD)
-   [Google ARCore SDK](https://github.com/google-ar/arcore-android-sdk)
-   [Google USD From GLTF Project](https://github.com/google/usd_from_gltf)
-   [Assimp Project](https://github.com/assimp/assimp)
-   [BinomialLLC Basis Universal Project](https://github.com/binomialLLC/basis_universal)
-   [KhronosGroup KTX Software](https://github.com/KhronosGroup/KTX-Software)