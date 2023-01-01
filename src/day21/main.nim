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
    of MonkeyKind.MonkeyValue: return fmt"{m.name} {m.value}"
    of MonkeyKind.MonkeyExpression: return fmt"{m.name} {m.expression}"

proc countYellCount(monkeys: TableRef[string, Monkey], monkeyName: string): int =
  let monkey = monkeys[monkeyName]

  case monkey.kind:
    of MonkeyKind.MonkeyValue: return monkey.value
    of MonkeyKind.MonkeyExpression:
      case monkey.expression.op:
        of Operation.Plus: return countYellCount(monkeys, monkey.expression.left) + countYellCount(monkeys, monkey.expression.right)
        of Operation.Minus: return countYellCount(monkeys, monkey.expression.left) - countYellCount(monkeys, monkey.expression.right)
        of Operation.Div: return countYellCount(monkeys, monkey.expression.left) div countYellCount(monkeys, monkey.expression.right)
        of Operation.Mult: return countYellCount(monkeys, monkey.expression.left) * countYellCount(monkeys, monkey.expression.right)

proc part1*(monkeys: TableRef[string, Monkey]): int =
  return countYellCount(monkeys, "root")

proc part2*(monkeys: TableRef[string, Monkey]): int =
  return 2

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
