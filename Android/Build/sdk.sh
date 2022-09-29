#!/bin/bash -e

ARM32=false

export ANDROID_NDK="$(grep '^ndk\.dir' local.properties | sed 's/^.*=[[:space:]]*//')"

if [ ! -d $ANDROID_NDK ] ; then
	echo "Please specify path of ANDROID NDK"
	echo "e.g. $HOME/Android/android-ndk-r25"
	read ANDROID_NDK
	export ANDROID_NDK
fi

if [ ! -d $ANDROID_NDK ] ; then
	echo "$ANDROID_NDK is not a valid folder"
	exit 1
fi

echo "ndk.dir = $ANDROID_NDK" > local.properties

if $ARM32 ; then
	### toolchain config for ARMv7
	export TARGET_ABI=armeabi-v7a
	export ANDROID_ABI="$TARGET_ABI with NEON"
	export TARGET=armv7a-linux-androideabi
else
	### toolchain config for ARM64
	export TARGET_ABI=arm64-v8a
	export ANDROID_ABI=$TARGET_ABI
	export TARGET=aarch64-linux-android
fi

export API=21
export CFLAGS="-Ofast -fvisibility=hidden -fexceptions -D__ANDROID_MIN_SDK_VERSION__=$API"
export CXXFLAGS="$CFLAGS -frtti"
export NATIVE_API_LEVEL="android-$API"

echo "Configured for $TARGET_ABI"

case "$OSTYPE" in
	linux*)
		export TOOLCHAIN=$ANDROID_NDK/toolchains/llvm/prebuilt/linux-x86_64
		echo "Configured for Linux" ;;
	darwin*)
		export TOOLCHAIN=$ANDROID_NDK/toolchains/llvm/prebuilt/darwin-x86_64
		echo "Configured for Mac OS" ;;
  	*)
  		echo "Just use right OS instead $OSTYPE"
  		exit 1 ;;
esac

export CC=$TOOLCHAIN/bin/$TARGET$API-clang
export CXX=$TOOLCHAIN/bin/$TARGET$API-clang++
export LD=$TOOLCHAIN/bin/ld
export RANLIB=$TOOLCHAIN/bin/llvm-ranlib
export STRIP=$TOOLCHAIN/bin/llvm-strip
