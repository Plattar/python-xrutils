#!/bin/sh

fromFile="$1"
toFile="$2"

# current path of the current script
SCRIPT=$(dirname $(readlink -f "$0"))

# Use FBX2GLTF tool to convert a provided FBX into a GLTF2 file
$SCRIPT/../xrutils/fbx2gltf --verbose --input $fromFile --output $toFile