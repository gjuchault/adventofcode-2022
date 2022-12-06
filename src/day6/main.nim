import std/strutils
import std/strformat
import std/sets

proc part1*(stream: string): uint =
  for i in countup(0, stream.len - 4, 1):
    let hashset = tohashSet(stream[i .. i + 3])
    if hashset.len == 4:
      return uint(i + 4)

  return 0

proc part2*(): uint =
  return 2

proc day6(): void = 
  let entireFile = readFile("./build/input.txt")

  echo fmt"⭐️ Part 1: {part1(entireFile)}"
  echo fmt"⭐️ Part 2: {part2()}"

if is_main_module:
  day6()
