import main
import unittest

let (firstExampleMap, firstExampleStartPos, firstExampleEndPos) = parse(@[
  "Sabqponm",
  "abcryxxl",
  "accszExk",
  "acctuvwj",
  "abdefghi",
])

suite "part1()":
  test "given example(s), it returns the expected result(s)":
    check(part1(firstExampleMap, firstExampleStartPos, firstExampleEndPos) == 31)

suite "part2()":
  test "given example(s), it returns the expected result(s)":
    check(part2(firstExampleMap, firstExampleEndPos) == 29)
