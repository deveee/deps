######################################################################################
# toolchain config for ARMv7 (Clang)
######################################################################################

#API = 21
#TARGET_HOST = arm-linux
#TARGET_ABI = armeabi-v7a
#TARGET_ARCH = arm
#TARGET_TOOLCHAIN = arm-linux-androideabi
#TARGET_CFLAGS_ADDON = -Ofast -fvisibility=hidden -fexceptions -D__ANDROID_MIN_SDK_VERSION__=$(API)
#TARGET_CXXFLAGS_ADDON = $(TARGET_CFLAGS_ADDON) -frtti
#CROSS_PREFIX = arm-linux-androideabi
#HOST_CC = "gcc -m32" # required for LuaJIT

######################################################################################
# toolchain config for ARM64 (Clang)
######################################################################################

API = 21
TARGET_HOST = arm-linux
TARGET_ABI = arm64-v8a
TARGET_ARCH = arm64
TARGET_TOOLCHAIN = aarch64-linux-android
TARGET_CFLAGS_ADDON = -Ofast -fvisibility=hidden -fexceptions -D__ANDROID_MIN_SDK_VERSION__=$(API)
TARGET_CXXFLAGS_ADDON = $(TARGET_CFLAGS_ADDON) -frtti
CROSS_PREFIX = aarch64-linux-android
HOST_CC = "gcc -m64" # required for LuaJIT

######################################################################################
# toolchain config for x86 (clang)
######################################################################################

#API = 16
#TARGET_HOST = x86-linux
#TARGET_ABI = x86
#TARGET_ARCH = x86
#TARGET_TOOLCHAIN = x86
#TARGET_CFLAGS_ADDON = -march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32 -Ofast -funroll-loops -fdata-sections -ffunction-sections -fvisibility=hidden -fexceptions -D__ANDROID_MIN_SDK_VERSION__=$(API)
#TARGET_CXXFLAGS_ADDON = $(TARGET_CFLAGS_ADDON) -frtti
#CROSS_PREFIX = i686-linux-android
#HOST_CC = "gcc -m32" # required for LuaJIT

######################################################################################
# general toolchain config
######################################################################################

CROSS_CC = clang
CROSS_CXX = clang++
COMPILER_VERSION = clang
APP_STL = c++_static
APP_STL_LIB = libc++

######################################################################################

SHELL := /bin/bash
ANDR_ROOT = $(shell pwd)

SDL2_BRANCH = release-2.24.0
SDL2_DIR = $(ANDR_ROOT)/deps/SDL2
SDL2_LIB = $(SDL2_DIR)/libs/$(TARGET_ABI)/libSDL2.a
SDL2_TIMESTAMP = $(SDL2_DIR)/timestamp
SDL2_TIMESTAMP_INT = $(ANDR_ROOT)/deps/SDL2_timestamp
SDL2_URL_HTTP = https://github.com/libsdl-org/SDL/archive/$(SDL2_BRANCH).zip

IRRLICHT_BRANCH = ogl-es
IRRLICHT_DIR = $(ANDR_ROOT)/deps/irrlicht
IRRLICHT_LIB = $(IRRLICHT_DIR)/lib/Android/libIrrlicht.a
IRRLICHT_TIMESTAMP = $(IRRLICHT_DIR)/timestamp
IRRLICHT_TIMESTAMP_INT = $(ANDR_ROOT)/deps/irrlicht_timestamp
IRRLICHT_URL_HTTP = https://github.com/MoNTE48/Irrlicht/archive/$(IRRLICHT_BRANCH).zip

MBEDTLS_VERSION = 3.1.0
MBEDTLS_DIR = $(ANDR_ROOT)/deps/mbedtls
MBEDTLS_LIB = $(MBEDTLS_DIR)/libmbedtls.a
MBEDTLS_TIMESTAMP = $(MBEDTLS_DIR)/timestamp
MBEDTLS_TIMESTAMP_INT = $(ANDR_ROOT)/deps/mbedtls_timestamp
MBEDTLS_URL = https://github.com/ARMmbed/mbedtls/archive/mbedtls-$(MBEDTLS_VERSION).tar.gz

CURL_VERSION = 7.84.0
CURL_DIR = $(ANDR_ROOT)/deps/curl
CURL_LIB = $(CURL_DIR)/lib/.libs/libcurl.a
CURL_TIMESTAMP = $(CURL_DIR)/timestamp
CURL_TIMESTAMP_INT = $(ANDR_ROOT)/deps/curl_timestamp
CURL_URL_HTTP = https://curl.se/download/curl-$(CURL_VERSION).tar.bz2

ICONV_VERSION = 1.16
ICONV_DIR = $(ANDR_ROOT)/deps/libiconv
ICONV_URL_HTTP = https://ftp.gnu.org/pub/gnu/libiconv/libiconv-$(ICONV_VERSION).tar.gz

LUAJIT_VERSION = 2.1
LUAJIT_DIR = $(ANDR_ROOT)/deps/luajit
LUAJIT_LIB = $(LUAJIT_DIR)/src/libluajit.a
LUAJIT_TIMESTAMP = $(LUAJIT_DIR)/timestamp
LUAJIT_TIMESTAMP_INT = $(ANDR_ROOT)/deps/luajit_timestamp
LUAJIT_URL_HTTP = https://github.com/LuaJIT/LuaJIT/archive/v$(LUAJIT_VERSION).zip

GETTEXT_VERSION = 0.21
GETTEXT_DIR = $(ANDR_ROOT)/deps/gettext
GETTEXT_LIB = $(GETTEXT_DIR)/out-static/libgettext.a
GETTEXT_TIMESTAMP = $(GETTEXT_DIR)/timestamp
GETTEXT_TIMESTAMP_INT = $(ANDR_ROOT)/deps/gettext_timestamp
GETTEXT_URL = https://ftp.gnu.org/pub/gnu/gettext/gettext-$(GETTEXT_VERSION).tar.gz
######################################################################################

NDK_VER = 23.2.8568313

ANDROID_NDK = $(shell grep '^ndk\.dir' local.properties | sed 's/^.*=[[:space:]]*//')

release : local.properties
	$(MAKE) deps

local.properties:
	@if [ -d ${ANDROID_SDK_ROOT}/ndk/${NDK_VER} ] ; then				\
		export ANDROID_NDK=${ANDROID_SDK_ROOT}/ndk/${NDK_VER};			\
	else																\
		echo "Please specify path of ANDROID NDK";						\
		echo "e.g. $$HOME/Android/android-ndk-r21";						\
		read ANDROID_NDK ;												\
	fi;																	\
	if [ ! -d $$ANDROID_NDK ] ; then									\
		echo "$$ANDROID_NDK is not a valid folder";						\
		exit 1;															\
	fi;																	\
	echo "ndk.dir = $$ANDROID_NDK" > local.properties

iconv_download :
	@if [ ! -d ${ICONV_DIR} ] ; then									\
		echo "iconv sources missing, downloading...";					\
		mkdir -p ${ANDR_ROOT}/deps;										\
		cd ${ANDR_ROOT}/deps;											\
		wget ${ICONV_URL_HTTP} || exit 1;								\
		tar -xzf libiconv-${ICONV_VERSION}.tar.gz || exit 1;			\
		$(RM) -r libiconv-${ICONV_VERSION}.tar.gz;						\
		mv libiconv-${ICONV_VERSION} libiconv;							\
		cd libiconv;													\
		export TOOLCHAIN=${ICONV_DIR}/TOOLCHAIN;						\
		${ANDROID_NDK}/build/tools/make_standalone_toolchain.py			\
			--arch ${TARGET_ARCH}										\
			--api ${API}												\
			--stl=${APP_STL_LIB}										\
			--install-dir=$${TOOLCHAIN};								\
		./configure || exit 1;											\
	fi

clean_iconv :
	$(RM) -r ${ICONV_DIR}

SDL2_download :
	@if [ ! -d ${SDL2_DIR} ] ; then										\
		echo "SDL2 sources missing, downloading...";					\
		mkdir -p ${ANDR_ROOT}/deps;										\
		cd deps;														\
		wget ${SDL2_URL_HTTP} || exit 1;								\
		unzip -q ${SDL2_BRANCH}.zip || exit 1;							\
		$(RM) -r ${SDL2_BRANCH}.zip;									\
		mv SDL-${SDL2_BRANCH} SDL2;										\
	fi

$(SDL2_TIMESTAMP) : SDL2_download
	@LAST_MODIF=$$(find ${SDL2_DIR} -type f -printf '%T@ %p\n' | sort -n | tail -1 | cut -f2- -d" ");\
	if [ $$(basename $$LAST_MODIF) != "timestamp" ] ; then				\
		touch ${SDL2_TIMESTAMP};										\
	fi

SDL2 : $(SDL2_LIB)

$(SDL2_LIB): $(SDL2_TIMESTAMP)
	+@REFRESH=0;														\
	if [ ! -e ${SDL2_TIMESTAMP_INT} ] ; then							\
		REFRESH=1;														\
	fi;																	\
	if [ ! -e ${SDL2_LIB} ] ; then										\
		REFRESH=1;														\
	fi;																	\
	if [ ${SDL2_TIMESTAMP} -nt ${SDL2_TIMESTAMP_INT} ] ; then			\
		REFRESH=1;														\
	fi;																	\
	if [ $$REFRESH -ne 0 ] ; then										\
	echo "changed timestamp for SDL2 detected building...";				\
	cd ${SDL2_DIR};														\
	export APP_PLATFORM=android-${API};									\
	export TARGET_ABI=${TARGET_ABI};									\
	export NDK_PROJECT_PATH=${SDL2_DIR};								\
	${ANDROID_NDK}/ndk-build											\
		APP_PLATFORM=android-${API}										\
		TARGET_ABI=${TARGET_ABI}										\
		APP_STL=${APP_STL}												\
		COMPILER_VERSION=${COMPILER_VERSION}							\
		TARGET_CPPFLAGS_ADDON="${TARGET_CXXFLAGS_ADDON}"				\
		TARGET_CFLAGS_ADDON="${TARGET_CFLAGS_ADDON}"					\
		APP_BUILD_SCRIPT=${SDL2_DIR}/Android.mk							\
		NDK_APPLICATION_MK=${ANDR_ROOT}/Deps.mk || exit 1;				\
	touch ${SDL2_TIMESTAMP};											\
	touch ${SDL2_TIMESTAMP_INT};										\
	else																\
		echo "nothing to be done for SDL2";								\
	fi

clean_SDL2 :
	$(RM) -r ${SDL2_DIR}

irrlicht_download :
	@if [ ! -d ${IRRLICHT_DIR} ] ; then									\
		echo "irrlicht sources missing, downloading...";				\
		mkdir -p ${ANDR_ROOT}/deps;										\
		cd deps;														\
		wget ${IRRLICHT_URL_HTTP} || exit 1;							\
		unzip -q ${IRRLICHT_BRANCH}.zip || exit 1;						\
		$(RM) -r ${IRRLICHT_BRANCH}.zip;								\
		mv Irrlicht-${IRRLICHT_BRANCH} irrlicht;						\
		cd irrlicht;													\
		mkdir -p lib/Android;											\
	fi

$(IRRLICHT_TIMESTAMP) : irrlicht_download
	@LAST_MODIF=$$(find ${IRRLICHT_DIR} -type f -printf '%T@ %p\n' | sort -n | tail -1 | cut -f2- -d" ");\
	if [ $$(basename $$LAST_MODIF) != "timestamp" ] ; then				\
		touch ${IRRLICHT_TIMESTAMP};									\
	fi

irrlicht : $(IRRLICHT_LIB)

$(IRRLICHT_LIB): $(IRRLICHT_TIMESTAMP)
	+@REFRESH=0;														\
	if [ ! -e ${IRRLICHT_TIMESTAMP_INT} ] ; then						\
		REFRESH=1;														\
	fi;																	\
	if [ ! -e ${IRRLICHT_LIB} ] ; then									\
		REFRESH=1;														\
	fi;																	\
	if [ ${IRRLICHT_TIMESTAMP} -nt ${IRRLICHT_TIMESTAMP_INT} ] ; then	\
		REFRESH=1;														\
	fi;																	\
	if [ $$REFRESH -ne 0 ] ; then										\
	echo "changed timestamp for irrlicht detected building...";			\
	cd ${IRRLICHT_DIR}/source/Irrlicht/Android;							\
	export APP_PLATFORM=android-${API};									\
	export TARGET_ABI=${TARGET_ABI};									\
	${ANDROID_NDK}/ndk-build											\
		NDEBUG=1														\
		APP_PLATFORM=android-${API}										\
		TARGET_ABI=${TARGET_ABI}										\
		APP_STL=${APP_STL}												\
		COMPILER_VERSION=${COMPILER_VERSION}							\
		TARGET_CPPFLAGS_ADDON="${TARGET_CXXFLAGS_ADDON}"				\
		TARGET_CFLAGS_ADDON="${TARGET_CFLAGS_ADDON}"					\
		NDK_APPLICATION_MK=${ANDR_ROOT}/Irrlicht.mk || exit 1;			\
	touch ${IRRLICHT_TIMESTAMP};										\
	touch ${IRRLICHT_TIMESTAMP_INT};									\
	else																\
		echo "nothing to be done for irrlicht";							\
	fi

clean_irrlicht :
	$(RM) -r ${IRRLICHT_DIR}

$(MBEDTLS_TIMESTAMP) : mbedtls_download
	@LAST_MODIF=$$(find ${MBEDTLS_DIR} -type f -printf '%T@ %p\n' | sort -n | tail -1 | cut -f2- -d" ");\
	if [ $$(basename $$LAST_MODIF) != "timestamp" ] ; then				\
		touch ${MBEDTLS_TIMESTAMP};										\
	fi

mbedtls_download :
	@if [ ! -d ${MBEDTLS_DIR} ] ; then									\
		echo "mbedtls sources missing, downloading...";					\
		mkdir -p ${ANDR_ROOT}/deps;										\
		cd ${ANDR_ROOT}/deps;											\
		wget ${MBEDTLS_URL} || exit 1;									\
		mkdir -p mbedtls;												\
		tar -xzf mbedtls-${MBEDTLS_VERSION}.tar.gz -C mbedtls --strip=1;\
		$(RM) -r mbedtls-${MBEDTLS_VERSION}.tar.gz;						\
	fi

mbedtls : $(MBEDTLS_LIB)

$(MBEDTLS_LIB): $(MBEDTLS_TIMESTAMP)
	@REFRESH=0;															\
	if [ ! -e ${MBEDTLS_TIMESTAMP_INT} ] ; then							\
		echo "${MBEDTLS_TIMESTAMP_INT} doesn't exist";					\
		REFRESH=1;														\
	fi;																	\
	if [ ${MBEDTLS_TIMESTAMP} -nt ${MBEDTLS_TIMESTAMP_INT} ]; then		\
		REFRESH=1;														\
	fi;																	\
	if [ $$REFRESH -ne 0 ] ; then										\
	export PATH=$$PATH:${ANDROID_NDK};									\
	echo "changed timestamp for mbedtls detected building...";			\
	cd ${MBEDTLS_DIR};													\
	export TOOLCHAIN=${MBEDTLS_DIR}/TOOLCHAIN;							\
	${ANDROID_NDK}/build/tools/make_standalone_toolchain.py				\
		--arch ${TARGET_ARCH}											\
		--api ${API}													\
		--stl=${APP_STL_LIB}											\
		--install-dir=$${TOOLCHAIN};									\
	export PATH="$${TOOLCHAIN}/bin:$${PATH}";							\
	export CC=${CROSS_CC};												\
	export TARGET_FLAGS="${TARGET_CFLAGS_ADDON}";						\
	export CFLAGS="$${CFLAGS} ${TARGET_CFLAGS_ADDON}";					\
	export CPPFLAGS="$${CPPFLAGS} ${TARGET_CXXFLAGS_ADDON}";			\
	$(MAKE) library -s;													\
	$(MAKE) install DESTDIR=build -s || exit 1;							\
	touch ${MBEDTLS_TIMESTAMP};											\
	touch ${MBEDTLS_TIMESTAMP_INT};										\
	$(RM) -r $${TOOLCHAIN};												\
	else																\
		echo "nothing to be done for mbedtls";							\
	fi

clean_mbedtls :
	$(RM) -r ${MBEDTLS_DIR}

$(CURL_TIMESTAMP) : curl_download
	@LAST_MODIF=$$(find ${CURL_DIR} -type f -printf '%T@ %p\n' | sort -n | tail -1 | cut -f2- -d" ");\
	if [ $$(basename $$LAST_MODIF) != "timestamp" ] ; then				\
		touch ${CURL_TIMESTAMP};										\
	fi

curl_download :
	@if [ ! -d ${CURL_DIR} ] ; then										\
		echo "curl sources missing, downloading...";					\
		mkdir -p ${ANDR_ROOT}/deps;										\
		cd deps;														\
		wget ${CURL_URL_HTTP} || exit 1;								\
		tar -xjf curl-${CURL_VERSION}.tar.bz2 || exit 1;				\
		$(RM) -r curl-${CURL_VERSION}.tar.bz2;							\
		mv curl-${CURL_VERSION} curl;									\
	fi

curl : $(CURL_LIB)

$(CURL_LIB) : $(CURL_TIMESTAMP) $(MBEDTLS_LIB)
	@REFRESH=0;															\
	if [ ! -e ${CURL_TIMESTAMP_INT} ] ; then							\
		REFRESH=1;														\
	fi;																	\
	if [ ! -e ${CURL_LIB} ] ; then										\
		REFRESH=1;														\
	fi;																	\
	if [ ${CURL_TIMESTAMP} -nt ${CURL_TIMESTAMP_INT} ] ; then			\
		REFRESH=1;														\
	fi;																	\
	if [ $$REFRESH -ne 0 ] ; then										\
	echo "changed timestamp for curl detected building...";				\
	cd ${CURL_DIR};														\
	export TOOLCHAIN=${CURL_DIR}/TOOLCHAIN;								\
	${ANDROID_NDK}/build/tools/make_standalone_toolchain.py				\
		--arch ${TARGET_ARCH}											\
		--api ${API}													\
		--stl=${APP_STL_LIB}											\
		--install-dir=$${TOOLCHAIN};									\
	export PATH="$${TOOLCHAIN}/bin:$${PATH}";							\
	export TARGET_OS=OS_ANDROID_CROSSCOMPILE;							\
	export CC=${CROSS_CC};												\
	export CPPFLAGS="$${CPPFLAGS} -I${MBEDTLS_DIR}/build/include ${TARGET_CXXFLAGS_ADDON}";\
	export CFLAGS="$${CFLAGS} -I${MBEDTLS_DIR}/build/include ${TARGET_CFLAGS_ADDON}";\
	./configure --host=${TARGET_TOOLCHAIN}								\
		--with-mbedtls=${MBEDTLS_DIR}/build								\
		--disable-shared --enable-static --disable-debug				\
		--disable-verbose --disable-versioned-symbols					\
		--enable-hidden-symbols --disable-dependency-tracking			\
		--disable-proxy --disable-cookies --disable-crypto-auth			\
		--disable-manual --disable-ares --disable-ftp					\
		--disable-unix-sockets --without-libidn --without-librtmp		\
		--without-ssl --disable-sspi --disable-ldap --disable-ldaps		\
		--disable-rtsp --disable-dict --disable-telnet --disable-tftp	\
		--disable-pop3 --disable-imap --disable-smtp --disable-gopher	\
		--disable-libcurl-option;										\
	$(MAKE) -s || exit 1;												\
	touch ${CURL_TIMESTAMP};											\
	touch ${CURL_TIMESTAMP_INT};										\
	$(RM) -r $${TOOLCHAIN};												\
	else																\
		echo "nothing to be done for curl";								\
	fi

clean_curl :
	$(RM) -r ${CURL_DIR}

$(LUAJIT_TIMESTAMP) : luajit_download
	@LAST_MODIF=$$(find ${LUAJIT_DIR} -type f -printf '%T@ %p\n' | sort -n | tail -1 | cut -f2- -d" ");\
	if [ $$(basename $$LAST_MODIF) != "timestamp" ] ; then				\
		touch ${LUAJIT_TIMESTAMP};										\
	fi

luajit_download :
	@if [ ! -d ${LUAJIT_DIR} ] ; then									\
		echo "luajit sources missing, downloading...";					\
		mkdir -p ${ANDR_ROOT}/deps;										\
		cd ${ANDR_ROOT}/deps;											\
		wget ${LUAJIT_URL_HTTP} || exit 1;								\
		unzip -q v${LUAJIT_VERSION}.zip || exit 1;						\
		$(RM) -r v${LUAJIT_VERSION}.zip;								\
		mv LuaJIT-${LUAJIT_VERSION} luajit;								\
	fi

luajit : $(LUAJIT_LIB)

$(LUAJIT_LIB) : $(LUAJIT_TIMESTAMP)
	@REFRESH=0;															\
	if [ ! -e ${LUAJIT_TIMESTAMP_INT} ] ; then							\
		REFRESH=1;														\
	fi;																	\
	if [ ${LUAJIT_TIMESTAMP} -nt ${LUAJIT_TIMESTAMP_INT} ] ; then		\
		REFRESH=1;														\
	fi;																	\
	if [ $$REFRESH -ne 0 ] ; then										\
	export PATH=$$PATH:${ANDROID_NDK};									\
	echo "changed timestamp for luajit detected building...";			\
	cd ${LUAJIT_DIR};													\
	export TOOLCHAIN=${LUAJIT_DIR}/TOOLCHAIN;							\
	${ANDROID_NDK}/build/tools/make_standalone_toolchain.py				\
		--arch ${TARGET_ARCH}											\
		--api ${API}													\
		--stl=${APP_STL_LIB}											\
		--install-dir=$${TOOLCHAIN};									\
	export PATH="$${TOOLCHAIN}/bin:$${PATH}";							\
	export TARGET_FLAGS="${TARGET_CFLAGS_ADDON} -fno-fast-math";		\
	$(MAKE) -s amalg CROSS=${CROSS_PREFIX}- TARGET_CC=${CROSS_PREFIX}-clang	\
	XCFLAGS="-DLUAJIT_DISABLE_FFI" HOST_CC=${HOST_CC} BUILDMODE=static;	\
	touch ${LUAJIT_TIMESTAMP};											\
	touch ${LUAJIT_TIMESTAMP_INT};										\
	$(RM) -r $${TOOLCHAIN};												\
	else																\
		echo "nothing to be done for luajit";							\
	fi

clean_luajit :
	$(RM) -r ${LUAJIT_DIR}

$(GETTEXT_TIMESTAMP) : gettext_download
	@LAST_MODIF=$$(find ${GETTEXT_DIR} -type f -printf '%T@ %p\n' | sort -n | tail -1 | cut -f2- -d" ");\
	if [ $$(basename $$LAST_MODIF) != "timestamp" ] ; then				\
		touch ${GETTEXT_TIMESTAMP};										\
	fi

gettext_download :
	@if [ ! -d ${GETTEXT_DIR} ] ; then									\
		echo "gettext sources missing, downloading...";					\
		mkdir -p ${ANDR_ROOT}/deps;										\
		cd ${ANDR_ROOT}/deps ;											\
		wget ${GETTEXT_URL} || exit 1;									\
		tar zxf gettext-${GETTEXT_VERSION}.tar.gz || exit 1;			\
		$(RM) -r gettext-${GETTEXT_VERSION}.tar.gz || exit 1;			\
		mv gettext-${GETTEXT_VERSION} gettext || exit 1;				\
	fi

gettext : $(GETTEXT_LIB)
$(GETTEXT_LIB): $(GETTEXT_TIMESTAMP)
	@REFRESH=0;															\
	if [ ! -e ${GETTEXT_TIMESTAMP_INT} ] ; then							\
		REFRESH=1;														\
	fi;																	\
	if [ ${GETTEXT_TIMESTAMP} -nt ${GETTEXT_TIMESTAMP_INT} ] ; then		\
		REFRESH=1;														\
	fi;																	\
	if [ $$REFRESH -ne 0 ] ; then										\
	echo "changed timestamp for gettext detected building...";			\
	cd ${GETTEXT_DIR}/gettext-runtime;									\
	export TOOLCHAIN=${GETTEXT_DIR}/TOOLCHAIN;							\
	${ANDROID_NDK}/build/tools/make_standalone_toolchain.py				\
		--arch ${TARGET_ARCH}											\
		--api ${API}													\
		--stl=${APP_STL_LIB}											\
		--install-dir=$${TOOLCHAIN};									\
	export PATH="$${TOOLCHAIN}/bin:$${PATH}";							\
	export TARGET_OS=OS_ANDROID_CROSSCOMPILE;							\
	export CFLAGS="$${CFLAGS} ${TARGET_CFLAGS_ADDON}";					\
	export CPPFLAGS="$${CPPFLAGS} ${TARGET_CXXFLAGS_ADDON} -fPIC";		\
	CC=${CROSS_CC} ./configure --host=${TARGET_TOOLCHAIN}				\
		--enable-static --disable-shared || exit 1;						\
	CC=${CROSS_CC} ANDROID_DEV=$${TOOLCHAIN}							\
	$(MAKE) -s || exit 1;												\
	$(MAKE) DESTDIR=${GETTEXT_DIR}/build -s install|| exit 1;			\
	touch ${GETTEXT_TIMESTAMP};											\
	touch ${GETTEXT_TIMESTAMP_INT};										\
	$(RM) -r $${TOOLCHAIN};												\
	else																\
		echo "nothing to be done for gettext";							\
	fi

clean_getttext :
	$(RM) -r ${GETTEXT_DIR}

deps : $(SDL2_LIB) $(IRRLICHT_LIB) $(CURL_LIB) $(LUAJIT_LIB) \
	$(MBEDTLS_LIB) iconv_download

clean_all :
	$(RM) -r deps
