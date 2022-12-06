import main
import unittest

type IdRangeRef = ref IdRange

suite "rangeFullyContains()":
  test "given A fully before B, it returns false":
    check(rangeFullyContains(IdRangeRef(rangeStart: 1, rangeEnd: 5), IdRangeRef(rangeStart: 7, rangeEnd: 10)) == false)

  test "given A partially containing B (lower), it returns false":
    check(rangeFullyContains(IdRangeRef(rangeStart: 1, rangeEnd: 5), IdRangeRef(rangeStart: 4, rangeEnd: 8)) == false)

  test "given A fully containing B, it returns true":
    check(rangeFullyContains(IdRangeRef(rangeStart: 1, rangeEnd: 5), IdRangeRef(rangeStart: 2, rangeEnd: 5)) == true)

  test "given A partially containing B (upper), it returns false":
    check(rangeFullyContains(IdRangeRef(rangeStart: 2, rangeEnd: 5), IdRangeRef(rangeStart: 1, rangeEnd: 3)) == false)

  test "given A fully after B, it returns false":
    check(rangeFullyContains(IdRangeRef(rangeStart: 3, rangeEnd: 5), IdRangeRef(rangeStart: 1, rangeEnd: 2)) == false)

suite "rangePartiallyContains()":
  test "given A fully before B, it returns false":
    check(rangePartiallyContains(IdRangeRef(rangeStart: 1, rangeEnd: 5), IdRangeRef(rangeStart: 7, rangeEnd: 10)) == false)

  test "given A partially containing B (lower), it returns true":
    check(rangePartiallyContains(IdRangeRef(rangeStart: 1, rangeEnd: 5), IdRangeRef(rangeStart: 4, rangeEnd: 8)) == true)

  test "given A fully containing B, it returns true":
    check(rangePartiallyContains(IdRangeRef(rangeStart: 1, rangeEnd: 5), IdRangeRef(rangeStart: 2, rangeEnd: 5)) == true)

  test "given A partially containing B (upper), it returns true":
    check(rangePartiallyContains(IdRangeRef(rangeStart: 2, rangeEnd: 5), IdRangeRef(rangeStart: 1, rangeEnd: 3)) == true)

  test "given A fully after B, it returns false":
    check(rangePartiallyContains(IdRangeRef(rangeStart: 3, rangeEnd: 5), IdRangeRef(rangeStart: 1, rangeEnd: 2)) == false)

let pair2468 = new(Pair)
pair2468.left = IdRangeRef(rangeStart: 2, rangeEnd: 4)
pair2468.right = IdRangeRef(rangeStart: 6, rangeEnd: 8)

let pair2345 = new(Pair)
pair2345.left = IdRangeRef(rangeStart: 2, rangeEnd: 3)
pair2345.right = IdRangeRef(rangeStart: 4, rangeEnd: 5)

let pair5779 = new(Pair)
pair5779.left = IdRangeRef(rangeStart: 5, rangeEnd: 7)
pair5779.right = IdRangeRef(rangeStart: 7, rangeEnd: 9)

let pair2837 = new(Pair)
pair2837.left = IdRangeRef(rangeStart: 2, rangeEnd: 8)
pair2837.right = IdRangeRef(rangeStart: 3, rangeEnd: 7)

let pair6646 = new(Pair)
pair6646.left = IdRangeRef(rangeStart: 6, rangeEnd: 6)
pair6646.right = IdRangeRef(rangeStart: 4, rangeEnd: 6)

let pair2648 = new(Pair)
pair2648.left = IdRangeRef(rangeStart: 2, rangeEnd: 6)
pair2648.right = IdRangeRef(rangeStart: 4, rangeEnd: 8)

let firstExample: seq[ref Pair] = @[
  pair2468,
  pair2345,
  pair5779,
  pair2837,
  pair6646,
  pair2648
]

suite "part1()":
  test "given example(s), it returns the expected result(s)":
    check(part1(firstExample) == 2)

suite "part2()":
  test "given example(s), it returns the expected result(s)":
    check(part2(firstExample) == 4)
