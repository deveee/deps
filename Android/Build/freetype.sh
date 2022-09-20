#!/bin/bash -e

. sdk.sh
FREETYPE_VERSION=2.12.1

mkdir -p deps; cd deps

if [ ! -d libcurl-src ]; then
	wget https://download.savannah.gnu.org/releases/freetype/freetype-$FREETYPE_VERSION.tar.gz
	tar -xzvf freetype-$FREETYPE_VERSION.tar.gz
	mv freetype-$FREETYPE_VERSION freetype-src
	rm freetype-$FREETYPE_VERSION.tar.gz
	mkdir freetype-src/build
fi

cd freetype-src/build

cmake .. -DANDROID_STL="c++_static" -DANDROID_NATIVE_API_LEVEL="$NATIVE_API_LEVEL" \
	-DCMAKE_BUILD_TYPE=Release \
	-DBUILD_SHARED_LIBS=FALSE \
	-DFT_DISABLE_BZIP2=TRUE \
	-DFT_DISABLE_PNG=TRUE \
	-DFT_DISABLE_HARFBUZZ=TRUE \
	-DFT_DISABLE_BROTLI=TRUE \
	-DANDROID_ABI="$ANDROID_ABI" \
	-DANDROID_PLATFORM="$API" \
	-DCMAKE_C_FLAGS_RELEASE="$CFLAGS" \
	-DCMAKE_TOOLCHAIN_FILE="$ANDROID_NDK/build/cmake/android.toolchain.cmake"

cmake --build . -j

# update `include` folder
rm -rf ../../../../Freetype/include/
cp -r ../include ../../../../Freetype/include
rm -rf ../../../../Freetype/include/dlg
# update lib
rm -rf ../../../../Freetype/clang/$TARGET_ABI/libfreetype.a
cp -r libfreetype.a ../../../../Freetype/clang/$TARGET_ABI/libfreetype.a

echo "Freetype build successful"
