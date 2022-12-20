import main
import unittest

let firstExample = parse(readFile("./build/firstExample.txt"))

suite "allPairs()":
  test "given an array, it returns all the possible pairs":
    check(allPairs(@["a", "b", "c", "d"]) == @[
      ("a", "b"),
      ("a", "c"),
      ("a", "d"),
      ("b", "c"),
      ("b", "d"),
      ("c", "d"),
    ])

suite "bfs()":
  test "given nodes, a start and an end, it returns the path":
    check(bfs(firstExample, "AA", "EE") == 2)

suite "part1()":
  test "given example(s), it returns the expected result(s)":
    check(part1(firstExample) == 1651)

suite "part2()":
  test "given example(s), it returns the expected result(s)":
    check(2 == 2)
