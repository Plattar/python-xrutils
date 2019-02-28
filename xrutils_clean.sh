#!/bin/sh

docker stop xrutils
docker rm xrutils -v
docker rmi xrutils