import tables

type Action* = enum
  Rock, Paper, Scissors

type GameResult* = enum
  Win, Draw, Loose

type GameLine* = tuple[opponent: Action, part1Player: Action, part2GameResult: GameResult]

const actionWinByAction = {
  Action.Rock: Action.Paper,
  Action.Paper: Action.Scissors,
  Action.Scissors: Action.Rock
}.toTable

const actionLooseByAction = {
  Action.Paper: Action.Rock,
  Action.Scissors: Action.Paper,
  Action.Rock: Action.Scissors
}.toTable

const scoreByAction* = {
  Action.Rock: uint(1),
  Action.Paper: uint(2),
  Action.Scissors: uint(3),
}.toTable

const scoreByGameResult* = {
  GameResult.Win: uint(6),
  GameResult.Draw: uint(3),
  GameResult.Loose: uint(0),
}.toTable

proc processGame*(player: Action, opponent: Action): GameResult =
  if (opponent == player):
    return GameResult.Draw

  if (actionWinByAction[player] == opponent):
    return GameResult.Loose

  return GameResult.Win

proc processWhatToPlay*(game: GameLine): Action =
  case game.part2GameResult
    of Draw:
      return game.opponent
    of Loose:
      return actionLooseByAction[game.opponent]
    of Win:
      return actionWinByAction[game.opponent]

proc computeScore*(player: Action, opponent: Action): uint =
  let gameResult = processGame(player, opponent)
  return scoreByAction[player] + scoreByGameResult[gameResult]
