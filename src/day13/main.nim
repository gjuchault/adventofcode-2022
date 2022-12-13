import std/algorithm
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
        of NotRightOrder: return ComparisonResult.NotRightOrder
        of RightOrder: return ComparisonResult.RightOrder

    # ran out of items
    if right.list.len < left.list.len:
      return ComparisonResult.NotRightOrder
    elif left.list.len < right.list.len:
      return ComparisonResult.RightOrder
    else:
      return ComparisonResult.Continue

  if left.kind == PairKind.List and right.kind == PairKind.Integer:
    return compare(left, PairItemRef(kind: List, list: @[right]))

  if left.kind == PairKind.Integer and right.kind == PairKind.List:
    return compare(PairItemRef(kind: List, list: @[left]), right)

  raise newException(IOError, "Could not find out")

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

proc part1*(pairs: seq[(PairItemRef, PairItemRef)]): int =
  var sum: int = 0

  for i in 0 .. pairs.len - 1:
    if compare(pairs[i][0], pairs[i][1]) == ComparisonResult.RightOrder:
      sum += i + 1

  return sum

proc part2*(pairs: seq[(PairItemRef, PairItemRef)]): int =
  var extendedPairs = newSeq[PairItemRef](pairs.len * 2)

  for i in 0 .. pairs.len - 1:
    extendedPairs[(i * 2)] = pairs[i][0]
    extendedPairs[(i * 2) + 1] = pairs[i][1]

  let divider2 = parsePairItem(parseJson("[[2]]"))
  let divider6 = parsePairItem(parseJson("[[6]]"))

  extendedPairs.add(divider2)
  extendedPairs.add(divider6)

  extendedPairs.sort(proc (x, y: PairItemRef): int =
    case compare(x, y):
      of Continue: return 0
      of NotRightOrder: return 1
      of RightOrder: return -1
  )

  var decoderKey = 1

  for i in 0 .. extendedPairs.len - 1:
    if extendedPairs[i] == divider2 or extendedPairs[i] == divider6:
      decoderKey *= (i + 1)

  return decoderKey

proc day13(): void = 
  let entireFile = readFile("./build/input.txt")

  echo fmt"⭐️ Part 1: {part1(parse(entireFile))}"
  echo fmt"⭐️ Part 2: {part2(parse(entireFile))}"

if is_main_module:
  day13()
