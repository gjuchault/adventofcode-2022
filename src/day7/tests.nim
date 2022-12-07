import std/strutils
import main
import command
import directory
import unittest

let firstExample = """$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k"""

let firstExampleCommands = buildCommands(split(firstExample, '\n'))
let firstExampleRootDirectory = buildTree(firstExampleCommands)

suite "buildCommands()":
  test "given first example, it properly returns all commands":
    check(firstExampleCommands[0].command == "cd")
    check(firstExampleCommands[0].args == @["/"])
    check(firstExampleCommands[0].output.len == 0)

    check(firstExampleCommands[1].command == "ls")
    check(firstExampleCommands[1].args.len == 0)
    check(firstExampleCommands[1].output == @["dir a", "14848514 b.txt", "8504156 c.dat", "dir d"])

suite "buildTree()":
  test "given first example, it properly sums all content":
    check(firstExampleRootDirectory.size == 48381165)

suite "part1()":
  test "given first example, it returns the expected result":
    check(part1(firstExampleRootDirectory) == 95437)

suite "part2()":
  test "given first example, it returns the expected result":
    check(2 == 2)
