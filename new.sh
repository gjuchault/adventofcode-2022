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

echo "🎄 Advent of Code 2022: generating day $1"

if [ -d "./src/day$1" ];
then
  echo 1>&2 "Invalid operation: day $1 already exists."
  exit 1
fi

mkdir ./src/day$1
touch ./src/day$1/input.txt
sed "s/dayX/day$1/g" ./src/template.nim > ./src/day$1/main.nim
cp ./src/template.tests.nim ./src/day$1/tests.nim
./day.sh $1
