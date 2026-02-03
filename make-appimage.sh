#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook:x86-64-v3-check.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=https://raw.githubusercontent.com/cemu-project/Cemu/refs/heads/main/dist/linux/info.cemu.Cemu.png
export DESKTOP=/usr/share/applications/Cemu.desktop
export DEPLOY_OPENGL=1
export DEPLOY_VULKAN=1

# Deploy dependencies
quick-sharun /usr/bin/cemu

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage
