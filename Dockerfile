# Create a base from a pre-compiled version of USD tools
# More info @ https://github.com/Plattar/python-usd
FROM plattar/python-usd:dev

LABEL MAINTAINER PLATTAR(www.plattar.com)

# our binary versions where applicable
ENV ARCORE_VERSION="1.14.0"
ENV FBX2GLTF_VERSION="0.9.7"
ENV ASSIMP_VERSION="5.0.1"
ENV GLTF2USD_VERSION="4646a5383d7f5c6e689a9217ae91bcf1a872f9df"
ENV UFG_VERSION="c49b1b1abce65fdc6e1bbcd11e6240138225e9f1"

# Add our runtime python scripts to the path so they
# are easy to find from code
ENV CHECKIMG_PYTHON_PATH="/usr/src/app/tools/checkimg.py"
ENV FBX2GLTF_PYTHON_PATH="/usr/src/app/tools/fbx2gltf.py"
ENV GLTF2USD_PYTHON_PATH="/usr/src/app/tools/gltf2usd.py"
ENV ASSIMP_PYTHON_PATH="/usr/src/app/tools/assimp.py"

WORKDIR /usr/src/app

# Copy our tools into the container, these scripts will be used
# to easily interface with the underlying xrutils tools
COPY /tools /usr/src/app/tools

# All our pre-compiled binaries and compiled binaries will be going
# in this folder
RUN mkdir -p xrutils

# Clone and setup the Assimp Converter
# More info @ https://github.com/assimp/assimp
ENV ASSIMP_SRC="assimpsrc"
ENV ASSIMP_BIN_PATH="/usr/src/app/xrutils/assimp/bin"
ENV ASSIMP_LIB_PATH="/usr/src/app/xrutils/assimp/lib"
ENV PATH="${PATH}:${ASSIMP_BIN_PATH}"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${ASSIMP_LIB_PATH}"

RUN git clone https://github.com/assimp/assimp "${ASSIMP_SRC}" && \
	cd "${ASSIMP_SRC}" && git checkout tags/v"${ASSIMP_VERSION}" && cd ../ && \
	cd "${ASSIMP_SRC}" && cmake CMakeLists.txt && make -j4 && cd ../ && \
	mkdir -p xrutils/assimp && \
	mv "${ASSIMP_SRC}/lib" xrutils/assimp/lib && \
	mv "${ASSIMP_SRC}/bin" xrutils/assimp/bin && \
	chmod +x xrutils/assimp/bin/assimp && \
	chmod 777 xrutils/assimp/bin/assimp && \
	rm -rf "${ASSIMP_SRC}" && \
	rm -rf xrutils/assimp/bin/unit

# Clone and setup the GLTF2->USDZ Converter
# More info @ https://github.com/kcoley/gltf2usd
RUN git clone https://github.com/kcoley/gltf2usd xrutils/gltf2usd && \
	cd xrutils/gltf2usd && git checkout ${GLTF2USD_VERSION} && cd ../../ && \
	pip install -r xrutils/gltf2usd/requirements.txt && \
	pip install enum34 && \
	pip install Pillow

# Clone and setup the Image Marker quality checker
# More info @ https://github.com/google-ar/arcore-android-sdk
RUN git clone https://github.com/google-ar/arcore-android-sdk && \
	cd arcore-android-sdk && git checkout tags/v${ARCORE_VERSION} && cd ../ && \
	mv arcore-android-sdk/tools/arcoreimg/linux xrutils/arcoreimg && \
	chmod +x xrutils/arcoreimg/arcoreimg && \
	chmod 777 xrutils/arcoreimg/arcoreimg && \
	rm -rf arcore-android-sdk

# Clone and setup the FBX->GLTF2 Converter
# More info @ https://github.com/facebookincubator/FBX2glTF
RUN wget https://github.com/facebookincubator/FBX2glTF/releases/download/v${FBX2GLTF_VERSION}/FBX2glTF-linux-x64 && \
	mv FBX2glTF-linux-x64 xrutils/fbx2gltf && \
	chmod +x xrutils/fbx2gltf && \
	chmod 777 xrutils/fbx2gltf

# Clone and setup the Google usd_from_gltf converter
# More info @ https://github.com/google/usd_from_gltf
RUN git clone https://github.com/google/usd_from_gltf ufgsrc && \
	cd ufgsrc && git checkout ${UFG_VERSION} && cd ../ && \
	mkdir ufg && \
	python ufgsrc/tools/ufginstall/ufginstall.py ufg ${USD_BUILD_PATH}