import std/strutils
import std/strformat
import std/sequtils
import std/tables

type Operation* = enum Plus, Minus, Div, Mult
type MonkeyKind* = enum MonkeyValue, MonkeyExpression

type Expression* = ref object
  op: Operation
  left: string
  right: string

proc `$`*(e: Expression): string = fmt"{e.left} {e.op} {e.right}"

type Monkey* = ref object
  name: string
  case kind: MonkeyKind
    of MonkeyValue: value: int
    of MonkeyExpression: expression: Expression

proc `$`*(m: Monkey): string =
  case m.kind:
    of MonkeyKind.MonkeyValue: return fmt"{m.name}({m.value})"
    of MonkeyKind.MonkeyExpression: return fmt"{m.name}({m.expression})"

proc countYellCount(monkeys: TableRef[string, Monkey], monkeyName: string, humnOverride: int): int =
  let monkey = monkeys[monkeyName]

  if monkeyName == "humn":
    return humnOverride

  case monkey.kind:
    of MonkeyKind.MonkeyValue: return monkey.value
    of MonkeyKind.MonkeyExpression:
      case monkey.expression.op:
        of Operation.Plus: return countYellCount(monkeys, monkey.expression.left, humnOverride) + countYellCount(monkeys, monkey.expression.right, humnOverride)
        of Operation.Minus: return countYellCount(monkeys, monkey.expression.left, humnOverride) - countYellCount(monkeys, monkey.expression.right, humnOverride)
        of Operation.Div: return countYellCount(monkeys, monkey.expression.left, humnOverride) div countYellCount(monkeys, monkey.expression.right, humnOverride)
        of Operation.Mult: return countYellCount(monkeys, monkey.expression.left, humnOverride) * countYellCount(monkeys, monkey.expression.right, humnOverride)

proc applyOppositeOperation(
  constantMonkeyYelling: TableRef[string, int],
  currentRootLeft: int,
  nextMonkey: Monkey,
  nextNextMonkey: Monkey
): (int, Operation, int) =
  case nextMonkey.kind:
    of MonkeyKind.MonkeyValue: return (nextMonkey.value, Operation.Plus, 0)
    of MonkeyKind.MonkeyExpression:
      var choice = "left"
      var otherValue = constantMonkeyYelling[nextMonkey.expression.left]

      if nextMonkey.expression.left == nextNextMonkey.name:
        choice = "right"
        otherValue = constantMonkeyYelling[nextMonkey.expression.right]

      case nextMonkey.expression.op:
        of Operation.Plus: return (currentRootLeft - otherValue, Operation.Minus, otherValue)
        of Operation.Minus:
          # careful on sign order
          if choice == "left":
            return (otherValue - currentRootLeft, Operation.Minus, otherValue)
          else:
            return (currentRootLeft + otherValue, Operation.Plus, otherValue)
        of Operation.Div:
          # careful on sign order
          if choice == "left":
            return (otherValue div currentRootLeft, Operation.Div, otherValue)
          else:
            return (currentRootLeft * otherValue, Operation.Mult, otherValue)
        of Operation.Mult: return (currentRootLeft div otherValue, Operation.Div, otherValue)

proc part1*(monkeys: TableRef[string, Monkey]): int =
  assert monkeys["humn"].kind == MonkeyKind.MonkeyValue

  # part 1: no override for humn
  let humnValue = monkeys["humn"].value

  return countYellCount(monkeys, "root", humnValue)

proc part2*(monkeys: TableRef[string, Monkey]): int =
  assert monkeys["humn"].kind == MonkeyKind.MonkeyValue
  assert monkeys["root"].kind == MonkeyKind.MonkeyExpression
  assert monkeys["root"].expression.op == Operation.Plus

  let constantMonkeyYelling = newTable[string, int]()

  # cache every monkey, including the ones that depends on humn (which we won't
  # use anyway)
  for monkey in monkeys.keys:
    constantMonkeyYelling[monkey] = countYellCount(monkeys, monkey, 0)

  # we can see only left side is evolving when changing humn value
  # echo countYellCount(monkeys, monkeys["root"].expression.left, 4482)
  # echo countYellCount(monkeys, monkeys["root"].expression.left, 2000)
  # echo countYellCount(monkeys, monkeys["root"].expression.right, 4482)
  # echo countYellCount(monkeys, monkeys["root"].expression.right, 2000)

  let rootRight = countYellCount(monkeys, monkeys["root"].expression.right, monkeys["humn"].value)

  # BFS to find from rootLeft to humn by inverting all operations
  var queue = newSeq[seq[Monkey]]()
  var pathFromRootToHumn = newSeq[Monkey]()

  queue.add(@[monkeys[monkeys["root"].expression.left]])

  while queue.len > 0:
    let path = queue.pop()
    let lastMonkey = path[ ^1 ]

    if lastMonkey.name == "humn":
      pathFromRootToHumn = path
      break
    if lastMonkey.kind == MonkeyKind.MonkeyValue: continue

    let leftPath = concat(path, @[monkeys[lastMonkey.expression.left]])
    let rightPath = concat(path, @[monkeys[lastMonkey.expression.right]])

    queue.add(leftPath)
    queue.add(rightPath)

  var rootLeft = rootRight

  for i in 0 .. pathFromRootToHumn.len() - 2:
    let nextMonkey = pathFromRootToHumn[i]
    let nextNextMonkey = pathFromRootToHumn[i + 1]
    let appliedOppositeOperation = applyOppositeOperation(
      constantMonkeyYelling,
      rootLeft,
      nextMonkey,
      nextNextMonkey
    )

    rootLeft = appliedOppositeOperation[0]

  assert countYellCount(monkeys, monkeys["root"].expression.right, monkeys["humn"].value) == countYellCount(monkeys, monkeys["root"].expression.left, rootLeft)

  return rootLeft

proc parse*(input: string): TableRef[string, Monkey] =
  var output = newTable[string, Monkey]()

  for line in split(input, "\n"):
    let splitLine = split(line, ": ")

    if splitLine[1].contains(" "):
      var expression = Expression()
      let splitOps = split(splitLine[1], {'+', '-', '/', '*'}).mapIt(it.strip())

      case splitLine[1][5]:
        of '+': expression.op = Operation.Plus
        of '-': expression.op = Operation.Minus
        of '/': expression.op = Operation.Div
        of '*': expression.op = Operation.Mult
        else: raise newException(IOError, "Invalid operator")

      expression.left = splitOps[0]
      expression.right = splitOps[1]

      let monkey = Monkey(
        name: splitLine[0],
        kind: MonkeyKind.MonkeyExpression,
        expression: expression
      )

      output[monkey.name] = monkey
    else:
      let monkey = Monkey(
        name: splitLine[0],
        kind: MonkeyKind.MonkeyValue,
        value: parseInt(splitLine[1].strip())
      )

      output[monkey.name] = monkey

  return output


proc day21(): void = 
  let entireFile = readFile("./build/input.txt")

  let monkeys = parse(entireFile)

  echo fmt"⭐️ Part 1: {part1(monkeys)}"
  echo fmt"⭐️ Part 2: {part2(monkeys)}"

if is_main_module:
  day21()
