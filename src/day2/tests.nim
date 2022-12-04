import main
import game
import unittest

suite "processGame()":
  test "given a win situation, it returns win":
    check(processGame(Action.Rock, Action.Scissors) == GameResult.Win)
    check(processGame(Action.Scissors, Action.Paper) == GameResult.Win)
    check(processGame(Action.Paper, Action.Rock) == GameResult.Win)

  test "given a draw situation, it returns draw":
    check(processGame(Action.Rock, Action.Rock) == GameResult.Draw)
    check(processGame(Action.Scissors, Action.Scissors) == GameResult.Draw)
    check(processGame(Action.Paper, Action.Paper) == GameResult.Draw)

  test "given a loose situation, it returns loose":
    check(processGame(Action.Scissors, Action.Rock) == GameResult.Loose)
    check(processGame(Action.Paper, Action.Scissors) == GameResult.Loose)
    check(processGame(Action.Rock, Action.Paper) == GameResult.Loose)

suite "processWhatToPlay()":
  test "given the decision to loose, it picks the loosing action":
    check(processWhatToPlay((opponent: Action.Rock, part1Player: Action.Rock, part2GameResult: GameResult.Loose)) == Action.Scissors)
    check(processWhatToPlay((opponent: Action.Paper, part1Player: Action.Rock, part2GameResult: GameResult.Loose)) == Action.Rock)
    check(processWhatToPlay((opponent: Action.Scissors, part1Player: Action.Rock, part2GameResult: GameResult.Loose)) == Action.Paper)

  test "given the decision to win, it picks the winning action":
    check(processWhatToPlay((opponent: Action.Rock, part1Player: Action.Rock, part2GameResult: GameResult.Win)) == Action.Paper)
    check(processWhatToPlay((opponent: Action.Paper, part1Player: Action.Rock, part2GameResult: GameResult.Win)) == Action.Scissors)
    check(processWhatToPlay((opponent: Action.Scissors, part1Player: Action.Rock, part2GameResult: GameResult.Win)) == Action.Rock)

  test "given the decision to draw, it picks the draw action":
    check(processWhatToPlay((opponent: Action.Rock, part1Player: Action.Rock, part2GameResult: GameResult.Draw)) == Action.Rock)
    check(processWhatToPlay((opponent: Action.Paper, part1Player: Action.Rock, part2GameResult: GameResult.Draw)) == Action.Paper)
    check(processWhatToPlay((opponent: Action.Scissors, part1Player: Action.Rock, part2GameResult: GameResult.Draw)) == Action.Scissors)

suite "computeScore()":
  test "given a game line, it computes the score":
    check(computeScore(Action.Paper, Action.Rock) == 8)
    check(computeScore(Action.Rock, Action.Paper) == 1)
    check(computeScore(Action.Scissors, Action.Scissors) == 6)

let firstExample: seq[GameLine] = @[
  (opponent: Action.Rock, part1Player: Action.Paper, part2GameResult: GameResult.Draw),
  (opponent: Action.Paper, part1Player: Action.Rock, part2GameResult: GameResult.Loose),
  (opponent: Action.Scissors, part1Player: Action.Scissors, part2GameResult: GameResult.Win)
]

suite "part1()":
  test "given first example, it returns the expected result":
    check(part1(firstExample) == 15)

suite "part2()":
  test "given first example, it returns the expected result":
    check(part2(firstExample) == 12)

