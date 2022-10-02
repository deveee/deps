#!/bin/bash -e

. sdk.sh

export ANDR_ROOT=$(pwd)

mkdir -p deps; cd deps

if [ ! -d vorbis-src ]; then
	git clone https://github.com/MoNTE48/libvorbis-android vorbis-src
fi

cd vorbis-src

$ANDROID_NDK/ndk-build \
	APP_PLATFORM=android-"$API" \
	TARGET_ABI="$TARGET_ABI" \
	NDK_APPLICATION_MK="$ANDR_ROOT/Deps.mk"

# update `include` folder
rm -rf ../../../Vorbis/include/
cp -r jni/include ../../../Vorbis/include
rm -rf ../../../Vorbis/include/dlg
# update lib
rm -rf ../../../Vorbis/clang/$TARGET_ABI/libfreetype.a
cp -r obj/local/$TARGET_ABI/libvorbis.a ../../../Vorbis/clang/$TARGET_ABI/libvorbis.a

echo "Vorbis build successful"
