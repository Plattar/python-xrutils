#!/bin/sh

fromFile="$1"

# current path of the current script
SCRIPT=$(dirname $(readlink -f "$0"))

# Use the arcoreimg tool to perform a check against the provided image
# file to see how suitable it is for marker-tracking purposes
$SCRIPT/../xrutils/arcoreimg/arcoreimg eval-img --input_image_path=$fromFile