#!/bin/bash -e

. sdk.sh
LUAJIT_VERSION=2.1

export ANDR_ROOT=$(pwd)

mkdir -p deps; cd deps

if [ ! -d luajit-src ]; then
	wget https://github.com/LuaJIT/LuaJIT/archive/v$LUAJIT_VERSION.tar.gz
	tar -xzvf v$LUAJIT_VERSION.tar.gz
	mv LuaJIT-$LUAJIT_VERSION luajit-src
	rm v$LUAJIT_VERSION.tar.gz
fi

cd luajit-src

if $ARM32 ; then
	HOST_CC="clang -m32"
else
	HOST_CC="clang"
fi

make -j HOST_CC="$HOST_CC" \
        CC="$CC" \
        TARGET_STRIP="$STRIP" \
        TARGET_AR="$TOOLCHAIN/bin/llvm-ar rcus" \
        TARGET_FLAGS="$CFLAGS -fno-fast-math" \
        BUILDMODE=static

# update `src` folder
rm -rf ../../../LuaJIT/src/*
cp src/*.h ../../../LuaJIT/src
# update lib
rm -rf ../../../LuaJIT/clang/$TARGET_ABI/libluajit.a
cp -r src/libluajit.a ../../../LuaJIT/clang/$TARGET_ABI/

echo "luajit build successful"
