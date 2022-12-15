import main
import unittest
import "../grid/grid"

var firstExample = parse("""498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9""")

let bigFirstExample = firstExample.fill(MapItemKind.Air)

suite "part1()":
  test "given example(s), it returns the expected result(s)":
    check(part1(bigFirstExample) == 24)

suite "part2()":
  test "given example(s), it returns the expected result(s)":
    check(2 == 2)
