import main
import unittest

type ElfRef = ref Elf

let firstExample = @[
  ElfRef(
    caloriesSum: 1000 + 2000 + 3000
  ),
  ElfRef(
    caloriesSum: 4000
  ),
  ElfRef(
    caloriesSum: 5000 + 6000
  ),
  ElfRef(
    caloriesSum: 7000 + 8000 + 9000
  ),
  ElfRef(
    caloriesSum: 10000
  )
]

suite "part1()":
  test "given example(s), it returns the expected result(s)":
    let result = part1(firstExample)

    check(result == 24000)

suite "part2()":
  test "given example(s), it returns the expected result(s)":
    let result = part2(firstExample)

    check(result == 45000)
