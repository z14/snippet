#!/bin/bash
#
# vim:ft=sh

############### Variables ###############

############### Functions ###############

############### Main Part ###############

sudo dnf install bluez-libs clang cmake cubeb-devel freeglut-devel git glm-devel gtk3-devel kernel-headers libgcrypt-devel libsecret-devel libtool libusb1-devel llvm nasm ninja-build perl-core systemd-devel zlib-devel zlib-static

sudo dnf install wayland-protocols-devel bluez-libs-devel pulseaudio-libs-devel


git clone --recursive https://github.com/cemu-project/Cemu
cd Cemu
cmake -S . -B build -DCMAKE_BUILD_TYPE=release -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ -G Ninja
cmake --build build
