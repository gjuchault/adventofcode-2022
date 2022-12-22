import std/sequtils
import main
import unittest

let firstExample = parse(readFile("./build/firstExample.txt"))

suite "findIndexWhenSeqRepeats()":
  test "given a big seq and a repeating seq, it finds when it starts to repeat":
    let bigSeq = @[1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6, 1, 2]

    check(findIndexWhenSeqRepeats(bigSeq, 3) == 6)

suite "part1()":
  test "given example(s), it returns the expected result(s)":
    check(part1(firstExample) == 3068)

suite "part2Magic()":
  test "given a simple example, it returns the height":
    let expandedSeq = @[1,2, 3].concat(@[4, 5, 6, 7].cycle(30))[ 0 .. 100 ]

    check(part2Magic(
      @[1, 2, 3, 4, 5, 6, 7, 4, 5, 6, 7, 4, 5, 6, 7],
      4,
      3,
      100
    ) == expandedSeq.foldl(a + b, 0))

suite "part2()":
  test "given example(s), it returns the expected result(s)":
    check(part2(firstExample) == 1514285714288)
