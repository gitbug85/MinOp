import re
import sequtils

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

proc lex(filename: string): seq[Segment] =

    # Make fragments based on lines
    var fragments: seq[Segment] = @[]

    for line in lines(filename):
        var new_line = line
        let commentIdx = new_line.find('#')
        if commentIdx != -1:
            new_line = new_line[0 ..< commentIdx]
        var count = 0
        while count < new_line.len and new_line[count] == ' ':
            inc(count)
        new_line = new_line[count .. ^1]
        let tabs = count div 4
        let leftover = count mod 4
        
        for _ in 0 .. tabs-1:
            fragments.add(Segment(val: "  ", col: 0, ln: 0))
        
        fragments.add(Segment(val: new_line, col: 0, ln: 0))
        fragments.add(Segment(val: "\n", col: 0, ln: 0))

    # Make more fragments using regex
    var new_fragments: seq[Segment] = @[]

    for fragment in fragments:
        var str_val = fragment.val
        let regex = re"""([=+\-*/"()\ #])"""
        var strs = str_val.split(regex)
        strs = strs.filterIt(it.len > 0)
        for str in strs:
            new_fragments.add(Segment(val: str, col: 0, ln: 0))

    # Join fragments together for strings, paths and regex

    # Joing fragments together for multi-character operators

    return new_fragments

