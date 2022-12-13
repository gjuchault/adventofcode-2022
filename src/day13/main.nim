import std/strutils
import std/sequtils
import std/strformat
import std/json

type PairKind* = enum Integer, List

type PairItem* = object
  case kind: PairKind
  of Integer: integer: BiggestInt
  of List: list: seq[ref PairItem]

type PairItemRef* = ref PairItem

type ComparisonResult* = enum Continue, RightOrder, NotRightOrder

proc `$`*(pi: PairItemRef): string =
  if pi.kind == PairKind.Integer: return $pi.integer
  elif pi.kind == PairKind.List: return "[" & join(pi.list, ",") & "]"

proc compare*(left: ref PairItem, right: ref PairItem): ComparisonResult =
  # echo "comparing " & $left & " and " & $right
  if left.kind == PairKind.Integer and right.kind == PairKind.Integer:
    if left.integer == right.integer:
      return ComparisonResult.Continue
    elif left.integer < right.integer:
      return ComparisonResult.RightOrder
    else: return ComparisonResult.NotRightOrder

  if left.kind == PairKind.List and right.kind == PairKind.List:
    # echo "comparing (list to list) " & $left & " and " & $right

    # If the left list runs out of items first, the inputs are in the right order.
    # If the right list runs out of items first, the inputs are not in the right order.
    # If the lists are the same length and no comparison makes a decision about the order, continue checking the next part of the input.
    for i in 0 .. min(right.list.len, left.list.len) - 1:
      let subComparison = compare(left.list[i], right.list[i])
      case subComparison:
        of Continue: continue
        of NotRightOrder: return NotRightOrder
        of RightOrder: return RightOrder

    # ran out of items
    if right.list.len < left.list.len:
      return NotRightOrder
    elif left.list.len < right.list.len:
      return RightOrder
    else:
      return Continue

  if left.kind == PairKind.List and right.kind == PairKind.Integer:
    return compare(left, PairItemRef(kind: List, list: @[right]))

  if left.kind == PairKind.Integer and right.kind == PairKind.List:
    return compare(PairItemRef(kind: List, list: @[left]), right)

  raise newException(IOError, "Could not find out")


proc part1*(pairs: seq[(PairitemRef, PairItemRef)]): int =
  var sum: int = 0

  for i in 0 .. pairs.len - 1:
    if compare(pairs[i][0], pairs[i][1]) == ComparisonResult.RightOrder:
      sum += i + 1

  return sum


proc part2*(): uint =
  return 2

proc parsePairItem*(input: JsonNode): ref PairItem =
  if input.kind == JsonNodeKind.JInt:
    return PairItemref(kind: Integer, integer: input.num)
  if input.kind == JsonNodeKind.JArray:
    return PairItemRef(kind: PairKind.List, list: input.elems.mapIt(parsePairItem(it)))

proc parse*(input: string): seq[(PairitemRef, PairItemRef)] =
  var pairsList: seq[(PairitemRef, PairItemRef)] = @[]

  for rawPairList in split(input, "\n\n"):
    let rawLeftPairItem = parseJson(split(rawPairList, "\n")[0])
    let rawRightPairItem = parseJson(split(rawPairList, "\n")[1])

    pairsList.add((parsePairItem(rawLeftPairItem), parsePairItem(rawRightPairItem)))

  return pairsList

proc day13(): void = 
  let entireFile = readFile("./build/input.txt")

  echo fmt"⭐️ Part 1: {part1(parse(entireFile))}"
  echo fmt"⭐️ Part 2: {part2()}"

if is_main_module:
  day13()
