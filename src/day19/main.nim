import std/math
import std/strutils
import std/strformat
import std/re
import std/options

type Kind = enum Ore, Clay, Obsidian, Geode

type Blueprint = tuple
  index: int
  oreRobotCost: int
  clayRobotCost: int
  obsidianRobotCost: (int, int)
  geodeRobotCost: (int, int)

type State = tuple
  timeLeft: int
  resources: (int, int, int, int)
  bots: (int, int, int, int)

proc max(numbers: varargs[int]): int =
  assert(numbers.len > 0)

  var maxValue = numbers[0]
  for number in numbers:
    if number > maxValue: maxValue = number
  
  return maxValue

proc canBuildBot(blueprint: ref Blueprint, state: State, botKind: Kind): bool =
  case botKind:
  of Kind.Ore:
    return state.bots[0] > 0
  of Kind.Clay:
    return state.bots[0] > 0
  of Kind.Obsidian:
    return state.bots[0] > 0 and state.bots[1] > 0
  of Kind.Geode:
    return state.bots[0] > 0 and state.bots[2] > 0

proc addBot(currentBots: (int, int, int, int), botKind: Kind): (int, int, int, int) =
  case botKind:
  of Kind.Ore: return (currentBots[0] + 1, currentBots[1], currentBots[2], currentBots[3])
  of Kind.Clay: return (currentBots[0], currentBots[1] + 1, currentBots[2], currentBots[3])
  of Kind.Obsidian: return (currentBots[0], currentBots[1], currentBots[2] + 1, currentBots[3])
  of Kind.Geode: return (currentBots[0], currentBots[1], currentBots[2], currentBots[3] + 1)

proc deductResources(blueprint: ref Blueprint, currentResources: (int, int, int, int), botKind: Kind): (int, int, int, int) =
  case botKind:
  of Kind.Ore:
    return (currentResources[0] - blueprint.oreRobotCost, currentResources[1], currentResources[2], currentResources[3])
  of Kind.Clay:
    return (currentResources[0] - blueprint.clayRobotCost, currentResources[1], currentResources[2], currentResources[3])
  of Kind.Obsidian:
    return (currentResources[0] - blueprint.obsidianRobotCost[0], currentResources[1] - blueprint.obsidianRobotCost[1], currentResources[2], currentResources[3])
  of Kind.Geode:
    return (currentResources[0] - blueprint.geodeRobotCost[0], currentResources[1], currentResources[2] - blueprint.geodeRobotCost[1], currentResources[3])

proc increaseResources(state: State, multiplier: int = 1): (int, int, int, int) =
  return (
    state.resources[0] + state.bots[0] * multiplier,
    state.resources[1] + state.bots[1] * multiplier,
    state.resources[2] + state.bots[2] * multiplier,
    state.resources[3] + state.bots[3] * multiplier,
  )

proc timeToResource(cost: int, resources: int, bots: int): int =
  return toInt(
    ceil(
      toFloat(cost - resources) / toFloat(bots)
    )
  )

proc tryToCreateBot(blueprint: ref Blueprint, state: State, botKind: Kind, minTimeToGetAGeode: int): Option[State] =
  if not canBuildBot(blueprint, state, botKind): return none(State)

  # optimization: instead of ahving waiting turns, just wait the amount of turns
  # necessary to create the next kind of robot
  var timeToCreateBotWithCurrentBots = 0

  case botKind:
  of Kind.Ore:
    timeToCreateBotWithCurrentBots = max(
      timeToCreateBotWithCurrentBots,
      timeToResource(blueprint.oreRobotCost, state.resources[0], state.bots[0])
    )
  of Kind.Clay:
    timeToCreateBotWithCurrentBots = max(
      timeToCreateBotWithCurrentBots,
      timeToResource(blueprint.clayRobotCost, state.resources[0], state.bots[0])
    )
  of Kind.Obsidian:
    timeToCreateBotWithCurrentBots = max(
      timeToCreateBotWithCurrentBots,
      timeToResource(blueprint.obsidianRobotCost[0], state.resources[0], state.bots[0]),
      timeToResource(blueprint.obsidianRobotCost[1], state.resources[1], state.bots[1])
    )
  of Kind.Geode:
    timeToCreateBotWithCurrentBots = max(
      timeToCreateBotWithCurrentBots,
      timeToResource(blueprint.geodeRobotCost[0], state.resources[0], state.bots[0]),
      timeToResource(blueprint.geodeRobotCost[1], state.resources[2], state.bots[2])
    )

  if state.timeLeft - timeToCreateBotWithCurrentBots >= minTimeToGetAGeode:
    return some((
      timeLeft: state.timeLeft - timeToCreateBotWithCurrentBots - 1,
      resources: deductResources(blueprint, increaseResources(state, timeToCreateBotWithCurrentBots + 1), botKind),
      bots: addBot(state.bots, botKind),
    ))

  return none(State)

proc getNewStatesForNextBots(blueprint: ref Blueprint, state: State): seq[State] =
  var newStates = newSeq[State]()

  let geodeBotPath = tryToCreateBot(blueprint, state, Kind.Geode, 1)
  if geodeBotPath.isSome(): newStates.add(geodeBotPath.get())

  let obsidianBotPath = tryToCreateBot(blueprint, state, Kind.Obsidian, 4)
  if obsidianBotPath.isSome(): newStates.add(obsidianBotPath.get())

  let clayBotPath = tryToCreateBot(blueprint, state, Kind.Clay, 7)
  if state.bots[1] < blueprint.obsidianRobotCost[1] - 1:
    if clayBotPath.isSome(): newStates.add(clayBotPath.get())
  
  let oreBotPath = tryToCreateBot(blueprint, state, Kind.Ore, 16)
  if state.bots[0] < 4:
    if oreBotPath.isSome(): newStates.add(oreBotPath.get())

  # we will never be able to build any new bot, skip to the end
  if geodeBotPath.isNone() and obsidianBotPath.isNone() and clayBotPath.isNone() and oreBotPath.isNone():
    newStates.add((
        timeLeft: 0,
        resources: increaseResources(state, state.timeLeft),
        bots: state.bots
    ))

  return newStates

proc part1*(blueprints: seq[ref Blueprint]): int =
  var score = 0

  for blueprint in blueprints:
    var queue: seq[State] = @[ (timeLeft: 24, resources: (0, 0, 0, 0), bots: (1, 0, 0, 0)) ]
    var maxGeodes = 0
    var earliestGeode = 0

    while queue.len > 0:
      let state = queue.pop()

      # optimization: earliest geode path is always winner path
      if state.resources[3] > 0 and state.timeLeft > earliestGeode: earliestGeode = state.timeLeft
      if state.timeLeft < earliestGeode and state.resources[3] == 0: continue

      if state.timeLeft <= 0:
        maxGeodes = max(maxGeodes, state.resources[3])
        continue

      for newState in getNewStatesForNextBots(blueprint, state):
        queue.add(newState)

    score += maxGeodes * blueprint.index

  return score

proc part2*(blueprints: seq[ref Blueprint]): int =
  var score = 1

  for blueprint in blueprints[ 0 .. min(2, blueprints.len - 1) ]:
    var queue: seq[State] = @[ (timeLeft: 32, resources: (0, 0, 0, 0), bots: (1, 0, 0, 0)) ]
    var maxGeodes = 0
    var earliestGeode = 0

    while queue.len > 0:
      let state = queue.pop()

      # optimization: earliest geode path is always winner path
      if state.resources[3] > 0 and state.timeLeft > earliestGeode: earliestGeode = state.timeLeft
      if state.timeLeft < earliestGeode and state.resources[3] == 0: continue

      if state.timeLeft <= 0:
        maxGeodes = max(maxGeodes, state.resources[3])
        continue

      for newState in getNewStatesForNextBots(blueprint, state):
        queue.add(newState)

    score *= maxGeodes

  return score

proc parse*(input: string): seq[ref Blueprint] =
  var blueprints: seq[ref Blueprint] = @[]

  var index = 1

  for line in split(input, "\n"):
    var blueprint = new(Blueprint)
    let robotKinds = [Kind.Ore, Kind.Clay, Kind.Obsidian, Kind.Geode]
    var currentRobotKind = 0

    blueprint.index = index
    index += 1

    for rawComponent in line[ line.find(":") + 2 .. ^1 ].split(". "):
      let allNumbers = findAll(rawComponent, re"(\d+)")

      case robotKinds[currentRobotKind]:
      of Kind.Ore:
        blueprint.oreRobotCost = (parseInt(allNumbers[0]))
      of Kind.Clay:
        blueprint.clayRobotCost = (parseInt(allNumbers[0]))
      of Kind.Obsidian:
        blueprint.obsidianRobotCost = (parseInt(allNumbers[0]), parseInt(allNumbers[1]))
      of Kind.Geode:
        blueprint.geodeRobotCost = (parseInt(allNumbers[0]), parseInt(allNumbers[1]))

      currentRobotKind += 1

    blueprints.add(blueprint)

  return blueprints

proc day19(): void = 
  let entireFile = readFile("./build/input.txt")
  let blueprints = parse(entireFile)

  echo fmt"⭐️ Part 1: {part1(blueprints)}"
  echo fmt"⭐️ Part 2: {part2(blueprints)}"

if is_main_module:
  day19()
