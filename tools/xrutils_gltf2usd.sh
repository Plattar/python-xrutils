#!/bin/sh

# Export our pathing information so the USDZ converter can function
export PATH=$PATH:/usr/src/app/xrutils/USDPython/bin
export PYTHONPATH=$PYTHONPATH:/usr/src/app/xrutils/USDPython/lib/python

fromFile="$1"
toFile="$2"

# This will enable a fix mode to ensure all special characters etc.. are
# cleaned from the .gltf file itself
python ./xrutils_fixgltf.py $fromFile

# Perform the conversion and save the output to the path that was
# provided
python ./../xrutils/gltf2usd/Source/gltf2usd.py -v -g $fromFile -o $toFile