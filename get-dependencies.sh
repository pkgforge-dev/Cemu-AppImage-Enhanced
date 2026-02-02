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
	vulkan-headers      \
	wayland-protocols   \
	zarchive

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common ! llvm

make-aur-package cubeb
make-aur-package sdl2
make-aur-package wxgtk-git

echo "Building Cemu..."
echo "---------------------------------------------------------------"
REPO="https://github.com/cemu-project/Cemu"
# Determine to build nightly or stable
if [ "${DEVEL_RELEASE-}" = 1 ]; then
	echo "Making nightly build of Cemu..."
	VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
    git clone --recursive "$REPO" ./Cemu
else
	echo "Making stable build of Cemu..."
	VERSION="$(git ls-remote --tags --sort="v:refname" https://github.com/cemu-project/Cemu | tail -n1 | sed 's/.*\///; s/\^{}//; s/^v//')"
	git clone --branch v"$VERSION" --single-branch --recursive "$REPO" ./Cemu
fi
echo "$VERSION" > ~/version

cd Cemu
mkdir -p build && cd build


if [ "$1" = 'v3' ] && [ "$ARCH" = 'x86_64' ]; then
	echo "Making x86-64-v3 optimized build of Cemu..."
	ARCH_FLAGS="-march=x86-64-v3 -O3"
fi

cmake .. -D ALLOW_PORTABLE=OFF \
	  -D CMAKE_BUILD_TYPE=Release \
	  -D CMAKE_C_COMPILER=clang \
	  -D CMAKE_CXX_COMPILER=clang++ \
	  -D CMAKE_EXE_LINKER_FLAGS="-lzstd" \
	  -D CMAKE_C_FLAGS_RELEASE="$ARCH_FLAGS -DNDEBUG" \
	  -D CMAKE_CXX_FLAGS_RELEASE="$ARCH_FLAGS -DNDEBUG" \
	  -D CMAKE_INTERPROCEDURAL_OPTIMIZATION=ON \
	  -D CMAKE_POLICY_VERSION_MINIMUM=3.5 \ # Required for stable
	  -D ENABLE_VCPKG=OFF \
	  $EXTRA_FLAGS \
	  -Wno-dev -B build
make -j $(nproc)

install -d /usr/bin /usr/share/Cemu
mv bin/Cemu_release /usr/bin/Cemu
cp -dr --no-preserve=ownership -t /usr/share/Cemu bin/*
install -Dm644 -t /usr/share/applications dist/linux/info.cemu.Cemu.desktop
install -Dm644 -t /usr/share/icons/hicolor/128x128/apps dist/linux/info.cemu.Cemu.png
install -Dm644 -t /usr/share/metainfo dist/linux/info.cemu.Cemu.metainfo.xml
