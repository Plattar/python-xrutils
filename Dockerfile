# Create a base from a pre-compiled version of USD tools
# More info @ https://github.com/Plattar/python-usd
FROM plattar/python-usd:version-20.08-slim-buster

LABEL MAINTAINER PLATTAR(www.plattar.com)

ENV BASE_DIR="/usr/src/app"

# our binary versions where applicable
ENV ARCORE_VERSION="1.18.1"
ENV FBX2GLTF_VERSION="0.9.7"
ENV ASSIMP_VERSION="5.0.1"
ENV GLTF2USD_VERSION="4646a5383d7f5c6e689a9217ae91bcf1a872f9df"
ENV UFG_VERSION="6d288cce8b68744494a226574ae1d7ba6a9c46eb"
ENV BASIS_VERSION="1.12"

# BASIS UNIVERSAL ENV VARIABLES
ENV BASIS_SRC="basissrc"
ENV BASIS_BIN_PATH="${BASE_DIR}/xrutils/basisuniversal/bin"
ENV BASIS_LIB_PATH="${BASE_DIR}/xrutils/basisuniversal/lib"
ENV PATH="${PATH}:${ASSIMP_BIN_PATH}"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${ASSIMP_LIB_PATH}"

# ASSIMP ENV VARIABLES
ENV ASSIMP_SRC="assimpsrc"
ENV ASSIMP_BIN_PATH="${BASE_DIR}/xrutils/assimp/bin"
ENV ASSIMP_LIB_PATH="${BASE_DIR}/xrutils/assimp/lib"
ENV PATH="${PATH}:${ASSIMP_BIN_PATH}"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${ASSIMP_LIB_PATH}"

# UFG ENV VARIABLES
ENV UFG_SRC="ufgsrc"
ENV UFG_BIN_PATH="${BASE_DIR}/xrutils/ufg/bin"
ENV UFG_LIB_PATH="${BASE_DIR}/xrutils/ufg/lib"
ENV PATH="${PATH}:${UFG_BIN_PATH}"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${UFG_LIB_PATH}"

# ARCOREIMG ENV VARIABLES
ENV ARCOREIMG_SRC="arcoresrc"
ENV ARCOREIMG_BIN_PATH="${BASE_DIR}/xrutils/arcoreimg/bin"
ENV PATH="${PATH}:${ARCOREIMG_BIN_PATH}"

# FBX2GLTF ENV VARIABLES
ENV FBX2GLTF_BIN_PATH="${BASE_DIR}/xrutils/fbx2gltf/bin"
ENV PATH="${PATH}:${FBX2GLTF_BIN_PATH}"

# GLTF2USD ENV VARIABLES
ENV GLTF2USD_BIN_PATH="${BASE_DIR}/xrutils/gltf2usd/Source"
ENV GLTF2USD_PY_PATH="${GLTF2USD_BIN_PATH}/gltf2usd.py"
ENV PATH="${PATH}:${GLTF2USD_BIN_PATH}"

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
	# Basis Universal Clone/Compile
	git clone https://github.com/BinomialLLC/basis_universal ${BASIS_SRC} && \
	cd ${BASIS_SRC} && git checkout tags/v${BASIS_VERSION} && cd ../ && \
	cd ${BASIS_SRC} && cmake CMakeLists.txt && make && cd ../ && \
	mkdir -p xrutils/basisuniversal && \
	mv ${BASIS_SRC}/lib ${BASIS_LIB_PATH} && \
	mv ${BASIS_SRC}/bin ${BASIS_BIN_PATH} && \
	chmod +x ${BASIS_BIN_PATH}/basisu && \
	chmod 777 ${BASIS_BIN_PATH}/basisu && \
	rm -rf ${BASIS_SRC} && \
	# Assimp Clone/Compile
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
	# Clone and setup the GLTF2->USDZ Converter
	# More info @ https://github.com/kcoley/gltf2usd
	git clone https://github.com/kcoley/gltf2usd xrutils/gltf2usd && \
	cd xrutils/gltf2usd && git checkout ${GLTF2USD_VERSION} && cd ../../ && \
	pip install -r xrutils/gltf2usd/requirements.txt && \
	pip install enum34 && \
	pip install Pillow && \
	chmod +x ${GLTF2USD_PY_PATH} && \
	# Clone and setup the Image Marker quality checker
	# More info @ https://github.com/google-ar/arcore-android-sdk
	git clone https://github.com/google-ar/arcore-android-sdk ${ARCOREIMG_SRC} && \
	cd ${ARCOREIMG_SRC} && git checkout tags/v${ARCORE_VERSION} && cd ../ && \
	mkdir -p ${ARCOREIMG_BIN_PATH} && \
	mv ${ARCOREIMG_SRC}/tools/arcoreimg/linux/arcoreimg ${ARCOREIMG_BIN_PATH}/arcoreimg && \
	chmod +x ${ARCOREIMG_BIN_PATH}/arcoreimg && \
	chmod 777 ${ARCOREIMG_BIN_PATH}/arcoreimg && \
	rm -rf ${ARCOREIMG_SRC} && \
	# Clone and setup the FBX->GLTF2 Converter
	# More info @ https://github.com/facebookincubator/FBX2glTF
	wget https://github.com/facebookincubator/FBX2glTF/releases/download/v${FBX2GLTF_VERSION}/FBX2glTF-linux-x64 && \
	mkdir -p ${FBX2GLTF_BIN_PATH} && \
	mv FBX2glTF-linux-x64 ${FBX2GLTF_BIN_PATH}/fbx2gltf && \
	chmod +x ${FBX2GLTF_BIN_PATH}/fbx2gltf && \
	chmod 777 ${FBX2GLTF_BIN_PATH}/fbx2gltf && \
	# Clone and setup the Google usd_from_gltf converter
	# More info @ https://github.com/google/usd_from_gltf
	git clone https://github.com/google/usd_from_gltf ${UFG_SRC} && \
	cd ${UFG_SRC} && git checkout ${UFG_VERSION} && cd ../ && \
	mkdir ufg && \
	python ufgsrc/tools/ufginstall/ufginstall.py ufg ${USD_BUILD_PATH} && \
	mkdir -p xrutils/ufg && \
	mv ufg/lib ${UFG_LIB_PATH} && \
	mv ufg/bin ${UFG_BIN_PATH} && \
	rm -rf ${UFG_SRC} && \
	rm -rf ufg && \
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