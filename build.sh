#/bin/sh

set -x

mkdir -p kitty/AppDir/usr
cd kitty

# download kitty
wget https://github.com/kovidgoyal/kitty/releases/download/v0.20.2/kitty-0.20.2-x86_64.txz

# extract files
tar -xf kitty-0.20.2-x86_64.txz -C ./AppDir/usr

cd AppDir
KITTY_VERSION=$(./usr/bin/kitty --version | cut -d ' ' -f2)

mv ./usr/share/applications/kitty.desktop .

mkdir -p ./usr/lib \
	./usr/share/icons/hicolor/64x64/apps \
	./usr/share/icons/hicolor/32x32/apps \
	./usr/share/icons/hicolor/256x256/apps \
	./usr/share/icons/hicolor/24x24/apps \
	./usr/share/icons/hicolor/128x128/apps \
	./usr/share/icons/hicolor/48x48/apps

# apply patches
#mv ./opt/google/chrome/product_logo_64.png  ./usr/share/icons/hicolor/64x64/apps/google-chrome.png
#mv ./opt/google/chrome/product_logo_32.png  ./usr/share/icons/hicolor/32x32/apps/google-chrome.png
#mv ./opt/google/chrome/product_logo_256.png ./usr/share/icons/hicolor/256x256/apps/google-chrome.png
#mv ./opt/google/chrome/product_logo_24.png  ./usr/share/icons/hicolor/24x24/apps/google-chrome.png
#mv ./opt/google/chrome/product_logo_128.png ./usr/share/icons/hicolor/128x128/apps/google-chrome.png
#mv ./opt/google/chrome/product_logo_48.png  ./usr/share/icons/hicolor/48x48/apps/google-chrome.png
cp ./usr/share/icons/hicolor/256x256/apps/kitty.png .

sed -i -e 's|Exec=kitty|Exec=AppRun|g' kitty.desktop
echo "StartupWMClass=kitty" >> kitty.desktop
echo "X-AppImage-Version=$KITTY_VERSION" >> kitty.desktop

cd ..
cp ../AppRun ./AppDir

wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage
chmod +x appimagetool-x86_64.AppImage
./appimagetool-x86_64.AppImage AppDir -n -u "gh-releases-zsync|lucasscvvieira|kitty-appimage|stable|Kitty*.AppImage.zsync" "Kitty-$KITTY_VERSION-x86_64.AppImage"
chmod +x Kitty*.AppImage

mkdir dist
mv Kitty*.AppImage* ./dist

