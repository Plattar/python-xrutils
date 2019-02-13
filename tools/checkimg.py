#!/usr/bin/env python

import subprocess
import shlex
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
src_file_extension = src_file_extension.lower();

if (src_file_extension in ['.jpg','.jpeg','.png']) == False:
	print excf + " -> source file must have an extension of .jpg, .jpeg or .png but was -> " + src_file_extension
	print excf + " -> cannot proceed, exit"
	sys.exit()

# Check if the source file exists at path
if os.path.isfile(src_file) != True:
	print excf + " -> script requires the source file to exist -> " + src_file
	print excf + " -> cannot proceed, exit"
	sys.exit()

print excf + " -> setting source file path -> " + src_file

xrutils_command = "sh xrutils_checkimg.sh " + src_file

print excf + " -> executing command -> " + xrutils_command

# call our shell script, which will in turn execute the appropriate application
subprocess.call(shlex.split(xrutils_command))