import std/strutils
import std/strformat
import std/sets
import std/re

proc siblings(coord: (int, int, int)): seq[(int, int, int)] =
  return @[
    (coord[0], coord[1], coord[2] + 1),
    (coord[0], coord[1], coord[2] - 1),
    (coord[0], coord[1] + 1, coord[2]),
    (coord[0], coord[1] - 1, coord[2]),
    (coord[0] + 1, coord[1], coord[2]),
    (coord[0] - 1, coord[1], coord[2])
  ]

proc part1*(coords: seq[(int, int, int)]): int =
  let uniqueCoords = coords.toHashSet

  var faces = 0

  for coord in uniqueCoords:
    for sibling in siblings(coord):
      if not uniqueCoords.contains(sibling):
        faces += 1

  return faces

proc part2*(): int =
  return 2

proc parse*(input: string): seq[(int, int, int)] =
  var coords = newSeq[(int, int, int)]()

  for line in split(input, "\n"):
    var matches: array[3, string]
    if match(line, re"(\d+),(\d+),(\d+)", matches):
      coords.add((
        parseInt(matches[0]),
        parseInt(matches[1]),
        parseInt(matches[2])
      ))
  
  return coords

proc day18(): void = 
  let entireFile = readFile("./build/input.txt")
  let coords = parse(entireFile)

  echo fmt"⭐️ Part 1: {part1(coords)}"
  echo fmt"⭐️ Part 2: {part2()}"

if is_main_module:
  day18()
