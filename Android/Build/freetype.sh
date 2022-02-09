#!/bin/bash -e

. sdk.sh
FREETYPE_VERSION=2.11.1

mkdir -p deps; cd deps

if [ ! -d libcurl-src ]; then
	wget https://download.savannah.gnu.org/releases/freetype/freetype-$FREETYPE_VERSION.tar.gz
	tar -xzvf freetype-$FREETYPE_VERSION.tar.gz
	mv freetype-$FREETYPE_VERSION freetype-src
	rm freetype-$FREETYPE_VERSION.tar.gz
fi

cd freetype-src

./configure --host=$TARGET CFLAGS="$CFLAGS -fPIC" CPPFLAGS="$CXXFLAGS -fPIC" \
	--prefix=/ --disable-shared --enable-static \
	--with-zlib=yes --with-brotli=no --with-bzip2=no --with-png=no --with-harfbuzz=no

make -j

# update `include` folder
rm -rf ../../../Freetype/include/
cp -r include ../../../Freetype/include
rm -rf ../../../Freetype/include/dlg
# update lib
rm -rf ../../../Freetype/clang/$TARGET_ABI/libfreetype.a
cp -r objs/.libs/libfreetype.a ../../../Freetype/clang/$TARGET_ABI/libfreetype.a

echo "Freetype build successful"
