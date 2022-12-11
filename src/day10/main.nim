import std/strutils
import std/strformat
import std/options

type OperationKind* = enum Noop, AddX

type Operation* = object
  kind: OperationKind
  count: Option[int]

type OperationRef* = ref Operation

proc parseOperations*(input: string): seq[ref Operation] =
  var operations: seq[ref Operation] = @[]

  for line in split(input, '\n'):
    let operation = new(Operation)

    if line == "noop":
      operation.kind = OperationKind.Noop
      operation.count = none(int)
    else:
      operation.kind = OperationKind.AddX
      operation.count = some(parseInt(line[ 5 .. ^1 ]))

    operations.add(operation)

  return operations


proc part1*(operations: seq[ref Operation]): int =
  var registerX = 1
  var cycleCount = 0
  var signalStrengthsSum = 0

  proc increaseCycleCount() =
    cycleCount += 1
    if cycleCount == 20 or (cycleCount - 20) mod 40 == 0:
      signalStrengthsSum += cycleCount * registerX

  for operation in operations:
    if operation.kind == OperationKind.Noop:
      increaseCycleCount()
    elif operation.kind == OperationKind.AddX and isSome(operation.count):
      increaseCycleCount()
      increaseCycleCount()
      registerX += operation.count.get()

  return signalStrengthsSum

proc part2*(operations: seq[ref Operation]): string =
  var registerX = 1
  var cycleCount = 1
  var lines: array[6, string] = ["", "", "", "", "", ""]
  const spriteSize = 3
  const spriteDiffFromMiddle = (spriteSize - 1) div 2

  proc getPixelX(cycleCount: int): int =
    if cycleCount <= 40: return cycleCount
    elif cycleCount <= 80: return cycleCount - 40
    elif cycleCount <= 120: return cycleCount - 80
    elif cycleCount <= 160: return cycleCount - 120
    elif cycleCount <= 200: return cycleCount - 160
    elif cycleCount <= 240: return cycleCount - 200

  proc getPixelY(cycleCount: int): int =
    if cycleCount <= 40: return 0
    elif cycleCount <= 80: return 1
    elif cycleCount <= 120: return 2
    elif cycleCount <= 160: return 3
    elif cycleCount <= 200: return 4
    elif cycleCount <= 240: return 5

  proc increaseCycleCountAndDraw() =
    let pixelX = getPixelX(cycleCount)
    let pixelY = getPixelY(cycleCount)
    let spriteStart = registerX + 1 - spriteDiffFromMiddle
    let spriteEnd = registerX + 1 + spriteDiffFromMiddle

    if pixelX >= spriteStart and pixelX <= spriteEnd:
      lines[pixelY] = lines[pixelY] & "#"
    else:
      lines[pixelY] = lines[pixelY] & "."
    cycleCount += 1

  for operation in operations:
    if operation.kind == OperationKind.Noop:
      increaseCycleCountAndDraw()
    elif operation.kind == OperationKind.AddX and isSome(operation.count):
      increaseCycleCountAndDraw()
      increaseCycleCountAndDraw()
      registerX += operation.count.get()

  return join(lines, "\n")

# 7400 too low
proc day10(): void = 
  let entireFile = readFile("./build/input.txt")
  let operations = parseOperations(entireFile)

  echo fmt"⭐️ Part 1: {part1(operations)}"
  echo fmt"⭐️ Part 2:"
  echo part2(operations)

if is_main_module:
  day10()
