import std/strutils
import std/tables
import std/options
import command

type Directory* = object
  name: string
  size*: uint
  files*: Table[string, uint]
  directories*: Table[string, ref Directory]
  parent*: Option[ref Directory]

type DirectoryRef* = ref Directory

proc `$`*(d: DirectoryRef): string =
  var countOfParents = 0
  var currentParent = d.parent
  while currentParent.isSome:
    countOfParents += 1
    currentParent = currentParent.get().parent

  var output = " ".repeat(countOfParents * 2) & " - " & d.name & " (dir, size=" & $d.size & ")\n"

  for fileName, fileSize in d.files.pairs:
    output = output & " ".repeat((countOfParents + 1) * 2) & " - " & fileName & " (file, size=" & $fileSize & ")\n"

  for directory in d.directories.values:
    output = output & $directory

  return output

proc buildTree*(commands: seq[ref Command]): ref Directory =
  var rootDir = DirectoryRef(
    name: "/",
    size: 0,
    files: initTable[string, uint](),
    directories: initTable[string, ref Directory](),
    parent: none(ref Directory)
  )

  var currentDir = rootDir

  for command in commands:
    if command.command == "cd":
      let folderName = command.args[0]

      if folderName == "/":
        continue;

      if folderName == "..":
        if currentDir.parent.isNone:
          echo "Can not cd out of root directory"
          system.quit(1)
        currentDir = currentDir.parent.get()
        continue;

      if currentDir.directories.hasKey(folderName):
        currentDir = currentDir.directories[folderName]
        continue;

      let newDirectory = DirectoryRef(
        name: folderName,
        size: 0,
        files: initTable[string, uint](),
        directories: initTable[string, ref Directory](),
        parent: some(currentDir)
      )

      currentDir.directories[folderName] = newDirectory
      currentDir = newDirectory

    if command.command == "ls":
      for line in command.output:
        if line[0 .. 2] == "dir":
          continue
        
        let rawFileAndSize = split(line, ' ')
        let fileSize = parseUint(rawFileAndSize[0])
        let fileName = rawFileAndSize[1]

        currentDir.files[fileName] = fileSize
      
      var directorySize: uint = 0
      for fileSize in currentDir.files.values:
        directorySize += fileSize

      currentDir.size = directorySize

      # we increment during ls instead of after building the whole tree which
      # avoids a BFS/DFS afterwards but requires ls to be called once per dir
      var currentParentToIncrement = currentDir.parent
      while currentParentToIncrement.isSome:
        currentParentToIncrement.get().size += directorySize
        currentParentToIncrement = currentParentToIncrement.get().parent

  return rootDir
