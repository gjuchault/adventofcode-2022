import main
import unittest
import std/strutils

let firstExample = readFile("./build/firstExample.txt")

suite "part1()":
  test "given example(s), it returns the expected result(s)":
    check(part1(parseOperations(firstExample)) == 13140)

suite "part2()":
  test "given example(s), it returns the expected result(s)":
    let part2Arr = @[
      "##..##..##..##..##..##..##..##..##..##..",
      "###...###...###...###...###...###...###.",
      "####....####....####....####....####....",
      "#####.....#####.....#####.....#####.....",
      "######......######......######......####",
      "#######.......#######.......#######....."
    ]

    check(part2(parseOperations(firstExample)) == join(part2Arr, "\n"))
