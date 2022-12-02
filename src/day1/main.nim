import std/strutils
import std/strformat
import std/heapqueue

type Elf* = object
  caloriesSum: uint

proc `<`(leftElf, rightElf: ref Elf): bool = 
  return leftElf.caloriesSum < rightElf.caloriesSum

proc part1(elves: seq[ref Elf]): uint =
  if (elves.len == 0):
    return 0

  var topElfByCalorie = elves[0]

  for elf in elves[1 .. ^1]:
    if topElfByCalorie < elf:
      topElfByCalorie = elf
  
  return topElfByCalorie.caloriesSum

proc part2(elves: seq[ref Elf]): uint =
  if (elves.len == 0):
    return 0

  # a heapqueue where we push elf one by one and always remove the lowest one
  # ends up in the top 3 elves without sorting the whole array
  # alternative: 
  # let top3Elves = sorted(elves, Descending)[0 .. 2]
  var top3Elves = initHeapQueue[ref Elf]()

  top3Elves.push(elves[0])
  top3Elves.push(elves[1])
  top3Elves.push(elves[2])

  for elf in elves[3 .. ^1]:
    top3Elves.push(elf)
    top3Elves.del(0)

  var sum: uint = 0

  for index in 0 .. top3Elves.len - 1:
    sum += top3Elves[index].caloriesSum

  return sum

proc day1(): void = 
  let entireFile = readFile("./build/input.txt")

  var elves: seq[ref Elf] = @[]

  for rawElf in split(entireFile, "\n\n"):
    var elf: ref Elf = new(Elf)
    elf.caloriesSum = 0

    for rawCalories in split(rawElf, "\n"):
      let calories = parseUInt(rawCalories)
      elf.caloriesSum += calories
  
    elves.add(elf)

  echo fmt"Part 1: {part1(elves)}"
  echo fmt"Part 2: {part2(elves)}"

day1()
