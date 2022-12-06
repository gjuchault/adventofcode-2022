import std/strutils
import std/strformat
import std/sets

proc part1*(stream: string): uint =
  let packetLength = 4

  for i in countup(0, stream.len - packetLength, 1):
    let hashset = tohashSet(stream[i .. i + packetLength - 1])
    if hashset.len == packetLength:
      return uint(i + packetLength)

  return 0

proc part2*(stream: string): uint =
  let packetLength = 14

  for i in countup(0, stream.len - packetLength, 1):
    let hashset = tohashSet(stream[i .. i + packetLength - 1])
    if hashset.len == packetLength:
      return uint(i + packetLength)

  return 0

proc day6(): void = 
  let entireFile = readFile("./build/input.txt")

  echo fmt"⭐️ Part 1: {part1(entireFile)}"
  echo fmt"⭐️ Part 2: {part2(entireFile)}"

if is_main_module:
  day6()
