<div align="center">

# Cemu-AppImage-Enhanced 🐧

[![GitHub Downloads](https://img.shields.io/github/downloads/pkgforge-dev/Cemu-AppImage-Enhanced/total?logo=github&label=GitHub%20Downloads)](https://github.com/pkgforge-dev/Cemu-AppImage-Enhanced/releases/latest)
[![CI Build Status](https://github.com//pkgforge-dev/Cemu-AppImage-Enhanced/actions/workflows/appimage.yml/badge.svg)](https://github.com/pkgforge-dev/Cemu-AppImage-Enhanced/releases/latest)
[![Latest Stable Release](https://img.shields.io/github/v/release/pkgforge-dev/Cemu-AppImage-Enhanced)](https://github.com/pkgforge-dev/Cemu-AppImage-Enhanced/releases/latest)

<p align="center">
  <img src="https://github.com/cemu-project/Cemu/blob/main/dist/linux/info.cemu.Cemu.png" width="128" />
</p>


| Latest Stable Release | Upstream URL |
| :---: | :---: |
| [Click here](https://github.com/pkgforge-dev/Cemu-AppImage-Enhanced/releases/latest) | [Click here](https://github.com/cemu-project/Cemu) |

Improved AppImage of cemu **independent of the host libc** which makes able to work on very very old distros as well as musl-libc distros like alpine linux. It is also **optimized for `x86-64-v3`** cpus giving a performance boost. 

</div>

---

AppImage made using [sharun](https://github.com/VHSgunzo/sharun) and its wrapper [quick-sharun](https://github.com/pkgforge-dev/Anylinux-AppImages/blob/main/useful-tools/quick-sharun.sh), which makes it extremely easy to turn any binary into a portable package reliably without using containers or similar tricks. 

**This AppImage bundles everything and it should work on any Linux distro, including old and musl-based ones.**

This AppImage doesn't require FUSE to run at all, thanks to the [uruntime](https://github.com/VHSgunzo/uruntime).

This AppImage is also supplied with a self-updater by default, so any updates to this application won't be missed, you will be prompted for permission to check for updates and if agreed you will then be notified when a new update is available.

Self-updater is disabled by default if AppImage managers like [am](https://github.com/ivan-hc/AM), [soar](https://github.com/pkgforge/soar) or [dbin](https://github.com/xplshn/dbin) exist, which manage AppImage updates.

<details>
  <summary><b><i>raison d'être</i></b></summary>
    <img src="https://github.com/user-attachments/assets/d40067a6-37d2-4784-927c-2c7f7cc6104b" alt="Inspiration Image">
  </a>
</details>

---

More at: [AnyLinux-AppImages](https://pkgforge-dev.github.io/Anylinux-AppImages/)
