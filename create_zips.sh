#!/bin/bash

# Exit on error
set -e

# Create pico-sd.zip
echo "Creating pico-sd.zip..."
mkdir -p pico-temp/projects
cp -r themes pico-temp/
cp -r samples pico-temp/
cp -r instruments pico-temp/
# Check if projects/pico exists and has content
if [ -d "projects/pico" ] && [ -n "$(ls -A projects/pico)" ]; then
    cp -r projects/pico/* pico-temp/projects/
fi
(cd pico-temp && zip -r ../pico-sd.zip .)
rm -rf pico-temp
echo "pico-sd.zip created."

# Create advance-sd.zip
echo "Creating advance-sd.zip..."
mkdir -p advance-temp/projects
cp -r themes advance-temp/
cp -r samples advance-temp/
cp -r instruments advance-temp/
# Check if projects/advance exists and has content
if [ -d "projects/advance" ] && [ -n "$(ls -A projects/advance)" ]; then
    cp -r projects/advance/* advance-temp/projects/
fi
(cd advance-temp && zip -r ../advance-sd.zip .)
rm -rf advance-temp
echo "advance-sd.zip created."

echo "Done."
