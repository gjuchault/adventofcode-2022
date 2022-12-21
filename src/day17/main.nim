import std/sequtils
import std/strutils
import std/strformat
import std/options
import std/tables
import "../grid/grid"

type Piece = enum HorizontalLine, Plus, ReversedL, VerticalLine, Square
type Action = enum Left, Right

type CaveItem = enum Wall, FallingPiece, StoppedPiece, Empty

proc `$`*(gi: CaveItem): string =
  case gi:
    of Empty: return "."
    of Wall: return "X"
    of FallingPiece: return "@"
    of StoppedPiece: return "#"

type Cave = Grid[CaveItem]

type PieceFalling = (Piece, (int, int))

let piecesOrder = [HorizontalLine, Plus, ReversedL, VerticalLine, Square]

let piecesShapes = {
  HorizontalLine: @[(0, 0), (1, 0), (2, 0), (3, 0)],
  Plus: @[(1, 1), (1, 0), (0, 1), (1, 2), (2, 1)],
  ReversedL: @[(0, 0), (1, 0), (2, 0), (2, 1), (2, 2)],
  VerticalLine: @[(0, 0), (0, 1), (0, 2), (0, 3)],
  Square: @[(0, 0), (0, 1), (1, 0), (1, 1)]
}.toTable

type IsLastMove = enum Yes, No
type NextPieceCoordinates = object
  previousCoordinates: seq[(int, int)]
  nextCoordinates: seq[(int, int)]
  case isLastMove: IsLastMove
  of No:
    newPieceFalling: PieceFalling
  of Yes:
    maxHeight: int

proc getNextPieceCoordinates(cave: Cave, pieceFalling: PieceFalling, action: Action): NextPieceCoordinates =
  let x = pieceFalling[1][0]
  let y = pieceFalling[1][1]

  var previousCoordinates = piecesShapes[pieceFalling[0]]
  for i in 0 .. previousCoordinates.len - 1:
    previousCoordinates[i][0] += x
    previousCoordinates[i][1] += y

  var nextCoordinates = previousCoordinates

  var isLastMove = IsLastMove.No
  var maxHeight = 0
  var diffX = 1
  var diffY = 1
  if action == Action.Left: diffX = -1

  # 1- try to move left or right
  for i in 0 .. nextCoordinates.len - 1:
    if nextCoordinates[i][0] + diffX > 7 or nextCoordinates[i][0] + diffX < 1:
      diffX = 0

    if cave.getOr(nextCoordinates[i][0] + diffX, nextCoordinates[i][1], CaveItem.Empty) == CaveItem.StoppedPiece:
      diffX = 0

  # 2- try to move down
  for i in 0 .. nextCoordinates.len - 1:
    if previousCoordinates.contains((nextCoordinates[i][0] + diffX, nextCoordinates[i][1] - 1)):
      continue

    if cave.getOr(nextCoordinates[i][0] + diffX, nextCoordinates[i][1] - 1, CaveItem.Empty) != CaveItem.Empty:
      diffY = 0
      isLastMove = IsLastMove.Yes
  
  for i in 0 .. nextCoordinates.len - 1:
    # 3- apply movements
    nextCoordinates[i][0] += diffX
    nextCoordinates[i][1] -= diffY

    if maxHeight < nextCoordinates[i][1]:
      maxHeight = nextCoordinates[i][1]

  if isLastMove == IsLastMove.Yes:
    return NextPieceCoordinates(
      previousCoordinates: previousCoordinates,
      nextCoordinates: nextCoordinates,
      isLastMove: IsLastMove.Yes,
      maxHeight: maxHeight
    )
  else:
    return NextPieceCoordinates(
      previousCoordinates: previousCoordinates,
      nextCoordinates: nextCoordinates,
      isLastMove: IsLastMove.No,
      newPieceFalling: (pieceFalling[0], (pieceFalling[1][0] + diffX, pieceFalling[1][1] - 1))
    )

proc setInitialPieceOnCave(cave: var Cave, piece: Piece, x: int, y: int) =
  var pieceCoords = piecesShapes[piece]

  for i in 0 .. pieceCoords.len - 1:
    cave.incl(pieceCoords[i][0] + x, pieceCoords[i][1] + y, CaveItem.FallingPiece, CaveItem.Empty)

proc movePieceOnCave(cave: var Cave, previousCoordinates: seq[(int, int)], nextCoordinates: seq[(int, int)]) =
  for (x, y) in previousCoordinates:
    cave.incl(x, y, CaveItem.Empty, CaveItem.Empty)

  for (x, y) in nextCoordinates:
    cave.incl(x, y, CaveItem.FallingPiece, CaveItem.Empty)

proc makePieceStopped(cave: var Cave, nextCoordinates: seq[(int, int)]) =
  for (x, y) in nextCoordinates:
    cave.incl(x, y, CaveItem.StoppedPiece, CaveItem.Empty)

proc part1*(actions: seq[Action]): int =
  var cave = Cave()
  let pieceStartingX = 3

  cave.incl(8, 0, CaveItem.Wall, CaveItem.Wall)

  var pieceOrderIndex = 0
  var pieceFalling = none(PieceFalling)
  var cycles = 0
  var lowestBottomSolidCoordinate = 0
  var stoppedPiecesCounter = 0

  while true:
    # if every piece is stabilized, add a new piece
    if pieceFalling.isNone():
      pieceFalling = some((piecesOrder[pieceOrderIndex], (pieceStartingX, lowestBottomSolidCoordinate + 4)))
      setInitialPieceOnCave(cave, piecesOrder[pieceOrderIndex], pieceStartingX, lowestBottomSolidCoordinate + 4)
      pieceOrderIndex = (pieceOrderIndex + 1) mod piecesOrder.len

    let nextPieceCoordinates = getNextPieceCoordinates(cave, pieceFalling.get(), actions[cycles mod actions.len])

    movePieceOnCave(cave, nextPieceCoordinates.previousCoordinates, nextPieceCoordinates.nextCoordinates)
    if nextPieceCoordinates.isLastMove == IsLastMove.Yes:
      makePieceStopped(cave, nextPieceCoordinates.nextCoordinates)
      pieceFalling = none(PieceFalling)
      lowestBottomSolidCoordinate = max(lowestBottomSolidCoordinate, nextPieceCoordinates.maxHeight)
      stoppedPiecesCounter += 1

      if stoppedPiecesCounter == 2022:
        break
    else:
      pieceFalling = some(nextPieceCoordinates.newPieceFalling)

    cycles += 1

  return lowestBottomSolidCoordinate

proc part2*(): int =
  return 2

proc parse*(input: string): seq[Action] =
  return map(
    input,
    proc (rawChar: char): Action =
      if rawChar == '<': return Action.Left
      else: return Action.Right
  )

proc day17(): void = 
  let entireFile = readFile("./build/input.txt")

  let actions = parse(entireFile)

  echo fmt"⭐️ Part 1: {part1(actions)}"
  echo fmt"⭐️ Part 2: {part2()}"

if is_main_module:
  day17()
