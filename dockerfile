FROM debian:latest

# Get external deps
RUN apt-get update -y
RUN dpkg --add-architecture armhf
RUN apt-get update -y
RUN apt-get install crossbuild-essential-armhf cross-gcc-dev g++-arm-linux-gnueabihf gcc-arm-linux-gnueabihf nasm -y
RUN apt-get install build-essential gperf help2man bison texinfo flex gawk autoconf automake wget curl file libncurses-dev git unzip libtool libtool-bin libtool-doc shtool autogen -y

# Pull in crosstool-ng
RUN git clone https://github.com/NiLuJe/crosstool-ng /crosstool-ng-sources

# Build crosstool-ng
WORKDIR /crosstool-ng-sources
RUN ./bootstrap
RUN ./configure
RUN make
RUN make install

# Set up a temp dir to configure crosstool in 
RUN mkdir -p /crosstool-cfg
WORKDIR /crosstool-cfg
RUN mkdir -p /home/crosstooluser/src
RUN ct-ng arm-kobo-linux-gnueabihf

# Set up a temp user for crosstool to use
RUN echo "CT_EXPERIMENTAL=y\n" >> .config
RUN echo "CT_ALLOW_BUILD_AS_ROOT=y\n" >> .config
RUN echo "CT_ALLOW_BUILD_AS_ROOT_SURE=y\n" >> .config
RUN mkdir -p /root/src
RUN ct-ng build

# Load rawdraw deps
RUN apt-get install xorg-dev libx11-dev libxinerama-dev libxext-dev mesa-common-dev libglu1-mesa-dev cmake libx11-dev -y

