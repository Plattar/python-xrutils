# Create a base from a pre-compiled version of USD tools
# More info @ https://github.com/Plattar/python-usd-ar
FROM plattar/python-usd-ar:version-22.05b-slim-buster

LABEL MAINTAINER PLATTAR(www.plattar.com)

ENV BASE_DIR="/usr/src/app"

# ASSIMP ENV VARIABLES
ENV ASSIMP_SRC="assimpsrc"
ENV ASSIMP_BIN_PATH="${BASE_DIR}/xrutils/assimp/bin"
ENV ASSIMP_LIB_PATH="${BASE_DIR}/xrutils/assimp/lib"
ENV PATH="${PATH}:${ASSIMP_BIN_PATH}"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${ASSIMP_LIB_PATH}"

WORKDIR ${BASE_DIR}

# Required for compiling the various sources
RUN apt-get update && apt-get install -y --no-install-recommends \
	git \
	build-essential \
	cmake \
	make \
	nasm \
	wget \
	curl && \
	# All our pre-compiled binaries and compiled binaries will be going
	# in this folder
	mkdir -p xrutils && \
	# Assimp Clone/Compile
	# More info @ https://github.com/assimp/assimp
	git clone https://github.com/assimp/assimp ${ASSIMP_SRC} && \
	cd ${ASSIMP_SRC} && git checkout tags/v${ASSIMP_VERSION} && cd ../ && \
	cd ${ASSIMP_SRC} && cmake CMakeLists.txt && make -j4 && cd ../ && \
	mkdir -p xrutils/assimp && \
	mv ${ASSIMP_SRC}/lib ${ASSIMP_LIB_PATH} && \
	mv ${ASSIMP_SRC}/bin ${ASSIMP_BIN_PATH} && \
	chmod +x ${ASSIMP_BIN_PATH}/assimp && \
	chmod 777 ${ASSIMP_BIN_PATH}/assimp && \
	rm -rf ${ASSIMP_SRC} && \
	rm -rf ${ASSIMP_BIN_PATH}/unit && \
	# remove packages we no longer need/require
	# this keeps the container as small as possible
	# if others need them, they can install when extending
	apt-get purge -y git \
	build-essential \
	cmake \
	make \
	nasm \
	wget \
	curl && \
	apt autoremove -y && \
	apt-get autoclean -y