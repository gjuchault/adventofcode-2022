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
  var register = 1
  var cycleCount = 0
  var signalStrengthsSum = 0

  proc increaseCycleCount() =
    cycleCount += 1
    if cycleCount == 20 or (cycleCount - 20) mod 40 == 0:
      signalStrengthsSum += cycleCount * register

  for operation in operations:
    if operation.kind == OperationKind.Noop:
      increaseCycleCount()
    elif operation.kind == OperationKind.AddX and isSome(operation.count):
      increaseCycleCount()
      increaseCycleCount()
      register += operation.count.get()

  return signalStrengthsSum

proc part2*(): uint =
  return 2

# 7400 too low
proc day10(): void = 
  let entireFile = readFile("./build/input.txt")
  let operations = parseOperations(entireFile)

  echo fmt"⭐️ Part 1: {part1(operations)}"
  echo fmt"⭐️ Part 2: {part2()}"

if is_main_module:
  day10()
