import std/strutils
import std/strformat
import "../grid/grid"

type TreeGrid* = Grid[int]

proc part1*(treeGrid: TreeGrid): uint =
  var output: uint = 0

  for (x, y, v) in treeGrid:
    if treeGrid.isEdge(x, y):
      output += 1
      continue
    
    var visibleFromTop = true
    for topY in 0 .. y - 1:
      if treeGrid.get(x, topY) >= v:
        visibleFromTop = false
        break;

    var visibleFromRight = true
    for rightX in x + 1 .. treeGrid.width() - 1:
      if treeGrid.get(rightX, y) >= v:
        visibleFromRight = false
        break;

    var visibleFromBottom = true
    for bottomY in y + 1 .. treeGrid.height() - 1:
      if treeGrid.get(x, bottomY) >= v:
        visibleFromBottom = false
        break;

    var visibleFromLeft = true
    for leftX in 0 .. x - 1:
      if treeGrid.get(leftX, y) >= v:
        visibleFromLeft = false
        break;
    
    if visibleFromTop or visibleFromRight or visibleFromBottom or visibleFromLeft: output += 1

  return output

proc part2*(treeGrid: TreeGrid): uint =
  var output: uint = 0

  for (x, y, v) in treeGrid:
    if treeGrid.isEdge(x, y):
      continue

    var scoreFromTop: uint = 0
    for topY in countdown(y - 1, 0, 1):
      scoreFromTop += 1
      if treeGrid.get(x, topY) >= v:
        break;

    var scoreFromRight: uint = 0
    for rightX in x + 1 .. treeGrid.width() - 1:
      scoreFromRight += 1
      if treeGrid.get(rightX, y) >= v:
        break;

    var scoreFromBottom: uint = 0
    for bottomY in y + 1 .. treeGrid.height() - 1:
      scoreFromBottom += 1
      if treeGrid.get(x, bottomY) >= v:
        break;

    var scoreFromLeft: uint = 0
    for leftX in countdown(x - 1, 0, 1):
      scoreFromLeft += 1
      if treeGrid.get(leftX, y) >= v:
        break;

    let treeScore = scoreFromTop * scoreFromRight * scoreFromBottom * scoreFromLeft

    output = max(treeScore, output)

  return output

proc day8(): void = 
  let entireFile = readFile("./build/input.txt")

  var treeGrid = TreeGrid()

  for rawRow in split(entireFile, '\n'):
    var row: seq[int] = @[]
    for rawCell in rawRow:
      row.add(parseInt($rawCell))
    treeGrid.grid.add(row)
  
  echo fmt"⭐️ Part 1: {part1(treeGrid)}"
  echo fmt"⭐️ Part 2: {part2(treeGrid)}"

if is_main_module:
  day8()
