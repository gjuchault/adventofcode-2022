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

proc part2(rucksacks: seq[ref Rucksack]): uint =
  var score = 0

  if rucksacks.len mod 3 != 0:
    echo "Invalid input: elves can't be split in groups of 3"
    system.quit(1)

  for i in countup(0, rucksacks.len - 1, 3):
    let firstCompleteRucksack = rucksacks[i].firstCompartiment + rucksacks[i].secondCompartiment
    let secondCompleteRucksack = rucksacks[i + 1].firstCompartiment + rucksacks[i + 1].secondCompartiment
    let thirdCompleteRucksack = rucksacks[i + 2].firstCompartiment + rucksacks[i + 2].secondCompartiment

    let intersection = firstCompleteRucksack * secondCompleteRucksack * thirdCompleteRucksack
    
    score += toSeq(intersection)[0]

  return uint(score)

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
  echo fmt"⭐️ Part 2: {part2(rucksacks)}"

dayX()
