#!/bin/sh

fromFile="$1"
toFile="$2"

# Use FBX2GLTF tool to convert a provided FBX into a GLTF2 file
./../xrutils/fbx2gltf --verbose --input $fromFile --output $toFile