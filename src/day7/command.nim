type Command* = object
  command*: string
  args*: seq[string]
  output*: seq[string]

type CommandRef* = ref Command

proc `$`*(c: CommandRef): string =
  return "$ " & c.command & " " & $c.args & " -> " & $c.output

proc isCommand*(line: string): bool =
  return line[0 .. 3] == "$ cd" or line[0 .. 3] == "$ ls"

proc buildCommands*(lines: seq[string]): seq[ref Command] =
  var commands: seq[ref Command] = @[]

  for i in countup(0, lines.len - 1, 1):
    let line = lines[i]
    if line[0 .. 3] == "$ cd":
      commands.add(CommandRef(
        command: "cd",
        args: @[line[5 .. ^1]],
        output: @[]
      ))
    
    if line[0 .. 3] == "$ ls":
      var output: seq[string] = @[]

      var nextCommandIndex = i + 1
      while lines.len > nextCommandIndex and not isCommand(lines[nextCommandIndex]):
        output.add(lines[nextCommandIndex])
        nextCommandIndex += 1

      commands.add(CommandRef(
        command: "ls",
        args: @[],
        output: output
      ))
  
  return commands
