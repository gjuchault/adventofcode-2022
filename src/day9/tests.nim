import main
import unittest

type CommandRef = ref Command

let firstExample: seq[ref Command] = @[
  CommandRef(direction: Direction.Right, count: 4),
  CommandRef(direction: Direction.Up, count: 4),
  CommandRef(direction: Direction.Left, count: 3),
  CommandRef(direction: Direction.Down, count: 1),
  CommandRef(direction: Direction.Right, count: 4),
  CommandRef(direction: Direction.Down, count: 1),
  CommandRef(direction: Direction.Left, count: 5),
  CommandRef(direction: Direction.Right, count: 2)
]

suite "findTailPositions()":
  test "given same position, it returns same position":
    check(findTailPositions((1, 1), (1, 1)) == (1, 1))

  test "given close position, it returns same position":
    check(findTailPositions((1, 1), (0, 0)) == (0, 0))
    check(findTailPositions((1, 1), (1, 0)) == (1, 0))
    check(findTailPositions((1, 1), (2, 0)) == (2, 0))
    check(findTailPositions((1, 1), (2, 1)) == (2, 1))
    check(findTailPositions((1, 1), (2, 2)) == (2, 2))
    check(findTailPositions((1, 1), (1, 2)) == (1, 2))
    check(findTailPositions((1, 1), (0, 2)) == (0, 2))
    check(findTailPositions((1, 1), (0, 1)) == (0, 1))

  test "given far position (not diagonal), it returns closer position":
    check(findTailPositions((1, 1), (3, 1)) == (2, 1))
    check(findTailPositions((3, 1), (1, 1)) == (2, 1))
    check(findTailPositions((1, 3), (1, 1)) == (1, 2))
    check(findTailPositions((1, 1), (1, 3)) == (1, 2))

  test "given far position (diagonal), it returns closer position":
    check(findTailPositions((2, 3), (1, 1)) == (2, 2))
    check(findTailPositions((3, 2), (1, 1)) == (2, 2))

suite "part1()":
  test "given example(s), it returns the expected result(s)":
    check(part1(firstExample) == 13)

suite "part2()":
  test "given example(s), it returns the expected result(s)":
    check(part2(firstExample) == 1)
