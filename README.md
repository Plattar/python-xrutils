[![Twitter: @plattarglobal](https://img.shields.io/badge/contact-@plattarglobal-blue.svg?style=flat)](https://twitter.com/plattarglobal)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg?style=flat)](LICENSE)

_Python XRUtils_ is a docker image that contains a number of pre-built tools useful for 3D/2D file conversions. Due to the amount of time it takes to build these tools, this image can serve as a useful base for other applications. Check out the Plattar [dockerhub](https://hub.docker.com/r/plattar/python-xrutils) repository for the latest pre-built images.

***

### About

- Convert GLTF2 models into USDZ
- Convert FBX models into GLTF2
- Check image tracking quality, useful for assigning as a marker image

### Quickstart

Prebuilt containers are available from Plattar [dockerhub](https://hub.docker.com/r/plattar/python-xrutils) repository.

##### Building/Running Locally

```sh
# to build a local version of this repository run the following script
sh xrutils_build.sh

# once built, run the following script to bring up the container
sh xrutils_up.sh

# once finished with the container, it can be bought down as follows
sh xrutils_down.sh

# once the container is running, the user can exec into it with the following command
docker exec -it xrutils /bin/sh
```

### Usage

This container can be used to perform the following operations. The user will need to either exec into the container or extend it.

##### Convert FBX to GLTF2 or GLB

```sh
# ensure to provide file extensions for the input and the output files
python ./tools/fbx2gltf.py ./input/myFile.fbx ./output/myFile.gltf
```

##### Convert GLTF2 to USDZ

```sh
# ensure to provide file extensions for the input and the output files
python ./tools/gltf2usd.py ./input/myFile.gltf ./output/myFile.usdz
```

##### Check Image Quality for Marker Tracking

```sh
# ensure to provide file extensions for the input file
# only accepts .png, .jpeg, .jpg
# checkimg will output a number between 0 and 100
python ./tools/checkimg.py ./input/myFile.png
```

### Acknowledgements

This tool relies on the following open source projects.

- [Facebook Incubator FBX to GLTF Converter](https://github.com/facebookincubator/FBX2glTF)
- [Pixar Animation Studio USD Toolchain](https://github.com/PixarAnimationStudios/USD)
- [kcoley GLTF to USD Python Project](https://github.com/kcoley/gltf2usd)
- [Google ARCore SDK](https://github.com/google-ar/arcore-android-sdk)
