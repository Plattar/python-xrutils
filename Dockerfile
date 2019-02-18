FROM python:2.7.15

ENV USD_VERSION 18.11
ENV ARCORE_VERSION 1.6.0
ENV FBX2GLTF_VERSION 0.9.5

WORKDIR /usr/src/app

# Required for compiling the USD source
RUN apt-get update && apt-get install -y \
	git \
	g++ \
	gcc \
	make \
	cmake \
	doxygen \
	graphviz

# Copy our tools into the container, these scripts will be used
# to easily interface with the underlying xrutils tools
COPY /tools /usr/src/app/tools

# All our pre-compiled binaries and compiled binaries will be going
# in this folder
RUN mkdir xrutils

# Clone and setup the GLTF2->USDZ Converter
# More info @ https://github.com/kcoley/gltf2usd
RUN git clone https://github.com/kcoley/gltf2usd xrutils/gltf2usd && \
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

# Clone, setup and compile the Pixar USD Converter. This is required
# for converting GLTF2->USDZ
# More info @ https://github.com/PixarAnimationStudios/USD
RUN git clone https://github.com/PixarAnimationStudios/USD && \
	cd USD && git checkout tags/v${USD_VERSION} && cd ../ && \
	python USD/build_scripts/build_usd.py --build-args TBB,extra_inc=big_iron.inc --python --no-imaging --docs --no-usdview --build-monolithic xrutils/USDPython && \
	rm -rf USD

# Add our runtime python scripts to the path so they
# are easy to find from code
ENV CHECKIMG_PYTHON_PATH /usr/src/app/tools/checkimg.py
ENV FBX2GLTF_PYTHON_PATH /usr/src/app/tools/fbx2gltf.py
ENV GLTF2USD_PYTHON_PATH /usr/src/app/tools/gltf2usd.py
