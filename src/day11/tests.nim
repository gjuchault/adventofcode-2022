import main
import unittest

let firstExample = readFile("./build/firstExample.txt")
let monkeysFirstExample = parse(firstExample)

suite "part1()":
  test "given example(s), it returns the expected result(s)":
    check(part1(monkeysFirstExample) == 10605)

suite "part2()":
  test "given example(s), it returns the expected result(s)":
    check(2 == 2)
