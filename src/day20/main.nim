import std/algorithm
import std/strutils
import std/strformat
import std/sequtils

proc rollCircularArray*(encrypted: seq[int], times = 1): seq[int] =
  var inputEntries = newSeq[(int, int)]()

  for i in 0 .. encrypted.len - 1:
    inputEntries.add((i, encrypted[i]))

  var mixed = inputEntries

  proc deleteAtInitialIndex(index: int) =
    var initialIndex = -1

    for i in 0 .. mixed.len() - 1:
      if mixed[i][0] == index:
        initialIndex = i
        break
    
    mixed.delete(initialIndex)

  for i in 1 .. times:
    for originalIndex in 0 .. encrypted.len - 1:
      var value = inputEntries[originalIndex][1]
      let currentIndex = mixed.find(inputEntries[originalIndex])
      var newIndex = currentIndex

      if value > 0: value = value mod (mixed.len() - 1)
      if value < 0: value = ((value * -1) mod (mixed.len() - 1)) * -1

      while value > 0:
        if (newIndex == mixed.len() - 1): newIndex = 0
        newIndex += 1
        value -= 1

      while value < 0:
        if newIndex == 0: newIndex = mixed.len() - 1
        newIndex -= 1
        value += 1

      deleteAtInitialIndex(inputEntries[originalIndex][0])
      mixed.insert(inputEntries[originalIndex], newIndex)

  var reconstructed = newSeq[int](encrypted.len())

  for i in 0 .. encrypted.len() - 1:
    reconstructed[i] = mixed[i][1]

  return reconstructed.rotatedLeft(1)

proc part1*(encrypted: seq[int]): int =
  let rolledArray = rollCircularArray(encrypted, 1)

  var zeroCoord = -1
  for i in 0 .. rolledArray.len - 1:
    if rolledArray[i] == 0:
      zeroCoord = i
      break

  let oneThousandAfter0 = rolledArray[(zeroCoord + 1000) mod rolledArray.len]
  let twoThousandAfter0 = rolledArray[(zeroCoord + 2000) mod rolledArray.len]
  let threeThousandAfter0 = rolledArray[(zeroCoord + 3000) mod rolledArray.len]

  return oneThousandAfter0 + twoThousandAfter0 + threeThousandAfter0

proc part2*(encrypted: seq[int]): int =
  let decryptionKey = 811589153

  let rolledArray = rollCircularArray(encrypted.mapIt(it * decryptionKey), 10)

  var zeroCoord = -1
  for i in 0 .. rolledArray.len - 1:
    if rolledArray[i] == 0:
      zeroCoord = i
      break

  let oneThousandAfter0 = rolledArray[(zeroCoord + 1000) mod rolledArray.len]
  let twoThousandAfter0 = rolledArray[(zeroCoord + 2000) mod rolledArray.len]
  let threeThousandAfter0 = rolledArray[(zeroCoord + 3000) mod rolledArray.len]

  return oneThousandAfter0 + twoThousandAfter0 + threeThousandAfter0

proc parse*(input: string): seq[int] =
  return split(input, "\n").mapIt(parseInt(it))

proc day20(): void = 
  let entireFile = readFile("./build/input.txt")
  let encrypted = parse(entireFile)

  echo fmt"⭐️ Part 1: {part1(encrypted)}"
  echo fmt"⭐️ Part 2: {part2(encrypted)}"

if is_main_module:
  day20()
