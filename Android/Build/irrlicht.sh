#!/bin/bash -e

. sdk.sh

export ANDR_ROOT=$(pwd)

mkdir -p deps; cd deps

[ ! -d irrlicht-src ] && \
    git clone --depth 1 -b SDL2 https://github.com/MoNTE48/Irrlicht irrlicht-src

cd irrlicht-src/source/Irrlicht/Android-SDL2

export SDL2_PATH=$"$ANDR_ROOT/../SDL2/"
$ANDROID_NDK/ndk-build -j \
    NDEBUG=1 \
    APP_PLATFORM=android-"$API" \
    TARGET_ABI="$TARGET_ABI" \
    APP_STL="c++_static" \
    NDK_APPLICATION_MK="$ANDR_ROOT/Irrlicht.mk" \
    COMPILER_VERSION="clang" \
    TARGET_CFLAGS_ADDON="${TARGET_CFLAGS_ADDON}" \
    TARGET_CPPFLAGS_ADDON="${TARGET_CXXFLAGS_ADDON}"

# update `include` folder
rm -rf ../../../../../../Irrlicht/include/
cp -r ../../../include ../../../../../../Irrlicht/include
# update lib
rm -rf ../../../../../../Irrlicht/clang/$TARGET_ABI/libIrrlicht.a
cp -r ../../../lib/Android-SDL2/$TARGET_ABI/libIrrlicht.a ../../../../../../Irrlicht/clang/$TARGET_ABI/libIrrlicht.a

echo "Irrlicht build successful"
