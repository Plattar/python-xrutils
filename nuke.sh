#!/bin/sh

# Nukes all built docker images
docker stop plattar-xrutils
docker rm -v plattar-xrutils
docker rmi plattar/python-xrutils:latest --force