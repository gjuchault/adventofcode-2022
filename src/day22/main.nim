import std/sequtils
import std/strutils
import std/strformat
import std/options
import "../grid/grid"

type BoardItem* = enum Void, OpenTile, SolidWall
type Turn* = enum Clockwise, CounterClockwise
type Facing* = enum Top, Right, Bottom, Left

proc `$`*(bi: BoardItem): string =
  case bi:
    of Void: " "
    of OpenTile: "."
    of SolidWall: "#"

proc `$`*(d: Turn): string =
  case d:
    of Clockwise: "R"
    of CounterClockwise: "L"

type Board* = Grid[BoardItem]

type Instruction* = ref object
  count: int
  turn: Option[Turn]

proc `$`*(i: Instruction): string = fmt"({i.count} {i.turn})"

proc getNextPosition(currentPosition: (int, int), currentlyFacing: Facing): (int, int) =
  case currentlyFacing:
    of Top: (currentPosition[0], currentPosition[1] - 1)
    of Right: (currentPosition[0] + 1, currentPosition[1])
    of Bottom: (currentPosition[0], currentPosition[1] + 1)
    of Left: (currentPosition[0] - 1, currentPosition[1])

proc getFirstCoordAfterVoidWrap*(board: Board, currentPosition: (int, int), currentlyFacing: Facing): (int, int) =
  var delta = (0, 0)
  var nextCoordinate = (0, 0)

  case currentlyFacing:
    of Top:
      delta = (0, -1)
      nextCoordinate = (currentPosition[0], board.height() - 1)
    of Right:
      delta = (1, 0)
      nextCoordinate = (0, currentPosition[1])
    of Bottom:
      delta = (0, 1)
      nextCoordinate = (currentPosition[0], 0)
    of Left:
      delta = (-1, 0)
      nextCoordinate = (board.width() - 1, currentPosition[1])

  while board.getOr(nextCoordinate, BoardItem.Void) == BoardItem.Void:
    nextCoordinate[0] += delta[0]
    nextCoordinate[1] += delta[1]

  return nextCoordinate

proc rotateFacing(currentlyFacing: Facing, turn: Option[Turn]): Facing =
  if turn.isNone(): return currentlyFacing

  case currentlyFacing:
    of Top:
      if turn.get() == Turn.Clockwise: Facing.Right else: Facing.Left
    of Right:
      if turn.get() == Turn.Clockwise: Facing.Bottom else: Facing.Top
    of Bottom:
      if turn.get() == Turn.Clockwise: Facing.Left else: Facing.Right
    of Left:
      if turn.get() == Turn.Clockwise: Facing.Top else: Facing.Bottom

proc getFaceScore(currentlyFacing: Facing): int =
  case currentlyFacing:
    of Top: 3
    of Right: 0
    of Bottom: 1
    of Left: 2

proc part1*(board: Board, instructions: seq[Instruction]): int =
  var position = (high(int), high(int))
  var currentlyFacing = Facing.Right

  for (x, y, boardItem) in board:
    if boardItem == BoardItem.OpenTile and x < position[0] and y < position[1]:
      position = (x, y)

  for instruction in instructions:
    var nextCandidatePosition = position

    for walk in 1 .. instruction.count:
      var tryingCandidatePosition = getNextPosition(nextCandidatePosition, currentlyFacing)

      # first try to warp (because a warp into a wall = no warp at all)
      if board.getOr(tryingCandidatePosition, BoardItem.Void) == BoardItem.Void:
        tryingCandidatePosition = getFirstCoordAfterVoidWrap(board, nextCandidatePosition, currentlyFacing)
        if board.getOr(tryingCandidatePosition, BoardItem.Void) == BoardItem.SolidWall:
          # Fail to warp, just stop here
          break

      if board.getOr(tryingCandidatePosition, BoardItem.Void) == BoardItem.SolidWall:
        break

      nextCandidatePosition = tryingCandidatePosition

    position = nextCandidatePosition
    currentlyFacing = rotateFacing(currentlyFacing, instruction.turn)

  return 1000 * (position[1] + 1) + 4 * (position[0] + 1) + getFaceScore(currentlyFacing)

proc part2*(): int =
  return 2

proc parse*(input: string): (Board, seq[Instruction]) =
  let lines = split(input, "\n")
  let instructionsLine = lines[^1]
  var instructions = newSeq[Instruction]()

  let allCounts = instructionsLine.split({ 'R', 'L' }).mapIt(parseInt(it))
  var currentTurnCharCounter = 0

  for i in 0 .. allCounts.len() - 1:
    currentTurnCharCounter += allCounts[i].intToStr().len()

    instructions.add(Instruction(
      count: allCounts[i],
      turn:
        if i == allCounts.len() - 1: none(Turn)
        elif instructionsLine[currentTurnCharCounter] == 'R': some(Turn.Clockwise)
        else: some(Turn.CounterClockwise)
    ))

    currentTurnCharCounter += 1

  var board = Board()

  for y in 0 .. lines.len() - 3:
    for x in 0 .. lines[y].len() - 1:
      if lines[y][x] == ' ': board.incl(x, y, BoardItem.Void, BoardItem.Void)
      if lines[y][x] == '.': board.incl(x, y, BoardItem.OpenTile, BoardItem.Void)
      if lines[y][x] == '#': board.incl(x, y, BoardItem.SolidWall, BoardItem.Void)

  board = board.fill(BoardItem.Void)

  return (board, instructions)

proc day22(): void = 
  let entireFile = readFile("./build/input.txt")

  let (board, instructions) = parse(entireFile)

  echo fmt"⭐️ Part 1: {part1(board, instructions)}"
  echo fmt"⭐️ Part 2: {part2()}"

if is_main_module:
  day22()
