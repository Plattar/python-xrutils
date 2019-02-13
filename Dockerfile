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
	graphviz \
	libboost-all-dev

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
	cp -r arcore-android-sdk/tools/arcoreimg/linux xrutils/arcoreimg && \
	rm -rf arcore-android-sdk

# Clone, setup and compile the Pixar USD Converter. This is required
# for converting GLTF2->USDZ
# More info @ https://github.com/PixarAnimationStudios/USD
RUN git clone https://github.com/PixarAnimationStudios/USD && \
	cd USD && git checkout tags/v${USD_VERSION} && cd ../ && \
	python USD/build_scripts/build_usd.py --build-args TBB,extra_inc=big_iron.inc --python --no-imaging --docs --no-usdview --build-monolithic xrutils/USDPython && \
	rm -rf USD
