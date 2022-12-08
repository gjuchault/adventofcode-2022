type Grid*[T] = object
  grid*: seq[seq[T]]

proc `$`*[T](t: Grid[T]): string =
  var output = ""

  for row in t.grid:
    for cell in row:
      output = output & $cell
    output = output & "\n"

  return output

iterator items*[T](g: Grid[T]): (int, int, T) =
  for y in 0 .. g.grid.len - 1:
    for x in 0 .. g.grid[y].len - 1:
      yield (x, y, g.grid[y][x])

proc validate*[T](g: Grid[T]): bool =
  if g.grid.len == 0:
    return false

  let rowSize = g.grid[0].len

  for row in g.grid:
    if row.len != rowSize:
      return false
  
  return true

proc iterate*[T](g: Grid[T], gridIterator: proc (x: int, y: int, value: T)) =
  if not validate(g):
    return

  for y in 0 .. g.grid.len - 1:
    for x in 0 .. g.grid[y].len - 1:
      gridIterator(x, y, g.grid[y][x])

proc incl*[T](g: var Grid[T], x: int, y: int, value: T, fillValue: T) =
  for y in g.grid.len .. int(y):
    var emptyRow: seq[T] = @[]
    for i in 0 .. x:
      emptyRow.add(fillValue)
    
    g.grid.add(emptyRow)

  for x in g.grid[y].len .. int(x):
    g.grid[y].add(fillValue)

  g.grid[y][x] = value

proc get*[T](g: Grid[T], x: int, y: int): T =
  return g.grid[y][x]

proc width*[T](g: Grid[T]): int =
  assert(validate(g) == true)

  return g.grid[0].len

proc height*[T](g: Grid[T]): int =
  assert(validate(g) == true)

  return g.grid.len

proc adjacents*[T](g: Grid[T], x: int, y: int, includeDiagonals: bool): seq[(int, int, T)] =
  if not validate(g):
    return @[]

  let isLeftEdge = x == 0
  let isRightEdge = x == g.grid[0].len - 1
  let isTopEdge = y == 0
  let isBottomEdge = y == g.grid.len - 1

  var output: seq[(int, int, T)] = @[]

  if not isLeftEdge: output.add((x - 1, y, g.grid[y][x - 1]))
  if not isRightEdge: output.add((x + 1, y, g.grid[y][x + 1]))
  if not isTopEdge: output.add((x, y - 1, g.grid[y - 1][x]))
  if not isBottomEdge: output.add((x, y + 1, g.grid[y + 1][x]))

  if not includeDiagonals: return output

  if not isLeftEdge and not isTopEdge: output.add((x - 1, y - 1, g.grid[y - 1][x - 1]))
  if not isLeftEdge and not isBottomEdge: output.add((x - 1, y + 1, g.grid[y + 1][x - 1]))
  if not isRightEdge and not isTopEdge: output.add((x + 1, y - 1, g.grid[y - 1][x + 1]))
  if not isRightEdge and not isBottomEdge: output.add((x + 1, y + 1, g.grid[y + 1][x + 1]))

  return output

proc isEdge*[T](g: Grid[T], x: int, y: int): bool =
  assert(validate(g) == true)

  let isLeftEdge = x == 0
  let isRightEdge = x == g.grid[0].len - 1
  let isTopEdge = y == 0
  let isBottomEdge = y == g.grid.len - 1

  return isLeftEdge or isRightEdge or isTopEdge or isBottomEdge
