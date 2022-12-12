import std/strutils
import std/strformat
import std/tables
import "../grid/grid"

type HeightMap* = Grid[int]

proc getVisitableAdjacents(map: HeightMap, pos: (int, int)): seq[(int, int)] =
  var visitableAdjacents: seq[(int, int)] = @[];

  let posValue = map.get(pos[0], pos[1])

  for (adjX, adjY, adjValue) in map.adjacents(pos[0], pos[1], false):
    if adjValue <= posValue + 1:
      visitableAdjacents.add((adjX, adjY))

  return visitableAdjacents

proc getVisitableAdjacentsFromEnd(map: HeightMap, pos: (int, int)): seq[(int, int)] =
  var visitableAdjacents: seq[(int, int)] = @[];

  let posValue = map.get(pos[0], pos[1])

  for (adjX, adjY, adjValue) in map.adjacents(pos[0], pos[1], false):
    if posValue - adjValue <= 1:
      visitableAdjacents.add((adjX, adjY))

  return visitableAdjacents

proc part1*(map: HeightMap, startPos: (int, int), endPos: (int, int)): int =
  # BFS
  var distances = initTable[(int, int), int]()
  var prev = initTable[(int, int), (int, int)]()
  var visited = initTable[(int, int), bool]()

  for (x, y, value) in map:
    distances[(x, y)] = high(int)
    visited[(x, y)] = false

  visited[startPos] = true
  distances[startPos] = 0

  var queue: seq[(int, int)] = @[startPos]

  while queue.len > 0:
    let node = queue.pop()
    for adjacent in getVisitableAdjacents(map, node):
      let adjacentDistance = distances[node] + 1
      let hasVisistedAdjacentAlready = visited[adjacent] == true
      let isAdjacentDistanceAboveNow = distances[adjacent] > adjacentDistance

      if hasVisistedAdjacentAlready and not isAdjacentDistanceAboveNow:
        continue

      visited[adjacent] = true
      distances[adjacent] = adjacentDistance
      prev[adjacent] = node
      queue.add(adjacent)

      if adjacent == endPos:
        break

  var path: seq[(int, int)] = @[]
  var curr = endPos

  while curr != startPos:
    path.add(curr)
    curr = prev[curr]

  return path.len


proc part2*(map: HeightMap, startPos: (int, int)): int =
  # BFS
  var distances = initTable[(int, int), int]()
  var prev = initTable[(int, int), (int, int)]()
  var visited = initTable[(int, int), bool]()

  for (x, y, value) in map:
    distances[(x, y)] = high(int)
    visited[(x, y)] = false

  visited[startPos] = true
  distances[startPos] = 0

  var queue: seq[(int, int)] = @[startPos]

  while queue.len > 0:
    let node = queue.pop()
    for adjacent in getVisitableAdjacentsFromEnd(map, node):
      let adjacentDistance = distances[node] + 1
      let hasVisistedAdjacentAlready = visited[adjacent] == true
      let isAdjacentDistanceAboveNow = distances[adjacent] > adjacentDistance

      if hasVisistedAdjacentAlready and not isAdjacentDistanceAboveNow:
        continue

      visited[adjacent] = true
      distances[adjacent] = adjacentDistance
      prev[adjacent] = node
      queue.add(adjacent)

  var minDistance = high(int)

  for (x, y, val) in map:
    if val != 1:
      continue

    if distances[(x, y)] < minDistance:
      minDistance = distances[(x, y)]

  return minDistance

proc parse*(lines: seq[string]): (HeightMap, (int, int), (int, int)) =
  var map = HeightMap()
  var startPos = (0, 0)
  var endPos = (0, 0)

  for y in 0 .. lines.len - 1:
    for x in 0 .. lines[y].len - 1:
      if lines[y][x] == 'S':
        startPos = (x, y)
        map.incl(x, y, 1, 0)
      elif lines[y][x] == 'E':
        endPos = (x, y)
        map.incl(x, y, 26, 0)
      else:
        map.incl(x, y, ord(lines[y][x]) - 96, 0)

  return (map, startPos, endPos)

proc day12(): void = 
  let lines = split(readFile("./build/input.txt"), "\n")

  let (map, startPos, endPos) = parse(lines)

  echo fmt"⭐️ Part 1: {part1(map, startPos, endPos)}"
  echo fmt"⭐️ Part 2: {part2(map, endPos)}"

if is_main_module:
  day12()
