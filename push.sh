#!/bin/sh

# push a local build into dockerhub
docker tag plattar/python-xrutils:latest plattar/python-xrutils:$1
docker push plattar/python-xrutils:$1