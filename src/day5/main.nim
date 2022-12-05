import std/strutils
import std/strformat

type Command* = object
  cratesToMove*: uint
  fromStack*: uint
  toStack*: uint

proc part1*(stacks: seq[seq[char]], commands: seq[ref Command]): string =
  var stacksCopy = @stacks
  for command in commands:
    for i in 1 .. command.cratesToMove:
      let extractedChar = stacksCopy[command.fromStack].pop()
      stacksCopy[command.toStack].add(extractedChar)
  
  var message = ""
  for stack in stacksCopy:
    message.add(stack[^1])

  return message

proc part2*(stacks: seq[seq[char]], commands: seq[ref Command]): string =
  var stacksCopy = @stacks
  for command in commands:
    var extractedChars: seq[char] = @[]
    for i in 1 .. command.cratesToMove:
      let extractedChar = stacksCopy[command.fromStack].pop()
      extractedChars.insert(extractedChar, 0)
    for extractedChar in extractedChars:
      stacksCopy[command.toStack].add(extractedChar)
  
  var message = ""
  for stack in stacksCopy:
    message.add(stack[^1])

  return message

proc day5(): void = 
  let entireFile = readFile("./build/input.txt")

  let rawSplit = split(entireFile, "\n\n")

  var commands: seq[ref Command] = @[]
  var stacks: seq[seq[char]] = @[]

  for i in 1 .. int((split(rawSplit[0], "\n")[0].len + 1) / 4):
    stacks.add(@[])

  for rawStacks in split(rawSplit[0], "\n")[ 0 .. ^2 ]:
    for i in countup(0, rawStacks.len - 1, 4):
      let crateChar = rawStacks[ i + 1 ]
      if crateChar == ' ':
        continue

      stacks[int(i / 4)].insert(crateChar, 0)

  for rawCommand in split(rawSplit[1], "\n"):
    var command = new(Command)
    
    let cratesToMoveStartIndex = len("move ")
    let cratesToMoveStopIndex = find(rawCommand, " from") - 1

    let fromStackStartIndex = find(rawCommand, " from ") + len(" from ")
    let fromStackStopIndex = find(rawCommand, " to") - 1

    let toStackStartIndex = find(rawCommand, " to ") + len(" to ")

    command.cratesToMove = parseUint(rawCommand[ cratesToMoveStartIndex .. cratesToMoveStopIndex ])
    command.fromStack = parseUint(rawCommand[ fromStackStartIndex .. fromStackStopIndex ]) - 1
    command.toStack = parseUint(rawCommand[ toStackStartIndex .. ^1 ]) - 1
    
    commands.add(command)

  echo fmt"⭐️ Part 1: {part1(stacks, commands)}"
  echo fmt"⭐️ Part 2: {part2(stacks, commands)}"

if is_main_module:
  day5()
