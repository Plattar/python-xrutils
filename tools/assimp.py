#!/usr/bin/env python

import subprocess
import shlex
import sys
import os

excf = os.path.basename(__file__)
script_path = os.path.dirname(os.path.abspath(__file__))

# Ensure we only accept 3 command line arguments for [script, source, destination]
if len(sys.argv) != 3:
	print excf + " -> script requires a source and destination files"
	print excf + " -> cannot proceed, exit"
	sys.exit()

src_file = sys.argv[1]
des_file = sys.argv[2]

# Check if the source file exists at path
if os.path.isfile(src_file) != True:
	print excf + " -> script requires the source file to exist -> " + src_file
	print excf + " -> cannot proceed, exit"
	sys.exit()

print excf + " -> setting source file path -> " + src_file
print excf + " -> setting destination file path -> " + des_file

xrutils_command = "sh " + script_path + "/xrutils_assimp.sh " + src_file + " " + des_file

print excf + " -> executing command -> '" + xrutils_command + "'"

# call our shell script, which will in turn execute the appropriate application
subprocess.call(shlex.split(xrutils_command))