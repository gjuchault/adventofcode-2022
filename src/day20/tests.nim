import main
import unittest

const firstExample = parse("""1
2
-3
3
-2
0
4""")

suite "rollCircularArray()":
  test "given some low numbers, it moves them as expected":
    check(rollCircularArray(firstExample) == @[1, 2, -3, 4, 0, 3, -2])

suite "part1()":
  test "given example(s), it returns the expected result(s)":
    check(part1(firstExample) == 3)

suite "part2()":
  test "given example(s), it returns the expected result(s)":
    check(2 == 2)
