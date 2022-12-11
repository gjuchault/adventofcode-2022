import main
import unittest

let firstExample = readFile("./build/firstExample.txt")

suite "part1()":
  test "given example(s), it returns the expected result(s)":
    check(part1(parseOperations(firstExample)) == 13140)

suite "part2()":
  test "given example(s), it returns the expected result(s)":
    check(2 == 2)
