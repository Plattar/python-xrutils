#!/bin/sh

# delete the previous directory (if any)
rm -rf xrutils

# copy the stuff out
docker cp plattar-xrutils:/usr/src/app/xrutils .