import std/sequtils
import std/strutils
import std/strformat
import std/deques
import std/sets
import std/tables
import std/re

type Node = object
  rate: int
  connections: seq[string]

type ExplorationQueueItem = object
  path: seq[string]
  elapsed: int
  valvesOpenedAt: Table[string, int]

proc allPairs*(input: seq[string]): seq[(string, string)] =
  var pairs = newSeq[(string, string)]();

  for i in 0 .. input.len - 1:
    for j in i + 1 .. input.len - 1:
      pairs.add((input[i], input[j]))

  return pairs

proc bfs*(nodes: Table[string, ref Node], nodeFrom: string, nodeTo: string): int =
  var q = [@[nodeFrom]].toDeque
  var visited = initHashSet[string]()

  if nodeFrom == nodeTo:
    return 0

  while q.len > 0:
    let path = q.popFirst()
    let node = path[ ^1 ]

    if visited.contains(node):
      continue

    let neighbors = nodes[node].connections

    for neighbor in neighbors:
      var newPath = path
      newPath.add(neighbor)
      q.addLast(newPath)

      if neighbor == nodeTo:
        return newPath.len - 1

    visited.incl(node)

proc part1*(nodes: Table[string, ref Node]): int =
  let allNodesPairs = allPairs(toSeq(nodes.keys))
  var distances = initTable[(string, string), int]()

  for (nodeFrom, nodeTo) in allNodesPairs:
    if distances.contains((nodeFrom, nodeTo)): continue

    let distance = bfs(nodes, nodeFrom, nodeTo)

    distances[(nodeFrom, nodeTo)] = distance
    distances[(nodeTo, nodeFrom)] = distance

  let allPotentialValves = filterIt(toSeq(nodes.keys), nodes[it].rate > 0)
  let maxTime = 30

  var queue = @[
    ExplorationQueueItem(path: @["AA"], elapsed: 0, valvesOpenedAt: initTable[string, int]())
  ]

  var maximumPressure = 0

  while queue.len > 0:
    let explorationQueue = queue.pop()
    let currentValve = explorationQueue.path[ ^1 ]

    if explorationQueue.elapsed >= maxTime or explorationQueue.path.len == allPotentialValves.len + 1:
      var pressureReleased = 0

      for valve, valveOpenedAt in explorationQueue.valvesOpenedAt.pairs:
        let minutesOpened = max(maxTime - valveOpenedAt, 0)
        pressureReleased += nodes[valve].rate * minutesOpened

      maximumPressure = max(maximumPressure, pressureReleased)
    else:
      for nextValve in allPotentialValves:
        if explorationQueue.valvesOpenedAt.hasKey(nextValve):
          continue

        if currentValve == nextValve: continue

        let travelTime = distances[(currentValve, nextValve)]
        let timeToOpenValve = 1

        let newElapsed = explorationQueue.elapsed + travelTime + timeToOpenValve
        # assigning the table will create a copy
        var newValvesOpenedAt = explorationQueue.valvesOpenedAt
        newValvesOpenedAt[nextValve] = newElapsed

        var newPath = explorationQueue.path
        newPath.add(nextValve)

        queue.add(
          ExplorationQueueItem(path: newPath, elapsed: newElapsed, valvesOpenedAt: newValvesOpenedAt)
        )

  return maximumPressure

proc part2*(): int =
  return 2

proc parse*(input: string): Table[string, ref Node] =
  var nodes = initTable[string, ref Node](50)

  for rawLine in split(input, "\n"):
    var matches: array[3, string]
    if match(rawLine, re"Valve ([A-Z]{2}) has flow rate=(\d+); tunnels? leads? to valves? ([A-Z ,]+)", matches):
      let node = new(Node)
      node.rate = parseInt(matches[1])
      node.connections = split(matches[2], ", ")
      nodes[matches[0]] = node

  return nodes

proc day16(): void = 
  let entireFile = readFile("./build/input.txt")

  let nodes = parse(entireFile)

  echo fmt"⭐️ Part 1: {part1(nodes)}"
  echo fmt"⭐️ Part 2: {part2()}"

if is_main_module:
  day16()
