#!/bin/bash -e

. sdk.sh
OPENAL_VERSION=1.22.2

mkdir -p deps; cd deps

if [ ! -d openal-src ]; then
	wget https://github.com/kcat/openal-soft/archive/$OPENAL_VERSION.tar.gz
	tar -xzvf $OPENAL_VERSION.tar.gz
	mv openal-soft-$OPENAL_VERSION openal-src
	rm $OPENAL_VERSION.tar.gz
fi

cd openal-src/build

cmake .. -DANDROID_LD=lld -DANDROID_STL="c++_static" -DANDROID_NATIVE_API_LEVEL="$NATIVE_API_LEVEL" \
 -DCMAKE_BUILD_TYPE=Release \
 -DLIBTYPE=STATIC \
 -DANDROID_ABI="$ANDROID_ABI" \
 -DANDROID_PLATFORM="$API" \
 -DALSOFT_UTILS=NO \
 -DALSOFT_EXAMPLES=NO \
 -DALSOFT_EMBED_HRTF_DATA=NO \
 -DALSOFT_BACKEND_WAVE=NO \
 -DALSOFT_UPDATE_BUILD_VERSION=NO \
 -DCMAKE_C_FLAGS="$CFLAGS" \
 -DCMAKE_CXX_FLAGS="$CXXFLAGS -fPIC" \
 -DCMAKE_TOOLCHAIN_FILE="$ANDROID_NDK/build/cmake/android.toolchain.cmake"

make -j

# update `include` folder
rm -rf ../../../../OpenAL-Soft/include/
cp -r ../include ../../../../OpenAL-Soft/include
# update lib
rm -rf ../../../../OpenAL-Soft/clang/$TARGET_ABI/libopenal.a
cp -r libopenal.a ../../../../OpenAL-Soft/clang/$TARGET_ABI/libopenal.a

echo "OpenAL-Soft build successful"
