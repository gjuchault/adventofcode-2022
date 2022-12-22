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

proc getTowerHeight*(actions: seq[Action], maxPieces: int): (int, seq[int]) =
  var cave = Cave()
  let pieceStartingX = 3

  cave.incl(8, 0, CaveItem.Wall, CaveItem.Wall)

  var pieceOrderIndex = 0
  var pieceFalling = none(PieceFalling)
  var cycles = 0
  var towerHeight = 0
  var stoppedPiecesCounter = 0

  var heightDiff = newSeq[int]()

  while true:
    # if every piece is stabilized, add a new piece
    if pieceFalling.isNone():
      pieceFalling = some((piecesOrder[pieceOrderIndex], (pieceStartingX, towerHeight + 4)))
      setInitialPieceOnCave(cave, piecesOrder[pieceOrderIndex], pieceStartingX, towerHeight + 4)
      pieceOrderIndex = (pieceOrderIndex + 1) mod piecesOrder.len

    let nextPieceCoordinates = getNextPieceCoordinates(cave, pieceFalling.get(), actions[cycles mod actions.len])

    movePieceOnCave(cave, nextPieceCoordinates.previousCoordinates, nextPieceCoordinates.nextCoordinates)
    if nextPieceCoordinates.isLastMove == IsLastMove.Yes:
      makePieceStopped(cave, nextPieceCoordinates.nextCoordinates)
      pieceFalling = none(PieceFalling)
      
      let newTowerHeight = max(towerHeight, nextPieceCoordinates.maxHeight)
      heightDiff.add(newTowerHeight - towerHeight)
      towerHeight = newTowerHeight

      stoppedPiecesCounter += 1

      if stoppedPiecesCounter == maxPieces:
        break
    else:
      pieceFalling = some(nextPieceCoordinates.newPieceFalling)

    cycles += 1

  return (towerHeight, heightDiff)

proc part1*(actions: seq[Action]): int =
  let (towerHeight, heightEvolution) = getTowerHeight(actions, 2022)

  assert(towerHeight == heightEvolution.foldl(a + b, 0))

  return towerHeight

proc findIndexWhenSeqRepeats*(bigSeq: seq[int], size: int): int =
  let cmp = bigSeq[ 0 .. size ]

  for i in size .. bigSeq.len - size:
    if bigSeq[ i .. i + size ] == cmp:
      return i
  
  return -1

proc part2Magic*(sample: seq[int], earlyToSkip: int, seqToCheck: int, maxPieces: int64): int64 =
  # eliminate the early that can be unstable
  let reducedSample = sample[ earlyToSkip .. ^1 ]

  # find repeated sequence (when are the first 100 ints repeated)
  let seqRepeatsEvery = findIndexWhenSeqRepeats(reducedSample, seqToCheck)

  let seqValue = reducedSample[ 0 .. seqRepeatsEvery - 1 ].foldl(a + b, 0)
  
  var towerHeight: int64 = 0

  # first add the skipped ones
  towerHeight += sample[ 0 .. earlyToSkip - 1 ].foldl(a + b, 0)

  # then add as much of the seq as possible
  let timesToRepeatSeq = (maxPieces - earlyToSkip) div seqRepeatsEvery
  towerHeight += seqValue * timesToRepeatSeq

  # then finish individually
  let timesToRepeatAfterSeq = (maxPieces - earlyToSkip) mod seqRepeatsEvery
  for i in 0 .. timesToRepeatAfterSeq:
    towerHeight += reducedSample[i]

  return towerHeight

proc part2*(actions: seq[Action]): int64 =
  # take a sample on a couple of rounds
  let sample = getTowerHeight(actions, 10000)[1]

  return part2Magic(sample, 1000, 100, 1000000000000) - 1

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
  echo fmt"⭐️ Part 2: {part2(actions)}"

if is_main_module:
  day17()
