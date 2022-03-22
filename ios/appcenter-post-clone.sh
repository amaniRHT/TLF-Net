#!/usr/bin/env bash
#Place this script in project/ios/
# fail if any command fails
set -e
# debug log
set -x
echo "Appcenter-post-clone.sh called"
cd ..
git clone -b stable https://github.com/flutter/flutter.git
export PATH=`pwd`/flutter/bin:$PATH
flutter channel stable
flutter doctor -v
echo "Installed flutter to `pwd`/flutter"
flutter build ios --release --no-codesign