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

let minusOrderExample = parse("""root: bbbb + aaaa
aaaa: 10
bbbb: dddd - cccc
cccc: 5
dddd: humn + eeee
eeee: 1
humn: 0""")

let invertedMinusOrderExample = parse("""root: bbbb + aaaa
aaaa: 10
bbbb: cccc - dddd
cccc: 5
dddd: humn + eeee
eeee: 1
humn: 0""")

let divOrderExample = parse("""root: bbbb + aaaa
aaaa: 10
bbbb: dddd / cccc
cccc: 5
dddd: humn + eeee
eeee: 1
humn: 0""")

let invertedDivOrderExample = parse("""root: bbbb + aaaa
aaaa: 10
bbbb: cccc / dddd
cccc: 20
dddd: humn + eeee
eeee: 1
humn: 0""")

suite "part1()":
  test "given example(s), it returns the expected result(s)":
    check(part1(firstExample) == 152)

suite "part2()":
  test "given example(s), it returns the expected result(s)":
    check(part2(minusOrderExample) == 14)
    check(part2(divOrderExample) == 49)
    check(part2(invertedMinusOrderExample) == -6)
    check(part2(invertedDivOrderExample) == 1)
    check(part2(firstExample) == 301)
