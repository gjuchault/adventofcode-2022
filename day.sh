#!/usr/bin/env sh

rm -rf build/
mkdir -p build/
cp ./src/day$1/input.txt ./build
nim compile --verbosity:0 --outdir:./build --run ./src/day$1/main.nim
