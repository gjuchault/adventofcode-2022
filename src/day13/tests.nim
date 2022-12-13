import std/json
import main
import unittest

let firstExample = """[1,1,3,1,1]
[1,1,5,1,1]

[[1],[2,3,4]]
[[1],4]

[9]
[[8,7,6]]

[[4,4],4,4]
[[4,4],4,4,4]

[7,7,7,7]
[7,7,7]

[]
[3]

[[[]]]
[[]]

[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]"""

suite "compare()":
  test "given example(s), it returns the expected result(s)":
    check(
      compare(
        parsePairItem(parseJson("[1,1,3,1,1]")),
        parsePairItem(parseJson("[1,1,5,1,1]"))
      ) == ComparisonResult.RightOrder
    )
    check(
      compare(
        parsePairItem(parseJson("[[1],[2,3,4]]")),
        parsePairItem(parseJson("[[1],4]"))
      ) == ComparisonResult.RightOrder
    )
    check(
      compare(
        parsePairItem(parseJson("[9]")),
        parsePairItem(parseJson("[[8,7,6]]"))
      ) == ComparisonResult.NotRightOrder
    )
    check(
      compare(
        parsePairItem(parseJson("[[4,4],4,4]")),
        parsePairItem(parseJson("[[4,4],4,4,4]"))
      ) == ComparisonResult.RightOrder
    )
    check(
      compare(
        parsePairItem(parseJson("[7,7,7,7]")),
        parsePairItem(parseJson("[7,7,7]"))
      ) == ComparisonResult.NotRightOrder
    )
    check(
      compare(
        parsePairItem(parseJson("[]")),
        parsePairItem(parseJson("[3]"))
      ) == ComparisonResult.RightOrder
    )
    check(
      compare(
        parsePairItem(parseJson("[[[]]]")),
        parsePairItem(parseJson("[[]]"))
      ) == ComparisonResult.NotRightOrder
    )
    check(
      compare(
        parsePairItem(parseJson("[1,[2,[3,[4,[5,6,7]]]],8,9]")),
        parsePairItem(parseJson("[1,[2,[3,[4,[5,6,0]]]],8,9]"))
      ) == ComparisonResult.NotRightOrder
    )

suite "part1()":
  test "given example(s), it returns the expected result(s)":
    check(part1(parse(firstExample)) == 13)

suite "part2()":
  test "given example(s), it returns the expected result(s)":
    check(2 == 2)
