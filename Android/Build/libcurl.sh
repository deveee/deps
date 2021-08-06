#!/bin/bash -e

. sdk.sh
CURL_VERSION=7.78.0

mkdir -p deps; cd deps

if [ ! -d libcurl-src ]; then
	wget https://curl.haxx.se/download/curl-$CURL_VERSION.tar.gz
	tar -xzvf curl-$CURL_VERSION.tar.gz
	mv curl-$CURL_VERSION libcurl-src
	rm curl-$CURL_VERSION.tar.gz
fi

cd libcurl-src

./configure --host=$TARGET CFLAGS="$CFLAGS" CPPFLAGS="$CXXFLAGS" \
	--prefix=/ --disable-shared --enable-static \
	--disable-debug --disable-verbose --disable-versioned-symbols \
	--enable-hidden-symbols --disable-dependency-tracking \
	--disable-ares --disable-cookies --disable-crypto-auth --disable-manual \
	--disable-proxy --disable-unix-sockets --without-libidn --without-librtmp \
	--without-ssl --disable-ftp --disable-ldap --disable-ldaps --disable-rtsp \
	--disable-dict --disable-telnet --disable-tftp --disable-pop3 \
	--disable-imap --disable-smtp --disable-gopher --disable-sspi \
	--disable-libcurl-option

make -j

# update `include` folder
rm -rf ../../../Curl/include/
cp -r include ../../../Curl/include
# update lib
rm -rf ../../../Curl/clang_nossl/$TARGET_ABI/libcurl.a
cp -r lib/.libs/libcurl.a ../../../Curl/clang_nossl/$TARGET_ABI/libcurl.a

echo "libcurl build successful"
