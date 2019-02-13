#!/usr/bin/env python

import subprocess
import shlex
import sys
import os

excf = sys.argv[0]

# Ensure we only accept 3 command line arguments for [script, source, destination]
if len(sys.argv) != 3:
	print excf + " -> script requires a source and destination files"
	print excf + " -> cannot proceed, exit"
	sys.exit()

src_file = sys.argv[1]
des_file = sys.argv[2]

# We perform some prelimenary quick checks to ensure all our attributes
# are satisfied before we execute expensive programs
src_file_name, src_file_extension = os.path.splitext(src_file)
dst_file_name, dst_file_extension = os.path.splitext(des_file)

# The source file must always be .gltf
if src_file_extension.lower() != '.fbx':
	print excf + " -> source file must have an extension of .fbx but was -> " + src_file_extension
	print excf + " -> cannot proceed, exit"
	sys.exit()

# The destination file must always be .usdz
if (dst_file_extension.lower() in ['.gltf','glb']) == False:
	print excf + " -> destination file must have an extension of .gltf or .glb but was -> " + dst_file_extension
	print excf + " -> cannot proceed, exit"
	sys.exit()

# Check if the source file exists at path
if os.path.isfile(src_file) != True:
	print excf + " -> script requires the source file to exist -> " + src_file
	print excf + " -> cannot proceed, exit"
	sys.exit()

print excf + " -> setting source file path -> " + src_file
print excf + " -> setting destination file path -> " + des_file

xrutils_command = "sh xrutils_fbx2gltf.sh " + src_file + " " + des_file

print excf + " -> executing command -> " + xrutils_command

# call our shell script, which will in turn execute the appropriate application
subprocess.call(shlex.split(xrutils_command))