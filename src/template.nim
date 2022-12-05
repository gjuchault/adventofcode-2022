import std/strutils
import std/strformat

proc part1*(): uint =
  return 1

proc part2*(): uint =
  return 2

proc dayX(): void = 
  let entireFile = readFile("./build/input.txt")

  echo fmt"⭐️ Part 1: {part1()}"
  echo fmt"⭐️ Part 2: {part2()}"

if is_main_module:
  dayX()
