import std/strutils
import std/strformat
import std/tables
import command
import directory

proc part1*(directory: ref Directory): uint =
  var directoriesSub100000Size: uint = 0

  var directoriesToCheck: seq[ref Directory] = @[directory]

  while directoriesToCheck.len > 0:
    let directoryToCheck = directoriesToCheck.pop()
    if directoryToCheck.size < 100000:
      directoriesSub100000Size += directoryToCheck.size

    for subDirectory in directoryToCheck.directories.values:
      directoriesToCheck.add(subDirectory)

  return directoriesSub100000Size

proc part2*(directory: ref Directory): uint =
  let minSizeToDelete = 30000000 - (70000000 - directory.size)
  var smallestDir = directory

  var directoriesToCheck: seq[ref Directory] = @[directory]

  while directoriesToCheck.len > 0:
    let directoryToCheck = directoriesToCheck.pop()
    if directoryToCheck.size >= minSizeToDelete and directoryToCheck.size < smallestDir.size:
      smallestDir = directoryToCheck

    for subDirectory in directoryToCheck.directories.values:
      directoriesToCheck.add(subDirectory)

  return smallestDir.size

proc day7(): void = 
  let entireFile = readFile("./build/input.txt")

  let commands = buildCommands(split(entireFile, '\n'))
  let rootDirectory = buildTree(commands)

  echo fmt"⭐️ Part 1: {part1(rootDirectory)}"
  echo fmt"⭐️ Part 2: {part2(rootDirectory)}"

if is_main_module:
  day7()
