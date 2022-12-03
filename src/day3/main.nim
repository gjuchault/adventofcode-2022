import std/strutils
import std/strformat
import std/sequtils
import std/intsets

type Rucksack = object
  firstCompartiment: IntSet
  secondCompartiment: IntSet

proc part1(rucksacks: seq[ref Rucksack]): uint =
  var score = 0

  for rucksack in rucksacks:
    let intersection = rucksack.firstCompartiment * rucksack.secondCompartiment
    if intersection.len > 1:
      echo "Invalid input: rucksack compartiment has more than one item in common"
      system.quit(1)
    
    score += toSeq(intersection)[0]

  return uint(score)

proc part2(): uint =
  return 2

proc letterToPriority(letter: char): int =
  let asciiCode = int(letter)

  if asciiCode >= int('A') and asciiCode <= int('Z'):
    return asciiCode - int('A') + 27
  elif asciiCode >= int('a') and asciiCode <= int('z'):
    return asciiCode - int('a') + 1

proc dayX(): void = 
  let entireFile = readFile("./build/input.txt")

  var rucksacks: seq[ref Rucksack] = @[]

  for rawRucksack in split(entireFile, "\n"):
    if rawRucksack.len mod 2 != 0:
      echo "Invalid input: rucksack can't be split in two parts"
      system.quit(1)

    let separatorIndex = int(rawRucksack.len / 2)

    let rawFirstCompartiment = rawRucksack[0 .. separatorIndex - 1]
    let rawSecondCompartiment = rawRucksack[separatorIndex .. ^1]

    var rucksack = new(Rucksack)

    rucksack.firstCompartiment = toIntSet(map(rawFirstCompartiment, letterToPriority))
    rucksack.secondCompartiment = toIntSet(map(rawSecondCompartiment, letterToPriority))

    rucksacks.add(rucksack)

  echo fmt"⭐️ Part 1: {part1(rucksacks)}"
  echo fmt"⭐️ Part 2: {part2()}"

dayX()
