#!/usr/bin/env python

import subprocess
import shlex
import sys
import os

# Ensure we only accept 2 command line arguments for [script, source]
if len(sys.argv) != 2:
	print "checkimg.py -> script requires a source file"
	print "checkimg.py -> cannot proceed, exit"
	sys.exit()

src_file = sys.argv[1]

# We perform some prelimenary quick checks to ensure all our attributes
# are satisfied before we execute expensive programs
src_file_name, src_file_extension = os.path.splitext(src_file)
src_file_extension = src_file_extension.lower();

if (src_file_extension in ['.jpg','.jpeg','.png']) == False:
	print "checkimg.py -> source file must have an extension of .jpg, .jpeg or .png but was -> " + src_file_extension
	print "checkimg.py -> cannot proceed, exit"
	sys.exit()

# Check if the source file exists at path
if os.path.isfile(src_file) != True:
	print "checkimg.py -> script requires the source file to exist -> " + src_file
	print "checkimg.py -> cannot proceed, exit"
	sys.exit()

print "checkimg.py -> setting source file path -> " + src_file

xrutils_command = "sh xrutils_checkimg.sh " + src_file

print "checkimg.py -> executing command -> " + xrutils_command

# call our shell script, which will in turn execute the appropriate application
subprocess.call(shlex.split(xrutils_command))