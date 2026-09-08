type
  Segment* = object
    val*: string
    col*: int
    ln*: int

type
  Status = enum
    JoiningString, JoiningPath, JoiningRegex, NotJoining

proc print_segs(segs: seq[Segment]) =
    for seg in segs:
        echo seg.val

proc append_to_seg(seg: var Segment, other: var Segment) =
    seg.val &= other.val

proc lex(path: string): seq[Segment] =
    return @[]

