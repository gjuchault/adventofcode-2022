import main
import unittest

let firstExample = parse("""        ...#
        .#..
        #...
        ....
...#.......#
........#...
..#....#....
..........#.
        ...#....
        .....#..
        .#......
        ......#.

10R5L5R10L4R5L5""")

let surroundedByWalls = parse("""########
#......#
#......#
#......#
########

10R5L5R10L4R5L5""")

suite "getFirstCoordAfterVoidWrap()":
  test "given example grid and a coord that wraps without walls, it returns the correct open tile":
    check(getFirstCoordAfterVoidWrap(firstExample[0], (11, 5), Facing.Right) == (0, 5))
    check(getFirstCoordAfterVoidWrap(firstExample[0], (0, 5), Facing.Left) == (11, 5))
    check(getFirstCoordAfterVoidWrap(firstExample[0], (1, 4), Facing.Top) == (1, 7))
    check(getFirstCoordAfterVoidWrap(firstExample[0], (1, 7), Facing.Bottom) == (1, 4))
  
  test "given example grid and a coord that wraps with walls, it returns the correct wall tile":
    check(getFirstCoordAfterVoidWrap(surroundedByWalls[0], (1, 0), Facing.Top) == (1, 4))
    check(getFirstCoordAfterVoidWrap(surroundedByWalls[0], (1, 4), Facing.Bottom) == (1, 0))
    check(getFirstCoordAfterVoidWrap(surroundedByWalls[0], (0, 1), Facing.Left) == (7, 1))
    check(getFirstCoordAfterVoidWrap(surroundedByWalls[0], (7, 1), Facing.Right) == (0, 1))

suite "part1()":
  test "given example(s), it returns the expected result(s)":
    check(part1(firstExample[0], firstExample[1]) == 6032)

suite "part2()":
  test "given example(s), it returns the expected result(s)":
    check(2 == 2)
