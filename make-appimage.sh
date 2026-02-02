#!/bin/sh

set -eu

ARCH=$(uname -m)
#VERSION=$(pacman -Q cemu | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook:x86-64-v3-check.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/128x128/apps/info.cemu.Cemu.png

if [ "${DEVEL_RELEASE-}" = 1 ]; then
  export DESKTOP=/usr/share/applications/info.cemu.Cemu.desktop
else
  export DESKTOP=/usr/share/applications/Cemu.desktop
fi

export DEPLOY_OPENGL=1
export DEPLOY_VULKAN=1
export DEPLOY_PIPEWIRE=1

# Deploy dependencies
if [ "${DEVEL_RELEASE-}" = 1 ]; then
  quick-sharun /usr/bin/Cemu
else
  quick-sharun /usr/bin/cemu
fi

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage
