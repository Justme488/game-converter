#!/usr/bin/env bash

# This script will download the latest files, and build game-converter.deb package for debian based distros
# Your desktop will be the main working directory (All files/directories will be removed at the end)

# Get current users name, and store it in a variable
username=$(whoami)

# Download "master.zip" to desktop with required files to build deb file
wget --directory-prefix="/home/$username/Desktop" "https://github.com/Justme488/game-converter/archive/master.zip"

# Unzip "master.zip" to desktop
unzip "/home/$username/Desktop/master.zip" -d "/home/$username/Desktop"

# Rename game-converter-master to game-converter
mv "/home/$username/Desktop/game-converter-master" "/home/$username/Desktop/game-converter"

# If master.zip was extracted, delete master zip
if [ -d "/home/$username/Desktop/game-converter" ]; then
  rm -r "/home/$username/Desktop/master.zip"
else
  echo "game-converter directory doesn't exist!"
  sleep 5
  exit
fi

# Change directory to "/home/$username/Desktop/game-converter"
cd "/home/$username/Desktop/game-converter"

# create directories "DEBIAN" "usr" "bin" "share" "applications", and "game-converter"
mkdir "DEBIAN"
mkdir "usr"
mkdir "bin"
mkdir "share"
mkdir "applications"
mkdir "game-converter"

# Move directories to where they need to be
mv "/home/$username/Desktop/game-converter/bin" "/home/$username/Desktop/game-converter/usr/bin"
mv "/home/$username/Desktop/game-converter/share" "/home/$username/Desktop/game-converter/usr/share"
mv "/home/$username/Desktop/game-converter/applications" "/home/$username/Desktop/game-converter/usr/share/applications"
mv "/home/$username/Desktop/game-converter/game-converter" "/home/$username/Desktop/game-converter/usr/share/game-converter"

# Move files to where they need to be
mv "/home/$username/Desktop/game-converter/chdman4" "/home/$username/Desktop/game-converter/usr/bin/chdman4"
mv "/home/$username/Desktop/game-converter/chdman5" "/home/$username/Desktop/game-converter/usr/bin/chdman5"
mv "/home/$username/Desktop/game-converter/control" "/home/$username/Desktop/game-converter/DEBIAN/control"
mv "/home/$username/Desktop/game-converter/game-converter.desktop" "/home/$username/Desktop/game-converter/usr/share/applications/game-converter.desktop"
mv "/home/$username/Desktop/game-converter/game-converter.png" "/home/$username/Desktop/game-converter/usr/share/game-converter/game-converter.png"
mv "/home/$username/Desktop/game-converter/game-converter.sh" "/home/$username/Desktop/game-converter/usr/share/game-converter/game-converter.sh"

# Make game-converter.sh executable
chmod +x "/home/$username/Desktop/game-converter/usr/share/game-converter/game-converter.sh"

# chmod working folder 775
chmod -R 775 "/home/$username/Desktop/game-converter"

# Create a working directory "game-converter-build"
mkdir "/home/$username/Desktop/game-converter-build"

# Move "/home/$username/Desktop/game-converter" to "/home/$username/Desktop/game-converter-build/game-converter"
mv "/home/$username/Desktop/game-converter" "/home/$username/Desktop/game-converter-build/game-converter"

# Change directory to "/home/$username/Desktop/game-converter"
cd "/home/$username/Desktop/game-converter-build"

# Create .deb file
dpkg-deb --build game-converter

# Move game-converter.deb to dekstop
mv "/home/$username/Desktop/game-converter-build/game-converter.deb" "/home/$username/Desktop/game-converter.deb"

# Delete working folder if game-converter.deb exists
if [ -f "/home/$username/Desktop/game-converter.deb" ]; then
  rm -r "/home/$username/Desktop/game-converter-build"
  exit
else
  echo "game-converter.deb does not exist!"
  sleep 5
  exit
fi
exit
