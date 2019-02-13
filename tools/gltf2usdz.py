#!/usr/bin/env python

import subprocess
import shlex
import sys
import os

# Ensure we only accept 3 command line arguments for [script, source, destination]
if len(sys.argv) != 3:
	print "gltf2usdz.py -> script requires a source and destination files"
	print "gltf2usdz.py -> cannot proceed, exit"
	sys.exit()

src_file = sys.argv[1]
des_file = sys.argv[2]

# We perform some prelimenary quick checks to ensure all our attributes
# are satisfied before we execute expensive programs
src_file_name, src_file_extension = os.path.splitext(src_file)
dst_file_name, dst_file_extension = os.path.splitext(des_file)

# The source file must always be .gltf
if src_file_extension.lower() != '.gltf':
	print "gltf2usdz.py -> source file must have an extension of .gltf but was -> " + src_file_extension
	print "gltf2usdz.py -> cannot proceed, exit"
	sys.exit()

# The destination file must always be .usdz
if dst_file_extension.lower() != '.usdz':
	print "gltf2usdz.py -> destination file must have an extension of .usdz but was -> " + dst_file_extension
	print "gltf2usdz.py -> cannot proceed, exit"
	sys.exit()

# Check if the source file exists at path
if os.path.isfile(src_file) != True:
	print "gltf2usdz.py -> script requires the source file to exist -> " + src_file
	print "gltf2usdz.py -> cannot proceed, exit"
	sys.exit()

print "gltf2usdz.py -> setting source file path -> " + src_file
print "gltf2usdz.py -> setting destination file path -> " + des_file

xrutils_command = "sh xrutils_gltf2usdz.sh " + src_file + " " + des_file

print "gltf2usdz.py -> executing command -> " + xrutils_command

# call our shell script, which will in turn execute the appropriate application
subprocess.call(shlex.split(xrutils_command))