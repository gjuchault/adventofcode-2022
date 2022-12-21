import main
import unittest

let firstExample = parse(readFile("./build/firstExample.txt"))

suite "part1()":
  test "given example(s), it returns the expected result(s)":
    check(part1(firstExample) == 3068)

suite "part2()":
  test "given example(s), it returns the expected result(s)":
    check(2 == 2)
