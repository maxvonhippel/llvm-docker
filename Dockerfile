FROM alpine:latest

ARG LLVM_VERSION=7.0.0

# LLVM dependencies:
RUN apk --no-cache add \
	boost-dev \
	autoconf \
	automake \
	cmake \
	freetype-dev \
	g++ \
	gcc \
	libxml2-dev \
	linux-headers \
	make \
	musl-dev \
	ncurses-dev \
	python2 \
	git \
	glib-dev \
	json-glib-dev

COPY install_llvm.sh /
RUN ./install_llvm.sh ${LLVM_VERSION} && rm install_llvm.sh

ENV CXX=clang++
ENV CC=clang

RUN mkdir home/amit
RUN mkdir home/amit/MyData
WORKDIR home/amit/MyData
RUN git clone https://github.com/saverecs/CProgramToSMT.git 1ProjectFMSafe
WORKDIR 1ProjectFMSafe/llvm-pass-moduleTest
RUN mkdir build
WORKDIR build 
RUN cmake -DCMAKE_C_FLAGS=-DLLVM_ENABLE_DUMP -DCMAKE_CXX_FLAGS=-DLLVM_ENABLE_DUMP ..
WORKDIR ..
RUN make clean build
RUN make

# Get SaverECS
WORKDIR /home
RUN git clone https://github.com/saverecs/SaverECS.git
WORKDIR SaverECS/src
RUN cp /home/amit/MyData/1ProjectFMSafe/llvm-pass-moduleTest/src/libTestPass.so lib/.

# Compile it
RUN chmod +x compile-cpp
RUN ./compile-cpp
RUN chmod +x ./bin/dReal
RUN chmod +x ../.././SaverECS/ODE_visualization/*.sh