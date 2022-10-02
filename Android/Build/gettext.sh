#!/bin/bash -e

. sdk.sh
GETTEXT_VERSION=0.21

mkdir -p deps; cd deps

if [ ! -d gettext-src ]; then
	wget https://ftp.gnu.org/pub/gnu/gettext/gettext-$GETTEXT_VERSION.tar.gz
	tar -xzvf gettext-$GETTEXT_VERSION.tar.gz
	mv gettext-$GETTEXT_VERSION gettext-src
	rm gettext-$GETTEXT_VERSION.tar.gz
fi

cd gettext-src/gettext-runtime

./configure --host=$TARGET CFLAGS="$CFLAGS" CPPFLAGS="$CXXFLAGS" \
	--prefix=/ --disable-shared --enable-static \
	--disable-libasprintf

make -j

# update `include` folder
rm -rf ../../../../Gettext/include/libintl.h
cp -r intl/libintl.h ../../../../Gettext/include
# update lib
rm -rf ../../../../Gettext/clang/$TARGET_ABI/libintl.a
cp -r intl/.libs/libintl.a ../../../../Gettext/clang/$TARGET_ABI/libintl.a

echo "Gettext build successful"
