import std/strutils
import std/strformat
import tables
import game

const leftActionMap = {
  "A": Action.Rock,
  "B": Action.Paper,
  "C": Action.Scissors
}.toTable

const rightActionPart1Map = {
  "X": Action.Rock,
  "Y": Action.Paper,
  "Z": Action.Scissors
}.toTable

const rightActionPart2Map = {
  "X": GameResult.Loose,
  "Y": GameResult.Draw,
  "Z": GameResult.Win
}.toTable

proc part1(games: seq[GameLine]): uint =
  var score: uint = 0

  for gameLine in games:
    score += computeScore(gameLine.part1Player, gameLine.opponent)

  return score

proc part2(games: seq[GameLine]): uint =
  var score: uint = 0

  for gameLine in games:
    let action = processWhatToPlay(gameLine)
    score += computeScore(action, gameLine.opponent)

  return score

proc day2(): void = 
  let entireFile = readFile("./build/input.txt")

  var games: seq[GameLine] = @[]

  for rawStrategyGuideLine in split(entireFile, "\n"):
    let rawLeftAction = $rawStrategyGuideLine[0]
    let rawRightAction = $rawStrategyGuideLine[2]

    var strategyGuideLine: GameLine = (
      leftActionMap[rawLeftAction],
      rightActionPart1Map[rawRightAction],
      rightActionPart2Map[rawRightAction]
    )

    games.add(strategyGuideLine)

  echo fmt"Part 1: {part1(games)}"
  echo fmt"Part 2: {part2(games)}"

day2()
