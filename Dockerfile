# Create a base from a pre-compiled version of USD tools
# More info @ https://github.com/Plattar/python-usd-ar
FROM plattar/python-usd-ar:version-22.05b-slim-bullseye

LABEL MAINTAINER PLATTAR(www.plattar.com)

ENV BASE_DIR="/usr/src/app"

# ASSIMP ENV VARIABLES
ENV ASSIMP_VERSION="5.2.4"
ENV ASSIMP_SRC="assimpsrc"
ENV ASSIMP_BIN_PATH="${BASE_DIR}/xrutils/assimp/bin"
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
	git clone --branch "v${ASSIMP_VERSION}" --depth 1 https://github.com/assimp/assimp.git ${ASSIMP_SRC} && \
	cd ${ASSIMP_SRC} && cmake CMakeLists.txt && make -j4 && cd ../ && \
	mkdir -p xrutils/assimp && \
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