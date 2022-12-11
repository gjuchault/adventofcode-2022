import main
import unittest

let firstExample = readFile("./build/firstExample.txt")

suite "part1()":
  test "given example(s), it returns the expected result(s)":
    check(part1(parse(firstExample)) == 10605)

suite "part2()":
  test "given example(s), it returns the expected result(s)":
    check(part2(parse(firstExample)) == 2713310158)
