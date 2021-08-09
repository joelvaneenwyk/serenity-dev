#!/bin/bash

SERENITY_DEV_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
SERENITY_SOURCE_DIR="$SERENITY_DEV_DIR/serenity"
TARGET=x86_64

echo "Serenity Development Root: '$SERENITY_DEV_DIR'"
echo "Serenity Source: '$SERENITY_SOURCE_DIR'"

DEBIAN_FRONTEND="noninteractive" sudo apt-get install -y --allow-downgrades \
    build-essential cmake curl libmpfr-dev libmpc-dev libgmp-dev \
    e2fsprogs ninja-build qemu-system-i386 qemu-utils ccache rsync \
    clang-format-11 libssl1.1=1.1.1f-1ubuntu2

DEBIAN_FRONTEND="noninteractive" sudo apt-get install -y \
    nodejs npm

sudo npm install -g prettier@2.2.1
sudo npm install -g npm@7.20.5

python3 -m pip install --upgrade pip
pip3 install flake8 requests

exit

# Add the git commit hooks
pre-commit install

sudo update-alternatives --remove-all gcc
sudo update-alternatives --remove-all g++

sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 10
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 10
sudo update-alternatives --install /usr/bin/cc cc /usr/bin/gcc 30
sudo update-alternatives --set cc /usr/bin/gcc

sudo update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++ 30
sudo update-alternatives --set c++ /usr/bin/g++
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 10
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 10
sudo update-alternatives --install /usr/bin/cc cc /usr/bin/gcc 30
sudo update-alternatives --set cc /usr/bin/gcc

sudo update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++ 30
sudo update-alternatives --set c++ /usr/bin/g++

ln --force serenity/.prettierignore .prettierignore
ln --force serenity/.prettierrc .prettierrc

# This is technically superfluous since the build command below already builds the toolchain, but it
# should be mostly a no-op the second time and this is good reference for how to build it manually
# if needed.
(cd "$SERENITY_SOURCE_DIR/Toolchain" && ARCH="$TARGET" ./BuildIt.sh)

# Intentionally not doing a full 'rebuild-toolchain' as it is time consuming and not really necessary
(cd "$SERENITY_SOURCE_DIR" && "Meta/serenity.sh" build "$TARGET")
