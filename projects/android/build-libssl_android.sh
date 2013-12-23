#!/bin/sh
echo "Please enter your android ndk path:"
echo "For example:/home/astro/android-ndk-r8e"
read Input
echo "You entered:$Input"

echo "----------------- Exporting the android-ndk path ----------------"

#Set path
export PATH=$PATH:$Input:$Input/toolchains/arm-linux-androideabi-4.4.3/prebuilt/linux-x86/bin

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

