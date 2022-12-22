import std/strutils
import std/strformat
import std/sets

type Direction* = enum
  Up, Right, Down, Left

type Command* = object
  direction*: Direction
  count*: int

proc findTailPositions*(headPosition: (int, int), tailPosition: (int, int)): (int, int) =
  if headPosition == tailPosition: return tailPosition

  let diffX = abs(headPosition[0] - tailPosition[0])
  let diffY = abs(headPosition[1] - tailPosition[1])
  let isTouching = diffX < 2 and diffY < 2

  if isTouching: return tailPosition

  # diagonal
  if diffX > 0 and diffY > 0:
    var newPosition = (tailPosition[0], tailPosition[1])

    if headPosition[0] > tailPosition[0]: newPosition[0] += 1
    else: newPosition[0] -= 1

    if headPosition[1] > tailPosition[1]: newPosition[1] += 1
    else: newPosition[1] -= 1

    return newPosition

  if diffX >= 2:
    if headPosition[0] > tailPosition[0]:
      return (tailPosition[0] + 1, tailPosition[1])
    else:
      return (tailPosition[0] - 1, tailPosition[1])

  if diffY >= 2:
    if headPosition[1] > tailPosition[1]:
      return (tailPosition[0], tailPosition[1] + 1)
    else:
      return (tailPosition[0], tailPosition[1] - 1)


proc part1*(commands: seq[ref Command]): uint =
  var uniqueCoordinates = initHashSet[(int, int)]()

  var headPosition = (0, 0)
  var tailPosition = (0, 0)

  uniqueCoordinates.incl(tailPosition)

  for command in commands:
    for i in 1 .. command.count:
      if command.direction == Direction.Up:
        headPosition = (headPosition[0], headPosition[1] + 1)
      if command.direction == Direction.Down:
        headPosition = (headPosition[0], headPosition[1] - 1)
      if command.direction == Direction.Left:
        headPosition = (headPosition[0] - 1, headPosition[1])
      if command.direction == Direction.Right:
        headPosition = (headPosition[0] + 1, headPosition[1])

      tailPosition = findTailPositions(headPosition, tailPosition)
      uniqueCoordinates.incl(tailPosition)

  return uint(uniqueCoordinates.len)

proc part2*(commands: seq[ref Command]): uint =
  var uniqueCoordinates = initHashSet[(int, int)]()

  var headPosition = (0, 0)
  var knotPositions = [
    (0, 0), (0, 0), (0, 0), (0, 0), (0, 0),
    (0, 0), (0, 0), (0, 0), (0, 0)
  ]

  for command in commands:
    # 1. move head position
    for i in 1 .. command.count:
      if command.direction == Direction.Up:
        headPosition = (headPosition[0], headPosition[1] + 1)
      if command.direction == Direction.Down:
        headPosition = (headPosition[0], headPosition[1] - 1)
      if command.direction == Direction.Left:
        headPosition = (headPosition[0] - 1, headPosition[1])
      if command.direction == Direction.Right:
        headPosition = (headPosition[0] + 1, headPosition[1])

      var prevKnot = headPosition
      for i in 0 .. knotPositions.len - 1:
        knotPositions[i] = findTailPositions(prevKnot, knotPositions[i])
        prevKnot = knotPositions[i]

      uniqueCoordinates.incl(knotPositions[8])

  return uint(uniqueCoordinates.len)

proc day9(): void = 
  let entireFile = readFile("./build/input.txt")

  var commands: seq[ref Command] = @[]

  for line in split(entireFile, '\n'):
    var command = new(Command)

    if line[ 0 .. 0 ] == "U": command.direction = Direction.Up
    if line[ 0 .. 0 ] == "R": command.direction = Direction.Right
    if line[ 0 .. 0 ] == "D": command.direction = Direction.Down
    if line[ 0 .. 0 ] == "L": command.direction = Direction.Left

    command.count = parseInt(line[ 2 .. ^1 ])
    commands.add(command)

  echo fmt"⭐️ Part 1: {part1(commands)}"
  echo fmt"⭐️ Part 2: {part2(commands)}"

if is_main_module:
  day9()
