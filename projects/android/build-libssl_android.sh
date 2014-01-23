#!/bin/sh

#Note [TBD] : There is no check for ndk-version
#Please use the ndk-version as per host machine for now

#Get the machine type
PROCTYPE=`uname -m`

if [ "$PROCTYPE" = "i686" ] || [ "$PROCTYPE" = "i386" ] || [ "$PROCTYPE" = "i586" ] ; then
        echo "Host machine : x86"
        ARCHTYPE="x86"
else
        echo "Host machine : x86_64"
        ARCHTYPE="x86_64"
fi

#Get the Host OS
HOST_OS=`uname -s`
case "$HOST_OS" in
    Darwin)
        HOST_OS=darwin
        ;;
    Linux)
        HOST_OS=linux
        ;;
esac

#NDK-path
if [[ $1 == *ndk* ]]; then
	echo "----------------- NDK Path is : $1 ----------------"
	Input=$1;
else
	echo "Please enter your android ndk path:"
	echo "For example:/home/astro/android-ndk-r8e"
	read Input
	echo "You entered:$Input"

	echo "----------------- Exporting the android-ndk path ----------------"
fi

#Set path
#Set path
if [ "$ARCHTYPE" = "x86" ] ; then
	export PATH=$PATH:$Input:$Input/toolchains/arm-linux-androideabi-4.4.3/prebuilt/$HOST_OS-x86/bin
else
        export PATH=$PATH:$Input:$Input/toolchains/arm-linux-androideabi-4.4.3/prebuilt/$HOST_OS-x86_64/bin
fi

#create install directories
mkdir -p ./../../../build
mkdir -p ./../../../build/android

#openssl shared/static module build
echo "------- Building openssl 1.0.1e shared lib for ANDROID platform ------"
pushd `pwd`
mkdir -p ./../../../build/android/openssl

rm -rf openssl
unzip openssl.zip
cd openssl
rm -rf obj/*

export NDK_PROJECT_PATH=`pwd`
ndk-build APP_PLATFORM=android-9

echo "------ Building openssl 1.0.1e static lib for ANDROID platform-----"
ndk-build APP_PLATFORM=android-9 APP_MODULES="ssl crypto" BUILD_SHARED_LIBRARY="$Input/build/core/build-static-library.mk"

popd

echo "-------- Installing openssl libs -----"
cp -r ./../../../openssl/projects/android/openssl/obj/local/armeabi/lib* ./../../../build/android/openssl/

#clean
rm -rf openssl

