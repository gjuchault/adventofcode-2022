import std/strutils
import std/strformat
import std/sets
import tables
from "../grid/grid" import losangeEdgeCoords

type Report = object
  sensorPosition: (int, int)
  beaconPosition: (int, int)

const sensorAtX = "Sensor at x="
const sensorAtY = ", y="
const beaconAtX = "closest beacon is at x="
const beaconAtY = ", y="

proc `$`*(rr: ref Report): string =
  return "s: (" & $rr.sensorPosition[0] & ", " & $rr.sensorPosition[1] & ") b: (" & $rr.beaconPosition[0] & ", " & $rr.beaconPosition[1] & ")"

proc part1*(reports: seq[ref Report], targetLine: int): int =
  var allSensors = initHashSet[(int, int)](reports.len)
  var allBeacons = initHashSet[(int, int)](reports.len)

  var emptyPoints = initHashSet[(int, int)]()

  for report in reports:
    allSensors.incl(report.sensorPosition)
    allBeacons.incl(report.beaconPosition)

  for report in reports:
    # 1- calculate manhattan distance to know what size the losange around sensor will be
    let manhattanDistance = abs(report.beaconPosition[0] - report.sensorPosition[0]) + abs(report.beaconPosition[1] - report.sensorPosition[1])

    # 2- get min Y and max Y to eventually skip sensor if will not cover targetLine
    let minY = report.sensorPosition[1] - manhattanDistance
    let maxY = report.sensorPosition[1] + manhattanDistance

    if not (minY <= targetLine and targetLine <= maxY):
      continue

    # losange size = 1 / 3 / 5 / etc. n -> 2 * n + 1
    let distanceFromBeaconToLosange = manhattanDistance - abs(report.sensorPosition[1] - targetLine)
    let maxItemsOnTargetLine = 1 + 2 * distanceFromBeaconToLosange

    # we know half of points are left to S, half of points are right to S and one is S
    let startX = report.sensorPosition[0] - maxItemsOnTargetLine div 2
    let stopX = report.sensorPosition[0] + maxItemsOnTargetLine div 2

    for x in startX .. stopX:
      if allSensors.contains((x, targetLine)) or allBeacons.contains((x, targetLine)):
        continue

      emptyPoints.incl((x, targetLine))

  return emptyPoints.len

proc part2*(reports: seq[ref Report], maxCoord: int): int =
  var potentialPoints = initTable[(int, int), int]()

  for report in reports:
    # 1- calculate manhattan distance to know what size the losange around sensor will be
    let manhattanDistance = abs(report.beaconPosition[0] - report.sensorPosition[0]) + abs(report.beaconPosition[1] - report.sensorPosition[1])

    # we know there is only one point matching, so it must be on the edge of every losange
    # start with losange size + 1
    let losange = losangeEdgeCoords(report.sensorPosition[0], report.sensorPosition[1], manhattanDistance + 1)

    # since some losange are on the edge, let's just take the point that appears on the most edges
    for point in losange:
      potentialPoints[point] = potentialPoints.getOrDefault(point, 0) + 1

  var topPoint = (0, 0)
  var topPointScore = 0

  for point, score in potentialPoints:
    if score > topPointScore:
      topPoint = point
      topPointScore = score

  return topPoint[0] * 4000000 + topPoint[1]

proc parse*(input: string): seq[ref Report] =
  var reports: seq[ref Report] = @[]

  for line in split(input, "\n"):
    var report = new(Report)
    let sensorPart = split(line, ": ")[0]
    let beaconPart = split(line, ": ")[1]

    report.sensorPosition = (
      parseInt(sensorPart[sensorAtX.len .. sensorPart.find(sensorAtY) - 1]),
      parseInt(sensorPart[sensorPart.find(sensorAtY) + sensorAtY.len .. ^1]),
    )

    report.beaconPosition = (
      parseInt(beaconPart[beaconAtX.len .. beaconPart.find(beaconAtY) - 1]),
      parseInt(beaconPart[beaconPart.find(beaconAtY) + beaconAtY.len .. ^1]),
    )

    reports.add(report)

  return reports


proc day15(): void = 
  let entireFile = readFile("./build/input.txt")

  let report = parse(entireFile)

  echo fmt"⭐️ Part 1: {part1(report, 2000000)}"
  echo fmt"⭐️ Part 2: {part2(report, 4000000)}"

if is_main_module:
  day15()
