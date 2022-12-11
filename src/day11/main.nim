import std/strutils
import std/sequtils
import std/strformat
import std/algorithm

const startingItemsSliceStart = "  Starting items: ".len
const operationSliceStart = "  Operation: new = old ".len
const operationBySliceStart = "  Operation: new = old * ".len
const testSliceStart = "  Test: divisible by ".len
const ifTrueSliceStart = "    If true: throw to monkey ".len
const ifFalseSliceStart = "    If false: throw to monkey ".len

type MonkeyOperationKind* = enum
  Add, Multiply

type MonkeyOperationRightKind* = enum
  Old, Constant

type MonkeyOperation* = object
  kind: MonkeyOperationKind
  case rightKind: MonkeyOperationRightKind
  of Constant: value: int
  of Old: discard

type Monkey* = object
  startingItems: seq[int]
  operation: MonkeyOperation
  testDivisibleBy: int
  testTrueTarget: int
  testFalseTarget: int

proc applyOperation(old: int, operation: MonkeyOperation): int =
  var right = (if operation.rightKind == MonkeyOperationRightKind.Old: old else: operation.value)

  return (case operation.kind
    of MonkeyOperationKind.Add: old + right
    of MonkeyOperationKind.Multiply: old * right
  )

proc part1*(monkeys: seq[ref Monkey]): int =
  var scoreByMonkey = newSeqWith[int](monkeys.len, 0)

  for round in 1 .. 20:
    for i in 0 .. monkeys.len - 1:
      let monkey = monkeys[i]

      for item in monkey.startingItems:
        scoreByMonkey[i] += 1

        # 1 - set worry level to item level
        var worryLevel = item

        # 2 - apply operation
        worryLevel = applyOperation(worryLevel, monkey.operation)

        # 3 - divide worry level
        worryLevel = worryLevel div 3

        if worryLevel mod monkey.testDivisibleBy == 0:
          monkeys[monkey.testTrueTarget].startingItems.add(worryLevel)
        else:
          monkeys[monkey.testFalseTarget].startingItems.add(worryLevel)

      monkey.startingItems = @[]

  sort(scoreByMonkey, Descending)

  return scoreByMonkey[0] * scoreByMonkey[1]

proc part2*(monkeys: seq[ref Monkey]): int =
  var scoreByMonkey = newSeqWith[int](monkeys.len, 0)
  var maxLevel = foldl(monkeys, a * b.testDivisibleBy, 1)

  for round in 1 .. 10000:
    for i in 0 .. monkeys.len - 1:
      let monkey = monkeys[i]

      for item in monkey.startingItems:
        scoreByMonkey[i] += 1

        # 1 - set worry level to item level
        var worryLevel = item

        # 2 - apply operation
        worryLevel = applyOperation(worryLevel, monkey.operation)

        # 3 - always keep worry level to the max level which is the
        # multiplication of all tests.
        worryLevel = worryLevel mod maxLevel

        if worryLevel mod monkey.testDivisibleBy == 0:
          monkeys[monkey.testTrueTarget].startingItems.add(worryLevel)
        else:
          monkeys[monkey.testFalseTarget].startingItems.add(worryLevel)

      monkey.startingItems = @[]

  sort(scoreByMonkey, Descending)

  return scoreByMonkey[0] * scoreByMonkey[1]

proc parseMonkeyOperationKind(input: string): MonkeyOperationKind =
  if input == "+": return MonkeyOperationKind.Add
  if input == "*": return MonkeyOperationKind.Multiply

proc parseMonkeyOperationRightKind(input: string): MonkeyOperationRightKind =
  if input == "old": return MonkeyOperationRightKind.Old
  return MonkeyOperationRightKind.Constant

proc parse*(input: string): seq[ref Monkey] =
  let rawMonkeys = split(input, "\n\n")
  var monkeys: seq[ref Monkey] = @[]

  for rawMonkey in rawMonkeys:
    let monkey = new(Monkey)
    let lines = split(rawMonkey, "\n")


    monkey.startingItems = split(lines[1][ startingItemsSliceStart .. ^1 ], ", ").mapIt(parseInt(it))
    monkey.operation = MonkeyOperation(
      kind: parseMonkeyOperationKind(lines[2][ operationSliceStart .. operationSliceStart ]),
      rightKind: parseMonkeyOperationRightKind(lines[2][ operationBySliceStart .. ^1 ])
    )
    if (monkey.operation.rightKind == MonkeyOperationRightKind.Constant):
      monkey.operation.value = parseInt(lines[2][ operationBySliceStart .. ^1 ])
    monkey.testDivisibleBy = parseInt(lines[3][ testSliceStart .. ^1 ])
    monkey.testTrueTarget = parseInt(lines[4][ ifTrueSliceStart .. ^1 ])
    monkey.testFalseTarget = parseInt(lines[5][ ifFalseSliceStart .. ^1 ])

    monkeys.add(monkey)

  return monkeys

proc day11(): void = 
  let entireFile = readFile("./build/input.txt")

  echo fmt"⭐️ Part 1: {part1(parse(entireFile))}"
  echo fmt"⭐️ Part 2: {part2(parse(entireFile))}"

if is_main_module:
  day11()
