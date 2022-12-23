import std/sequtils
import std/strutils
import std/strformat
import std/sets
import std/re

type Point = (int, int, int)
type Box = object
  xEdges: (int, int)
  yEdges: (int, int)
  zEdges: (int, int)

proc siblings(point: Point): seq[Point] =
  return @[
    (point[0] - 1, point[1], point[2]), (point[0] + 1, point[1], point[2]),
    (point[0], point[1] - 1, point[2]), (point[0], point[1] + 1, point[2]),
    (point[0], point[1], point[2] - 1), (point[0], point[1], point[2] + 1)
  ]

proc sidesTouching(point: Point, surface: HashSet[Point]): int =
  return siblings(point).filterIt(surface.contains(it)).len

proc getOuterBox(lavaPoints: seq[Point]): Box =
  var xEdges = (high(int), 0)
  var yEdges = (high(int), 0)
  var zEdges = (high(int), 0)

  for point in lavaPoints:
    # find lowest and biggest x / y / z
    if point[0] < xEdges[0]: xEdges[0] = point[0]
    if point[0] > xEdges[1]: xEdges[1] = point[0]
    if point[1] < yEdges[0]: yEdges[0] = point[1]
    if point[1] > yEdges[1]: yEdges[1] = point[1]
    if point[2] < zEdges[0]: zEdges[0] = point[2]
    if point[2] > zEdges[1]: zEdges[1] = point[2]

  # get surrounding box around the shape
  return Box(
    xEdges: (xEdges[0] - 1, xEdges[1] + 1),
    yEdges: (yEdges[0] - 1, yEdges[1] + 1),
    zEdges: (zEdges[0] - 1, zEdges[1] + 1),
  )

proc isInBox(box: Box, point: Point): bool =
  return point[0] >= box.xEdges[0] and point[0] <= box.xEdges[1] and
      point[1] >= box.yEdges[0] and point[1] <= box.yEdges[1] and
      point[2] >= box.zEdges[0] and point[2] <= box.zEdges[1];

proc part1*(points: seq[Point]): int =
  let lavaPoints = points.toHashSet

  var faces = 0

  for point in lavaPoints:
    for sibling in siblings(point):
      if not lavaPoints.contains(sibling):
        faces += 1

  return faces

proc part2*(points: seq[Point]): int =
  let lavaPoints = points

  let box = getOuterBox(lavaPoints)
  var outsidePoints = initHashSet[Point]()
  var queue: seq[Point] = @[(box.xEdges[0], box.yEdges[0], box.zEdges[0])]

  # find outside points: bfs from origin, stop everytime we hit lava points
  # or go outside the box
  while queue.len > 0:
    let point = queue.pop()

    if not lavaPoints.contains(point) and not outsidePoints.contains(point) and isInBox(box, point):
      outsidePoints.incl(point)

      for sibling in siblings(point):
        queue.add(sibling)

      continue

  # only take lava points directly in contact of the outside points
  return lavaPoints.mapIt(sidesTouching(it, outsidePoints)).foldl(a + b, 0)

proc parse*(input: string): seq[Point] =
  var points = newSeq[Point]()

  for line in split(input, "\n"):
    var matches: array[3, string]
    if match(line, re"(\d+),(\d+),(\d+)", matches):
      points.add((
        parseInt(matches[0]),
        parseInt(matches[1]),
        parseInt(matches[2])
      ))
  
  return points

proc day18(): void = 
  let entireFile = readFile("./build/input.txt")
  let points = parse(entireFile)

  echo fmt"⭐️ Part 1: {part1(points)}"
  echo fmt"⭐️ Part 2: {part2(points)}"

if is_main_module:
  day18()
