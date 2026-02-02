#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm pipewire-audio pipewire-jack \
	gcc-libs \
	clang \
	glslang \
	hicolor-icon-theme \
	libx11 \
	pugixml \
	sdl2 \
	bluez-libs \
	boost \
	cmake \
	curl \
	fmt \
	glm \
	glu \
	gtk3 \
	hidapi \
	libgl \
	libpng \
	libusb \
	libzip \
	nasm \
	openssl \
	rapidjson \
	vulkan-headers \
	wayland \
	wayland-protocols \
	zarchive \
	zlib \
	zstd
	#wxwidgets-gtk3

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common

echo "Building cemu..."
echo "---------------------------------------------------------------"

# build with x86_64_v3 target
#if [ "${DEVEL_RELEASE-}" = 1 ]; then
	#make-aur-package wxgtk-git
	#make-aur-package cubeb
	#TARGET_V3_CPU=1 make-aur-package cemu-git
#else
	#TARGET_V3_CPU=1 make-aur-package cemu
#fi
make-aur-package wxgtk-git
make-aur-package cubeb

git clone --recursive https://github.com/cemu-project/Cemu

cd Cemu
cmake -D ALLOW_PORTABLE=OFF \
		-D CMAKE_BUILD_TYPE=Release \
		-D CMAKE_C_COMPILER=clang \
		-D CMAKE_CXX_COMPILER=clang++ \
		-D CMAKE_C_FLAGS_RELEASE="-DNDEBUG" \
		-D CMAKE_CXX_FLAGS_RELEASE="-DNDEBUG" \
		-D CMAKE_INTERPROCEDURAL_OPTIMIZATION=ON \
		-D ENABLE_VCPKG=OFF \
		-Wno-dev -B build

cmake --build build

install -d /usr/{bin,share/Cemu}
mv bin/Cemu_release /usr/bin/Cemu
cp -dr --no-preserve=ownership -t /usr/share/Cemu bin/*
install -Dm644 -t /usr/share/applications dist/linux/info.cemu.Cemu.desktop
install -Dm644 -t /usr/share/icons/hicolor/128x128/apps dist/linux/info.cemu.Cemu.png
install -Dm644 -t /usr/share/metainfo dist/linux/info.cemu.Cemu.metainfo.xml
