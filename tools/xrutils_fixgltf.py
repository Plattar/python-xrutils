#!/usr/bin/env python

import json
import sys
import re
import sys
import os

excf = sys.argv[0]

# Ensure we only accept 2 command line arguments for [script, source]
if len(sys.argv) != 2:
	print excf + " -> script requires a source file"
	print excf + " -> cannot proceed, exit"
	sys.exit()

src_file = sys.argv[1]

# We perform some prelimenary quick checks to ensure all our attributes
# are satisfied before we execute expensive programs
src_file_name, src_file_extension = os.path.splitext(src_file)

# The source file must always be .gltf
if src_file_extension.lower() != '.gltf':
	print excf + " -> source file must have an extension of .gltf but was -> " + src_file_extension
	print excf + " -> cannot proceed, exit"
	sys.exit()

# Check if the source file exists at path
if os.path.isfile(src_file) != True:
	print excf + " -> script requires the source file to exist -> " + src_file
	print excf + " -> cannot proceed, exit"
	sys.exit()

with open(src_file) as f:
	data = json.load(f)

print excf + " -> scanning and fixing GLTF material names"

# Fix the names of Materials
for material in data['materials']:
	print excf + " -> name before -> " + material['name']
	material['name'] = re.sub('[^A-Za-z0-9]+', '', material['name'])
	material['name'] = material['name'].lstrip('0123456789.- ')
	print excf + " -> name after -> " + material['name']

# Remove AO textures as USDZ does not like them
for material in data['materials']:
	if 'occlusionTexture' in material:
		material.pop('occlusionTexture', None)
		print excf + " -> popped occusionTexture from -> " + material['name']

with open(src_file, 'w') as outfile:
	json.dump(data, outfile)