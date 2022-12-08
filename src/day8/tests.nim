import main
import unittest

let firstExample = TreeGrid(
  grid: @[
    @[3,0,3,7,3],
    @[2,5,5,1,2],
    @[6,5,3,3,2],
    @[3,3,5,4,9],
    @[3,5,3,9,0]
  ]
)

suite "part1()":
  test "given example(s), it returns the expected result(s)":
    check(part1(firstExample) == 21)

suite "part2()":
  test "given example(s), it returns the expected result(s)":
    check(2 == 2)
