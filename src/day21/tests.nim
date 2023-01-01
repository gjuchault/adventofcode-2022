import main
import unittest

let firstExample = parse("""root: pppw + sjmn
dbpl: 5
cczh: sllz + lgvd
zczc: 2
ptdq: humn - dvpt
dvpt: 3
lfqf: 4
humn: 5
ljgn: 2
sjmn: drzm * dbpl
sllz: 4
pppw: cczh / lfqf
lgvd: ljgn * ptdq
drzm: hmdt - zczc
hmdt: 32""")

suite "part1()":
  test "given example(s), it returns the expected result(s)":
    check(part1(firstExample) == 152)

suite "part2()":
  test "given example(s), it returns the expected result(s)":
    check(part2(firstExample) == 301)
