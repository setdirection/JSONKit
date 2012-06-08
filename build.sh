#!/bin/sh

# Function for handling errors
die() {
    echo ""
    echo "$*" >&2
    exit 1
}

# The Xcode bin path
XCODEBUILD_PATH=/Applications/Xcode.app/Contents/Developer/usr/bin 
XCODEBUILD=$XCODEBUILD_PATH/xcodebuild

# Get the script path and set the relative directories used
# for compilation
cd $(dirname $0)
SCRIPTPATH=`pwd`


# The home directory where the SDK is installed
PROJECT_HOME=`pwd`

echo "Project Home: $PROJECT_HOME"

# The directory where the target is built
BUILDDIR=$PROJECT_HOME/build

# The directory where the library output will be placed
LIBOUTPUTDIR=$PROJECT_HOME/libJSONKit

$XCODEBUILD -target "JSONKit" -sdk "iphonesimulator" -configuration "Release" SYMROOT=$BUILDDIR clean build || die "iOS Simulator build failed"
$XCODEBUILD -target "JSONKit" -sdk "iphoneos" -configuration "Release" SYMROOT=$BUILDDIR clean build || die "iOS Device build failed"

\rm $LIBOUTPUTDIR/*

# combine lib files for various platforms into one
lipo -create $BUILDDIR/Release-iphonesimulator/libJSONKit.a $BUILDDIR/Release-iphoneos/libJSONKit.a -output $LIBOUTPUTDIR/libJSONKit.a || die "Could not create static output library"

\cp *.h $LIBOUTPUTDIR/

echo "JSONKit.h and libJSONKit.a are now in .\JSONKit.  Enjoy."

exit 0