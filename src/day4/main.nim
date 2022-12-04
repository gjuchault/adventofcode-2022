import std/strutils
import std/strformat

type IdRange = object
  rangeStart: uint
  rangeEnd: uint

type Pair = tuple[left: ref IdRange, right: ref IdRange]

proc rangeContains(left: ref IdRange, right: ref IdRange): bool =
  let leftContainsRight = left.rangeStart <= right.rangeStart and
    left.rangeEnd >= right.rangeEnd

  let rightContainsLeft = right.rangeStart <= left.rangeStart and
    right.rangeEnd >= left.rangeEnd

  return leftContainsRight or rightContainsLeft

proc part1(pairs: seq[ref Pair]): uint =
  var score: uint = 0
  for pair in pairs:
    if rangeContains(pair.left, pair.right):
      score += 1
  
  return score

proc part2(): uint =
  return 2

proc day4(): void = 
  let entireFile = readFile("./build/input.txt")
  var pairs: seq[ref Pair] = @[]

  for rawPair in split(entireFile, "\n"):
    var pair = new(Pair)
    let splitRawPair = split(rawPair, ",")

    let splitLeftRawRange = split(splitRawPair[0], "-")
    var leftIdRange = new(IdRange)
    leftIdRange.rangeStart = parseUInt(splitLeftRawRange[0])
    leftIdRange.rangeEnd = parseUInt(splitLeftRawRange[1])

    let splitRightRawRange = split(splitRawPair[1], "-")
    var rightIdRange = new(IdRange)
    rightIdRange.rangeStart = parseUInt(splitRightRawRange[0])
    rightIdRange.rangeEnd = parseUInt(splitRightRawRange[1])

    pair.left = leftIdRange
    pair.right = rightIdRange
    pairs.add(pair)

  echo fmt"⭐️ Part 1: {part1(pairs)}"
  echo fmt"⭐️ Part 2: {part2()}"

day4()
