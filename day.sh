#!/usr/bin/env sh

if [ $# -lt 1 ]; then
  echo 1>&2 "$0: not enough arguments"
  echo 1>&2 "Usage: ./day.sh [day]"
  exit 2
elif [ $# -gt 1 ]; then
  echo 1>&2 "$0: too many arguments"
  echo 1>&2 "Usage: ./day.sh [day]"
  exit 2
fi

echo "🎄 Advent of Code 2022: day $1"
rm -rf build/
mkdir -p build/
cp ./src/day$1/input.txt ./build
nim compile --verbosity:0 --outdir:./build --run ./src/day$1/main.nim
