#!/bin/sh

set -eux
EXTRA_PACKAGES="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/get-debloated-pkgs.sh"

echo "Installing dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
	base-devel        \
	curl              \
	git               \
	libx11            \
	libxrandr         \
	libxss            \
	pipewire-audio    \
	pulseaudio        \
	pulseaudio-alsa   \
	wget              \
	xorg-server-xvfb  \
	zsync

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
wget --retry-connrefused --tries=30 "$EXTRA_PACKAGES" -O ./get-debloated-pkgs.sh
chmod +x ./get-debloated-pkgs.sh
./get-debloated-pkgs.sh --add-mesa gtk3-mini opus-mini libxml2-mini gdk-pixbuf2-mini


echo "Building cemu..."
echo "---------------------------------------------------------------"
git clone --depth 1 https://aur.archlinux.org/cemu.git ./cemu && (
	cd ./cemu
	sed -i -e "s|x86_64|$ARCH|" ./PKGBUILD
	makepkg -fs --noconfirm
	ls -la .
	pacman --noconfirm -U ./*.pkg.tar.*
)

pacman -Q cemu | awk '{print $2; exit}' > ~/version
