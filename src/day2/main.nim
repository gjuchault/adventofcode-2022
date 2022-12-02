import std/strutils
import std/strformat
import tables

type Action = enum
  Rock, Paper, Scissors

type GameResult = enum
  Win, Draw, Loose

type GameLine = tuple[opponent: Action, player: Action]

const leftActionMap = {
  "A": Action.Rock,
  "B": Action.Paper,
  "C": Action.Scissors
}.toTable

const rightActionMap = {
  "X": Action.Rock,
  "Y": Action.Paper,
  "Z": Action.Scissors
}.toTable

const scoreByAction = {
  Action.Rock: cast[uint](1),
  Action.Paper: cast[uint](2),
  Action.Scissors: cast[uint](3),
}.toTable

const scoreByGameResult = {
  GameResult.Win: cast[uint](6),
  GameResult.Draw: cast[uint](3),
  GameResult.Loose: cast[uint](0),
}.toTable

proc processGame(game: GameLine): GameResult =
  if (game.opponent == game.player):
    return GameResult.Draw

  if (game.player == Action.Rock and game.opponent == Action.Paper):
    return GameResult.Loose

  if (game.player == Action.Paper and game.opponent == Action.Scissors):
    return GameResult.Loose

  if (game.player == Action.Scissors and game.opponent == Action.Rock):
    return GameResult.Loose

  return GameResult.Win

proc part1(games: seq[GameLine]): uint =
  var score: uint = 0

  for gameLine in games:
    let gameResult = processGame(gameLine)
    score += scoreByAction[gameLine.player] + scoreByGameResult[gameResult]

  return score

proc part2(): uint =
  return 2

proc day2(): void = 
  let entireFile = readFile("./build/input.txt")

  var games: seq[GameLine] = @[]

  for rawStrategyGuideLine in split(entireFile, "\n"):
    let rawLeftAction = $rawStrategyGuideLine[0]
    let rawRightAction = $rawStrategyGuideLine[2]

    var strategyGuideLine: GameLine = (
      leftActionMap[rawLeftAction],
      rightActionMap[rawRightAction],
    )

    games.add(strategyGuideLine)

  echo fmt"Part 1: {part1(games)}"
  echo fmt"Part 2: {part2()}"

day2()
