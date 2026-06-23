#!/bin/bash
curl -f -O -L https://github.com/strawberrymusicplayer/strawberry-macos-dependencies/releases/latest/download/strawberry-macos-$(uname -m)-release.tar.xz
sudo tar -C / -xf strawberry-macos-$(uname -m)-release.tar.xz
rm strawberry-macos-$(uname -m)-release.tar.xz

if [ -d "build" ]; then
	rm -fr build
fi

mkdir build

curl -f -O -L https://github.com/strawberrymusicplayer/strawberry-macos-dependencies/releases/latest/download/strawberry-macos-$(uname -m)-release.tar.xz
sudo tar -C / -xf strawberry-macos-$(uname -m)-release.tar.xz
rm strawberry-macos-$(uname -m)-release.tar.xz

cd build

PKG_CONFIG_PATH=/opt/strawberry_macos_$(uname -m)_release/lib/pkgconfig LDFLAGS="-L/opt/strawberry_macos_$(uname -m)_release/lib -Wl,-rpath,/opt/strawberry_macos_$(uname -m)_release/lib" /opt/strawberry_macos_$(uname -m)_release/bin/cmake --log-level="DEBUG" -S .. -B . -DCMAKE_BUILD_TYPE="Release" -DUSE_BUNDLE=ON -DCMAKE_PREFIX_PATH="/opt/strawberry_macos_$(uname -m)_release/lib/cmake" -DPKG_CONFIG_EXECUTABLE="/opt/strawberry_macos_$(uname -m)_release/bin/pkg-config" -DICU_ROOT="/opt/strawberry_macos_$(uname -m)_release" -DMACDEPLOYQT_EXECUTABLE=/opt/strawberry_macos_$(uname -m)_release/bin/macdeployqt -DARCH=$(uname -m) -DENABLE_SPARKLE=ON -DENABLE_QTSPARKLE=OFF

make -j 4
make install

export GIO_EXTRA_MODULES="/opt/strawberry_macos_$(uname -m)_release/lib/gio/modules"
export GST_PLUGIN_SCANNER="/opt/strawberry_macos_$(uname -m)_release/libexec/gstreamer-1.0/gst-plugin-scanner"
export GST_PLUGIN_PATH="/opt/strawberry_macos_$(uname -m)_release/lib/gstreamer-1.0"
export LIBSOUP_LIBRARY_PATH="/opt/strawberry_macos_$(uname -m)_release/lib/libsoup-3.0.0.dylib"

make deploy

make deploycheck

make dmg
