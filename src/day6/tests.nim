import main
import unittest

let firstExample = "mjqjpqmgbljsphdztnvjfqwrcgsmlb"
let secondExample = "bvwbjplbgvbhsrlpgdmjqwftvncz"
let thirdExample = "nppdvjthqldpwncqszvftbrmjlhg"
let fourthExample = "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"
let fifthExample = "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"

suite "part1()":
  test "given examples, it returns the expected result":
    check(part1(firstExample) == 7)
    check(part1(secondExample) == 5)
    check(part1(thirdExample) == 6)
    check(part1(fourthExample) == 10)
    check(part1(fifthExample) == 11)

suite "part2()":
  test "given examples, it returns the expected result":
    check(part1(firstExample) == 7)
    check(part1(secondExample) == 5)
    check(part1(thirdExample) == 6)
    check(part1(fourthExample) == 10)
    check(part1(fifthExample) == 11)
