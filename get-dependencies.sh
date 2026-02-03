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
	hidapi              \
	libgl               \
	libzip              \
	llvm                \
	nasm                \
	pugixml             \
	rapidjson           \
	sdl2                \
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

if [ "$ARCH" = 'x86_64' ]; then
	echo "Making x86-64-v3 optimized build of Cemu..."
	set -- -march=x86-64-v3 -O3 -DNDEBUG
else
	set -- -DNDEBUG
fi

if [ "${DEVEL_RELEASE-}" = 1 ]; then
	echo "Making nightly build of Cemu..."
    git clone --recursive --depth 1 "$REPO" ./Cemu
	mkdir -p ./Cemu/build
	cd ./Cemu/build
	git rev-parse --short=9 HEAD > ~/version

	# CMAKE_POLICY_VERSION_MINIMUM=3.5 required for stable
	cmake ../ \
		-D ALLOW_PORTABLE=OFF                    \
		-D CMAKE_BUILD_TYPE=Release              \
		-D CMAKE_C_COMPILER=clang                \
		-D CMAKE_CXX_COMPILER=clang++            \
		-D CMAKE_EXE_LINKER_FLAGS="-lzstd"       \
		-D CMAKE_C_FLAGS_RELEASE="$@"            \
		-D CMAKE_CXX_FLAGS_RELEASE="$@"          \
		-D CMAKE_INTERPROCEDURAL_OPTIMIZATION=ON \
		-D CMAKE_POLICY_VERSION_MINIMUM=3.5      \
		-D ENABLE_VCPKG=OFF                      \
		-Wno-dev
	make -j $(nproc)

	mv -v ./bin/Cemu_release /usr/bin/cemu
	mkdir -p /usr/share/Cemu
	cp -r ./bin/* /usr/share/Cemu

	sed -i -e 's|Exec=Cemu|Exec=cemu|g' ./dist/linux/info.cemu.Cemu.desktop
	cp -v ./dist/linux/info.cemu.Cemu.desktop /usr/share/applications/Cemu.desktop
else
	echo "Making stable build of Cemu..."
	TARGET_V3_CPU=1 make-aur-package cemu
	pacman -Q cemu | awk '{print $2; exit}'  > ~/version
fi
