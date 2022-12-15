import std/math
import std/sequtils
import std/strutils
import std/strformat
import "../grid/grid"

type MapItemKind* = enum Rock = '#', SourceOfSand = '+', Air = '.', Sand = 'o'

proc `$`*(mik: MapItemKind): string =
  case mik:
    of SourceOfSand: return "+"
    of Air: return "."
    of Rock: return "#"
    of Sand: return "o"

type Map* = Grid[MapItemKind]

proc part1*(initialMap: Map): int =
  var map = initialMap.duplicate()

  var maxRockYBeforeInfinity = 0

  for (x, y, value) in map:
    if value == Rock and y > maxRockYBeforeInfinity:
      maxRockYBeforeInfinity = y

  var i = 0
  while true:
    i += 1
    var sandPosition = (500, 1)
    while true:
      if sandPosition[1] + 1 >= map.height():
        return i - 1

      let currentTile = map.get(sandPosition[0], sandPosition[1])
      let bottomMiddleTile = map.get(sandPosition[0], sandPosition[1] + 1)
      let bottomLeftTile = map.get(sandPosition[0] - 1, sandPosition[1] + 1)
      let bottomRightTile = map.get(sandPosition[0] + 1, sandPosition[1] + 1)

      # 1 - try to make sand fall vertically
      if currentTile == Air and bottomMiddleTile == Air:
        sandPosition = (sandPosition[0], sandPosition[1] + 1)
      
      if currentTile == Air and (bottomMiddleTile == Rock or bottomMiddleTile == Sand):
        # 2 - try bottom left
        if bottomLeftTile == Air:
          sandPosition = (sandPosition[0] - 1, sandPosition[1] + 1)
        elif bottomRightTile == Air:
          sandPosition = (sandPosition[0] + 1, sandPosition[1] + 1)
        else:
          break;

    if sandPosition[1] > maxRockYBeforeInfinity:
      break;

    map.incl(sandPosition[0], sandPosition[1], Sand, Air)

  return i - 1

proc part2*(): int =
  return 2

proc parse*(input: string): Map =
  var map = Map()

  map.incl(500, 0, MapItemKind.SourceOfSand, MapItemKind.Air)

  for rawLine in split(input, "\n"):
    let directions: seq[(int, int)] = mapIt(
      mapIt(split(rawLine, " -> "), split(it, ",")),
      (parseInt(it[0]), parseInt(it[1]))
    )

    if directions.len == 0:
      continue

    var previousPoint = directions[0]

    for point in directions[ 1 .. ^1 ]:
      let diffX = abs(point[0] - previousPoint[0])
      let diffY = abs(point[1] - previousPoint[1])
      let signX = sgn(point[0] - previousPoint[0])
      let signY = sgn(point[1] - previousPoint[1])

      if diffX > 0:
        for i in 0 .. diffX:
          let newX = previousPoint[0] + (i * signX)
          map.incl(newX, previousPoint[1], MapItemKind.Rock, MapItemKind.Air)

      if diffY > 0:
        for i in 0 .. diffY:
          let newY = previousPoint[1] + (i * signY)
          map.incl(previousPoint[0], newY, MapItemKind.Rock, MapItemKind.Air)

      previousPoint = point

  return map


proc day14(): void = 
  let entireFile = readFile("./build/input.txt")

  let map = parse(entireFile).fill(MapItemKind.Air)


  echo fmt"⭐️ Part 1: {part1(map)}"
  echo fmt"⭐️ Part 2: {part2()}"

if is_main_module:
  day14()
