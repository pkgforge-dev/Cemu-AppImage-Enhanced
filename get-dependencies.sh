#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
	bluez-libs          \
	boost               \
	clang               \
	cmake               \
	fmt                 \
	glm                 \
	glslang             \
	glu                 \
	hicolor-icon-theme  \
	hidapi              \
	libgl               \
	libzip              \
	llvm                \
	nasm                \
	pipewire-audio      \
	pipewire-jack       \
	pugixml             \
	rapidjson           \
	sdl2				\
	vulkan-headers      \
	wayland-protocols   \
	zarchive

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common ! llvm

make-aur-package cubeb
make-aur-package wxgtk-git

echo "Building Cemu..."
echo "---------------------------------------------------------------"
REPO="https://github.com/cemu-project/Cemu"
# Determine to build nightly or stable
#if [ "${DEVEL_RELEASE-}" = 1 ]; then
#	echo "Making nightly build of Cemu..."
#	VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
#    git clone --recursive --depth 1 "$REPO" ./Cemu
#else
#	echo "Making stable build of Cemu..."
#	VERSION="$(git ls-remote --tags --sort="v:refname" https://github.com/cemu-project/Cemu | tail -n1 | sed 's/.*\///; s/\^{}//; s/^v//')"
#	git clone --branch v"$VERSION" --single-branch --recursive --depth 1 "$REPO" ./Cemu
#fi
if [ "${DEVEL_RELEASE-}" = 1 ]; then
	echo "Making nightly build of Cemu..."
	VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
    git clone --recursive --depth 1 "$REPO" ./Cemu

	cd Cemu
	mkdir -p build && cd build

	ARCH_FLAGS=""
	if [ "$ARCH" = 'x86_64' ]; then
		echo "Making x86-64-v3 optimized build of Cemu..."
		ARCH_FLAGS="-march=x86-64-v3 -O3"
	fi
	
	# CMAKE_POLICY_VERSION_MINIMUM=3.5 required for stable
	cmake .. -D ALLOW_PORTABLE=OFF \
		  -D CMAKE_BUILD_TYPE=Release \
	  	  -D CMAKE_C_COMPILER=clang \
	 	  -D CMAKE_CXX_COMPILER=clang++ \
		  -D CMAKE_EXE_LINKER_FLAGS="-lzstd" \
	 	  -D CMAKE_C_FLAGS_RELEASE="$ARCH_FLAGS -DNDEBUG" \
		  -D CMAKE_CXX_FLAGS_RELEASE="$ARCH_FLAGS -DNDEBUG" \
		  -D CMAKE_INTERPROCEDURAL_OPTIMIZATION=ON \
	 	  -D CMAKE_POLICY_VERSION_MINIMUM=3.5 \ 
		  -D ENABLE_VCPKG=OFF \
		  -Wno-dev
	make -j $(nproc)

	install -d /usr/bin /usr/share/Cemu
	mv bin/Cemu_release /usr/bin/Cemu
	cp -dr --no-preserve=ownership -t /usr/share/Cemu bin/*
	install -Dm644 -t /usr/share/applications dist/linux/info.cemu.Cemu.desktop
	install -Dm644 -t /usr/share/icons/hicolor/128x128/apps dist/linux/info.cemu.Cemu.png
	install -Dm644 -t /usr/share/metainfo dist/linux/info.cemu.Cemu.metainfo.xml
else
	echo "Making stable build of Cemu..."
	TARGET_V3_CPU=1 make-aur-package cemu
	VERSION=$(pacman -Q cemu | awk '{print $2; exit}')
fi
echo "$VERSION" > ~/version
