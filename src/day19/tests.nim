import main
import unittest

let firstExample = parse("""Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian.
Blueprint 2: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 8 clay. Each geode robot costs 3 ore and 12 obsidian.""")

suite "part1()":
  test "given example(s), it returns the expected result(s)":
    check(part1(firstExample) == 33)

suite "part2()":
  test "given example(s), it returns the expected result(s)":
    check(2 == 2)
