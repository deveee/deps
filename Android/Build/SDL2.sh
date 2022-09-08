#!/bin/bash -e

. sdk.sh
SDL2_VERSION=2.24.0

mkdir -p deps; cd deps

if [ ! -d SDL2-src ]; then
	wget https://github.com/libsdl-org/SDL/archive/release-$SDL2_VERSION.tar.gz
	tar -xzvf release-$SDL2_VERSION.tar.gz
	mv SDL-release-$SDL2_VERSION SDL2-src
	rm release-$SDL2_VERSION.tar.gz
fi

cd SDL2-src

mkdir -p build; cd build

cmake .. -DANDROID_STL="c++_static" -DANDROID_NATIVE_API_LEVEL="$NATIVE_API_LEVEL" \
 -DCMAKE_BUILD_TYPE=Release \
 -DLIBTYPE=STATIC \
 -DANDROID_ABI="$ANDROID_ABI" \
 -DANDROID_PLATFORM="$API" \
 -DCMAKE_C_FLAGS="$CFLAGS" \
 -DCMAKE_CXX_FLAGS="$CXXFLAGS -fPIC" \
 -DCMAKE_TOOLCHAIN_FILE="$ANDROID_NDK/build/cmake/android.toolchain.cmake"

make -j

# update `include` folder
rm -rf ../../../../SDL2/include/
cp -r ../include ../../../../SDL2/include
# update lib
rm -rf ../../../../SDL2/clang/$TARGET_ABI/libSDL2.a
cp -r libSDL2.a ../../../../SDL2/clang/$TARGET_ABI/libSDL2.a

echo "SDL2 build successful"
