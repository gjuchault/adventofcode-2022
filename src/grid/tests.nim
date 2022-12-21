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

suite "inBounds()":
  test "given a grid and a point, it returns wether the point is in bounds":
    let g = Grid[int](
      grid: @[
        @[3,0,3,7,3],
        @[2,5,5,1,2],
        @[6,5,3],
        @[3,3,5,4,9],
        @[3,5,3,9,0]
      ]
    )

    check(g.inBounds(-1, 0) == false)
    check(g.inBounds(0, -1) == false)
    check(g.inBounds(-1, -1) == false)
    check(g.inBounds(0, 0) == true)
    check(g.inBounds(1, 1) == true)
    check(g.inBounds(4, 0) == true)
    check(g.inBounds(3, 2) == false)
    check(g.inBounds(4, 4) == true)

suite "losangeEdge()":
  let g = Grid[int](
    grid: @[
      @[5,4,3,4,5],
      @[4,3,2,3,4],
      @[3,2,1,2,3],
      @[4,3,2,3,4],
      @[5,4,3,4,5]
    ]
  )

  check(g.losangeEdge(2, 2, 1) == @[(2, 3, 2), (1, 2, 2), (2, 1, 2), (3, 2, 2)])
  check(g.losangeEdge(2, 2, 2) == @[(3, 3, 3), (2, 0, 3), (0, 2, 3), (1, 3, 3), (3, 1, 3), (1, 1, 3), (2, 4, 3), (4, 2, 3)])
  check(g.losangeEdge(2, 2, 3) == @[(4, 3, 4), (3, 4, 4), (0, 3, 4), (1, 0, 4), (3, 0, 4), (0, 1, 4), (1, 4, 4), (4, 1, 4)])
  check(g.losangeEdge(2, 2, 4) == @[(0, 0, 5), (4, 0, 5), (0, 4, 5), (4, 4, 5)])
  check(g.losangeEdge(2, 2, 5).len == 0)

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

suite "duplicate()":
  test "given a grid, it returns the same grid":
    var g = Grid[int](grid: @[ @[1] ])
    var g2 = g.duplicate()

    g.grid[0][0] = 2

    check(g2.grid[0][0] == 1)

    g2.grid[0][0] = 3

    check(g.grid[0][0] == 2)

suite "fill()":
  test "given a grid, it returns a squared one":
    var g = Grid[int](
      grid: @[
        @[3, 1],
        @[3, 1, 1, 4],
        @[3, 1, 1],
        @[1]
      ]
    )

    let g2 = g.fill(0)

    check(g2.grid == @[
        @[3, 1, 0, 0],
        @[3, 1, 1, 4],
        @[3, 1, 1, 0],
        @[1, 0, 0, 0]
    ])

suite "reverse()":
  setup:
    let g = Grid[int](
      grid: @[
        @[1, 2, 3],
        @[4, 5, 6],
        @[7, 8, 9],
      ]
    )

  test "given a grid, it can reverse the x axis":
    check(g.reverse(true, false).grid == @[
      @[3, 2, 1],
      @[6, 5, 4],
      @[9, 8, 7],
    ])
  test "given a grid, it can reverse the y axis":
    check(g.reverse(false, true).grid == @[
      @[7, 8, 9],
      @[4, 5, 6],
      @[1, 2, 3],
    ])
  test "given a grid, it can reverse both the x and y axis":
    check(g.reverse(true, true).grid == @[
      @[9, 8, 7],
      @[6, 5, 4],
      @[3, 2, 1],
    ])

suite "slice()":
  test "given a grid, it returns a sliced one":
    let g = Grid[int](
      grid: @[
        @[3, 1, 0, 0],
        @[3, 1, 2, 4],
        @[1, 3, 4, 0],
        @[2, 2, 2, 2]
      ]
    )

    let newG = g.slice(1, 2, 1, 2)

    check(newG.grid == @[
        @[1, 2],
        @[3, 4],
    ])

suite "sliceByRemovingFill()":
  test "given a grid with filled corners, it returns a sliced one":
    check(
      Grid[int](
        grid: @[
          @[0, 0, 0, 0],
          @[0, 1, 2, 0],
          @[0, 3, 4, 0],
          @[0, 0, 0, 0]
        ]
      ).sliceByRemovingFill(0).grid == @[
          @[1, 2],
          @[3, 4],
      ]
    )

    check(
      Grid[int](
        grid: @[
          @[0, 0, 0, 0],
          @[0, 1, 2, 1],
          @[0, 3, 4, 0],
          @[0, 0, 0, 0]
        ]
      ).sliceByRemovingFill(0).grid == @[
          @[1, 2, 1],
          @[3, 4, 0],
      ]
    )

    check(
      Grid[int](
        grid: @[
          @[0, 0, 0, 0],
          @[0, 1, 2, 0],
          @[0, 3, 4, 0],
          @[0, 1, 0, 0]
        ]
      ).sliceByRemovingFill(0).grid == @[
          @[1, 2],
          @[3, 4],
          @[1, 0],
      ]
    )
