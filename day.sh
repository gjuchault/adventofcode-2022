#!/usr/bin/env sh

echo "🎄 Advent of Code 2022: day $1"
rm -rf build/
mkdir -p build/
cp ./src/day$1/input.txt ./build
nim compile --verbosity:0 --outdir:./build --run ./src/day$1/main.nim
