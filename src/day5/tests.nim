import main
import unittest

type CommandRef = ref Command

let firstExampleStacks: seq[seq[char]] = @[
  @['Z', 'N'],
  @['M', 'C', 'D'],
  @['P']
]

let firstExampleCommands: seq[ref Command] = @[
  CommandRef(cratesToMove: 1, fromStack: 1, toStack: 0),
  CommandRef(cratesToMove: 3, fromStack: 0, toStack: 2),
  CommandRef(cratesToMove: 2, fromStack: 1, toStack: 0),
  CommandRef(cratesToMove: 1, fromStack: 0, toStack: 1),
]

suite "part1()":
  test "given first example, it returns the expected result":
    check(part1(firstExampleStacks, firstExampleCommands) == "CMZ")

suite "part2()":
  test "given first example, it returns the expected result":
    check(part2(firstExampleStacks, firstExampleCommands) == "MCD")
