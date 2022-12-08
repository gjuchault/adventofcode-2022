import grid
import unittest

suite "validate()":
  test "given a valid grid, it returns nothing":
    let g = Grid[int](
      grid: @[
        @[3,0,3,7,3],
        @[2,5,5,1,2],
        @[6,5,3,3,2],
        @[3,3,5,4,9],
        @[3,5,3,9,0]
      ]
    )

    check(validate(g) == true)
  
  test "given an invalid grid, it throws":
    let invalidG = Grid[int](
      grid: @[
        @[3,0,3,7,3],
        @[2,5,5,1,2,1],
        @[6,5,3,3,2],
        @[3,3,5,4,9],
        @[3,5,3,9,0]
      ]
    )

    check(validate(invalidG) == false)

suite "iterate()":
  test "given a grid, it iterates over all the grid":
    let g = Grid[int](
      grid: @[
        @[3,0,3,7,3],
        @[2,5,5,1,2],
        @[6,5,3,3,2],
        @[3,3,5,4,9],
        @[3,5,3,9,0]
      ]
    )
    var calls: seq[(int, int, int)] = @[]
    
    g.iterate(
      proc (x: int, y: int, v: int) =
        calls.add((x, y, v))
    )
    
    check(calls == @[
      (0, 0, 3), (1, 0, 0), (2, 0, 3), (3, 0, 7), (4, 0, 3),
      (0, 1, 2), (1, 1, 5), (2, 1, 5), (3, 1, 1), (4, 1, 2),
      (0, 2, 6), (1, 2, 5), (2, 2, 3), (3, 2, 3), (4, 2, 2),
      (0, 3, 3), (1, 3, 3), (2, 3, 5), (3, 3, 4), (4, 3, 9),
      (0, 4, 3), (1, 4, 5), (2, 4, 3), (3, 4, 9), (4, 4, 0)
    ])

suite "incl()":
  test "given a filled grid, it replaces the expected cell":
    var g = Grid[int](
      grid: @[
        @[3,0,3,7,3],
        @[2,5,5,1,2],
        @[6,999,3,3,2],
        @[3,3,5,4,9],
        @[3,5,3,9,0]
      ]
    )

    check(g.grid[2][1] == 999)
    g.incl(1, 2, 12, 0)
    check(g.grid[2][1] == 12)

  test "given an empty grid, it fillus up to the expected cell":
    var g = Grid[int](
      grid: @[]
    )

    g.incl(4, 3, 12, 0)

    check(g.grid == @[
      @[0, 0, 0, 0, 0],
      @[0, 0, 0, 0, 0],
      @[0, 0, 0, 0, 0],
      @[0, 0, 0, 0, 12],
    ])

suite "adjacents()":
  test "given a grid and some coordinates, it returns the adjacents cells":
    let g = Grid[int](
      grid: @[
        @[3,0,3,7,3],
        @[2,5,5,1,2],
        @[6,5,3,3,2],
        @[3,3,5,4,9],
        @[3,5,3,9,0]
      ]
    )

    check(g.adjacents(0, 0, false) == @[(1, 0, 0), (0, 1, 2)])
    check(g.adjacents(0, 1, false) == @[(1, 1, 5), (0, 0, 3), (0, 2, 6)])
    check(g.adjacents(1, 0, false) == @[(0, 0, 3), (2, 0, 3), (1, 1, 5)])
    check(g.adjacents(1, 1, false) == @[(0, 1, 2), (2, 1, 5), (1, 0, 0), (1, 2, 5)])
    check(g.adjacents(4, 0, false) == @[(3, 0, 7), (4, 1, 2)])
    check(g.adjacents(0, 4, false) == @[(1, 4, 5), (0, 3, 3)])
    check(g.adjacents(4, 4, false) == @[(3, 4, 9), (4, 3, 9)])
    check(g.adjacents(0, 0, true) == @[(1, 0, 0), (0, 1, 2), (1, 1, 5)])
    check(g.adjacents(0, 1, true) == @[(1, 1, 5), (0, 0, 3), (0, 2, 6), (1, 0, 0), (1, 2, 5)])
    check(g.adjacents(1, 0, true) == @[(0, 0, 3), (2, 0, 3), (1, 1, 5), (0, 1, 2), (2, 1, 5)])
    check(g.adjacents(1, 1, true) == @[(0, 1, 2), (2, 1, 5), (1, 0, 0), (1, 2, 5), (0, 0, 3), (0, 2, 6), (2, 0, 3), (2, 2, 3)])
    check(g.adjacents(4, 0, true) == @[(3, 0, 7), (4, 1, 2), (3, 1, 1)])
    check(g.adjacents(0, 4, true) == @[(1, 4, 5), (0, 3, 3), (1, 3, 3)])
    check(g.adjacents(4, 4, true) == @[(3, 4, 9), (4, 3, 9), (3, 3, 4)])

suite "isEdge()":
  test "given a grid and some coordinates, it returns wether the cell is an edge":
    let g = Grid[int](
      grid: @[
        @[3,0,3,7,3],
        @[2,5,5,1,2],
        @[6,5,3,3,2],
        @[3,3,5,4,9],
        @[3,5,3,9,0]
      ]
    )

    check(g.isEdge(0, 0) == true)
    check(g.isEdge(0, 1) == true)
    check(g.isEdge(1, 0) == true)
    check(g.isEdge(1, 1) == false)
    check(g.isEdge(4, 0) == true)
    check(g.isEdge(0, 4) == true)
    check(g.isEdge(4, 4) == true)

suite "get()":
  test "given a grid and some coordinates, it returns the value":
    let g = Grid[int](
      grid: @[
        @[3,0,3,7,3],
        @[2,5,5,1,2],
        @[6,5,3,3,2],
        @[3,3,5,4,9],
        @[4,5,3,9,0]
      ]
    )

    check(g.get(0, 0) == 3)
    check(g.get(0, 1) == 2)
    check(g.get(1, 0) == 0)
    check(g.get(1, 1) == 5)
    check(g.get(4, 0) == 3)
    check(g.get(0, 4) == 4)
    check(g.get(4, 4) == 0)

suite "width()":
  test "given a grid, it returns the width":
    let g = Grid[int](
      grid: @[
        @[3,0,3,7,3],
        @[2,5,5,1,2],
        @[6,5,3,3,2],
        @[3,3,5,4,9],
        @[4,5,3,9,0]
      ]
    )

    check(g.width() == 5)

suite "height()":
  test "given a grid, it returns the height":
    let g = Grid[int](
      grid: @[
        @[3,0,3,7,3],
        @[2,5,5,1,2],
        @[6,5,3,3,2],
      ]
    )

    check(g.height() == 3)
