#!/bin/bash -e

. sdk.sh
LEVELDB_VERSION=1.23

mkdir -p deps; cd deps

if [ ! -d leveldb-src ]; then
	wget https://github.com/google/leveldb/archive/refs/tags/$LEVELDB_VERSION.tar.gz
	tar -xzvf $LEVELDB_VERSION.tar.gz
	mv leveldb-$LEVELDB_VERSION leveldb-src
	rm $LEVELDB_VERSION.tar.gz
	mkdir leveldb-src/build
fi

cd leveldb-src/build

cmake .. -DANDROID_STL="c++_static" \
	-DANDROID_NATIVE_API_LEVEL="$NATIVE_API_LEVEL" \
	-DANDROID_ABI="$ANDROID_ABI" \
	-DANDROID_PLATFORM="$API" \
	-DBUILD_SHARED_LIBS=OFF \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_C_FLAGS="$CFLAGS" \
	-DCMAKE_CXX_FLAGS="$CXXFLAGS -fPIC" \
	-DCMAKE_TOOLCHAIN_FILE="$ANDROID_NDK/build/cmake/android.toolchain.cmake" \
	-DLEVELDB_BUILD_TESTS=OFF \
	-DLEVELDB_BUILD_BENCHMARKS=OFF \
	-DLEVELDB_INSTALL=OFF

cmake --build . -j

# update `include` folder
rm -rf ../../../../LevelDB/include/
cp -r ../include ../../../../LevelDB/include
# update lib
rm -rf ../../../../LevelDB/clang/$TARGET_ABI/libleveldb.a
cp -r libleveldb.a ../../../../LevelDB/clang/$TARGET_ABI/libleveldb.a

echo "LevelDB build successful"
