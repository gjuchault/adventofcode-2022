import main
import unittest

let firstExample = parse("""1,1,1
2,1,1""")

let secondExample = parse("""2,2,2
1,2,2
3,2,2
2,1,2
2,3,2
2,2,1
2,2,3
2,2,4
2,2,6
1,2,5
3,2,5
2,1,5
2,3,5""")

suite "part1()":
  test "given example(s), it returns the expected result(s)":
    check(part1(firstExample) == 10)
    check(part1(secondExample) == 64)

suite "part2()":
  test "given example(s), it returns the expected result(s)":
    check(2 == 2)
