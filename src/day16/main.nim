import std/[deques, tables, sequtils, sets, strformat, strutils]
import re

type
  ValveInfo = tuple[rate: int, connections: seq[string]]
  VisitValve = tuple[t: int, name: string]

proc allPairs*(input: seq[string]): seq[(string, string)] =
  var pairs = newSeq[(string, string)]();

  for i in 0 .. input.len - 1:
    for j in i + 1 .. input.len - 1:
      pairs.add((input[i], input[j]))

  return pairs

proc bfs*(valves: Table[string, ValveInfo], valveFrom: string, valveTo: string): int =
  var q = [@[valveFrom]].toDeque
  var visited = initHashSet[string]()

  if valveFrom == valveTo:
    return 0

  while q.len > 0:
    let path = q.popFirst()
    let valve = path[ ^1 ]

    if visited.contains(valve):
      continue

    let neighbors = valves[valve].connections

    for neighbor in neighbors:
      var newPath = path
      newPath.add(neighbor)
      q.addLast(newPath)

      if neighbor == valveTo:
        return newPath.len - 1

    visited.incl(valve)

proc computeDistances*(valves: Table[string, ValveInfo]): Table[(string, string), int] =
  let allNodesPairs = allPairs(toSeq(valves.keys))
  var distances = initTable[(string, string), int]()

  for (valveFrom, valveTo) in allNodesPairs:
    if distances.contains((valveFrom, valveTo)): continue

    let distance = bfs(valves, valveFrom, valveTo)

    distances[(valveFrom, valveTo)] = distance
    distances[(valveTo, valveFrom)] = distance

  return distances

proc part1*(valves: Table[string, ValveInfo], distances: Table[(string, string), int]): int =
  const totalTime = 30
  const openValveTime = 1
  let valveSet = filterIt(toSeq(valves.keys), valves[it].rate > 0).toHashSet
  var visited = ["AA"].toHashSet
  var path = ["AA"].toDeque

  proc getScoreRecursiveOneAgent(
    valveSet: HashSet[string],
    visited: var HashSet[string],
    path: var Deque[string],
    elapsed: int,
    released: int,
  ): int =
    let currValve = path.peekLast()
    var maxReleased = released

    for nextValve in valveSet.difference(visited):
      let newElapsed = elapsed + distances[(currValve, nextValve)] + openValveTime
      if newElapsed >= totalTime:
        continue

      visited.incl(nextValve)
      path.addLast(nextValve)
      let contribution = (totalTime - newElapsed) * valves[nextValve].rate

      maxReleased = max(
        maxReleased,
        getScoreRecursiveOneAgent(valveSet, visited, path, newElapsed, released + contribution)
      )

      visited.excl(nextValve)
      path.popLast()
    
    return maxReleased

  return getScoreRecursiveOneAgent(valveSet, visited, path, 0, 0)

proc part2*(valves: Table[string, ValveInfo], distances: Table[(string, string), int]): int =
  const totalTime = 26
  const openValveTime = 1
  let valveSet = filterIt(toSeq(valves.keys), valves[it].rate > 0).toHashSet
  let valveSeq = valveSet.toSeq()
  let allPairsCount = (valveSeq.len - 1) * (valveSeq.len - 2)
  var score = 0

  proc getScoreRecursiveTwoAgents(unvisited: HashSet[string], toVisit: var HashSet[VisitValve]): int =
    let curr = min(toVisit.toSeq())
    toVisit.excl(curr)
    let (t, currValve) = curr
    let contribution = (totalTime - t) * valves[currValve].rate
    var best = 0

    if toVisit.len() > 0:
      best = max(best, getScoreRecursiveTwoAgents(unvisited, toVisit))

    if unvisited.len() > 0:
      for nextValve in unvisited:
        let nextT = t + distances[(currValve, nextValve)] + openValveTime
        if nextT >= totalTime:
          continue

        toVisit.incl((nextT, nextValve))

        # make copy
        let nextUnvisited = unvisited - [nextValve].toHashSet()

        let res = getScoreRecursiveTwoAgents(nextUnvisited, toVisit)
        best = max(best, res)
        toVisit.excl((nextT, nextValve))

    toVisit.incl(curr)

    return contribution + best

  var counter = 1
  for i in 0 .. valveSeq.len() - 1:
    for j in i + 1 .. valveSeq.len() - 1:
      let a = valveSeq[i]
      let b = valveSeq[j]

      var toVisit = [(distances[("AA", a)] + 1, a), (distances[("AA", b)] + 1, b)].toHashSet()
      var unvisited = valveSet.difference([a, b].toHashSet())

      let partialScore = getScoreRecursiveTwoAgents(unvisited, toVisit)
      score = max(score, partialScore)
      echo "✅ " & $counter & "/" & $allPairsCount & " (" & a & "," & b & ") = " & $partialScore
      counter += 1

  return score

proc parse*(input: string): Table[string, ValveInfo] =
  let rawLines = split(input, "\n")
  var valves = initTable[string, ValveInfo](rawLines.len)

  for rawLine in rawLines:
    var matches: array[3, string]
    if match(rawLine, re"Valve ([A-Z]{2}) has flow rate=(\d+); tunnels? leads? to valves? ([A-Z ,]+)", matches):
      valves[matches[0]] = (parseInt(matches[1]), split(matches[2], ", "))

  return valves

proc day16(): void = 
  let entireFile = readFile("./build/input.txt")

  let valves = parse(entireFile)

  let distances = computeDistances(valves)
  echo "✅ Distances"

  echo fmt"⭐️ Part 1: {part1(valves, distances)}"
  echo fmt"⭐️ Part 2: {part2(valves, distances)}"

if is_main_module:
  day16()
