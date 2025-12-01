#!/bin/sh
#

_TAG_VERSION="${1}";

# IOS_URL="https://download.videolan.org/pub/cocoapods/unstable/VLCKit-4.0.0a10-d962e05c-17860384.tar.xz"
IOS_URL="./package/VLCKit.xcframework.tar.gz"

rm -rf .tmp/ || true
mkdir .tmp/

tar -xf ${IOS_URL} -C .tmp/

IOS_LOCATION=".tmp/VLCKit.xcframework"

ditto -c -k --sequesterRsrc --keepParent "${IOS_LOCATION}" "${IOS_LOCATION}.zip"

#Update package file
PACKAGE_HASH=$(sha256sum "${IOS_LOCATION}.zip" | awk '{ print $1 }')
PACKAGE_STRING="Target.binaryTarget(name: \"VLCKit\", url: \"https:\/\/github.com\/wonkwh\/vlckit-ios-spm\/releases\/download\/v${_TAG_VERSION}\/VLCKit.xcframework.zip\", checksum: \"$PACKAGE_HASH\")"
echo "Changing package definition for xcframework with hash $PACKAGE_HASH"
sed -i '' -e "s/let vlcBinary.*/let vlcBinary = $PACKAGE_STRING/" Package.swift

cp -f .tmp/COPYING.txt ./LICENSE
