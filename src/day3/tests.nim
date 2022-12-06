import main
import unittest
import std/sequtils
import std/intsets

type RucksackRef = ref Rucksack

suite "letterToPriority()":
  test "given some letters, it returns the appropriate priority":
    check(letterToPriority('a') == 1)
    check(letterToPriority('z') == 26)
    check(letterToPriority('A') == 27)
    check(letterToPriority('Z') == 52)

let firstExample: seq[ref Rucksack] = @[
  RucksackRef(
    firstCompartiment: toIntSet(map("vJrwpWtwJgWr", letterToPriority)),
    secondCompartiment: toIntSet(map("hcsFMMfFFhFp", letterToPriority))
  ),
  RucksackRef(
    firstCompartiment: toIntSet(map("jqHRNqRjqzjGDLGL", letterToPriority)),
    secondCompartiment:toIntSet(map("rsFMfFZSrLrFZsSL", letterToPriority))
  ),
  RucksackRef(
    firstCompartiment: toIntSet(map("PmmdzqPrV", letterToPriority)),
    secondCompartiment:toIntSet(map("vPwwTWBwg", letterToPriority))
  ),
  RucksackRef(
    firstCompartiment: toIntSet(map("wMqvLMZHhHMvwLH", letterToPriority)),
    secondCompartiment:toIntSet(map("jbvcjnnSBnvTQFn", letterToPriority))
  ),
  RucksackRef(
    firstCompartiment: toIntSet(map("ttgJtRGJ", letterToPriority)),
    secondCompartiment:toIntSet(map("QctTZtZT", letterToPriority))
  ),
  RucksackRef(
    firstCompartiment: toIntSet(map("CrZsJsPPZsGz", letterToPriority)),
    secondCompartiment:toIntSet(map("wwsLwLmpwMDw", letterToPriority))
  )
]

suite "part1()":
  test "given example(s), it returns the expected result(s)":
    check(part1(firstExample) == 157)

suite "part2()":
  test "given example(s), it returns the expected result(s)":
    check(part2(firstExample) == 70)
