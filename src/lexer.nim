import sequtils
import std/json
import std/os
import osproc

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

proc lex*(path: string): seq[Segment] =

    # Make fragments based on lines
    var fragments: seq[Segment] = @[]

    for line in lines(path):
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
        
        if leftover != 0:
            quit("Error: Invalid indentation")
        
        echo tabs
        for _ in 0 .. tabs-1:
            fragments.add(Segment(val: "\t", col: 0, ln: 0))
        
        fragments.add(Segment(val: new_line, col: 0, ln: 0))
        fragments.add(Segment(val: "\n", col: 0, ln: 0))

    # Make more fragments using regex
    var new_fragments: seq[Segment] = @[]

    for fragment in fragments:
        var str_val = fragment.val
        var perlScript = getAppDir() / "lexer.pl"
        var (pl_output, exitCode) = execCmdEx("perl " & quoteShell(perlScript) & " " & quoteShell(str_val))
        if exitCode != 0:
            quit "Error running Perl script. Exit code: " & $exitCode
        var strs = to(parseJson(pl_output), seq[string])
        echo strs
        strs = strs.filterIt(it.len > 0)
        for str in strs:
            new_fragments.add(Segment(val: str, col: 0, ln: 0))

    fragments = new_fragments

    # Join fragments together for strings, paths and regex

    var status = Status.NotJoining
    var lexemes: seq[Segment] = @[]
    var current_lexeme = Segment(val: "", col: 0, ln: 0)
    var previous_backslash = false

    for fragment in fragments.mitems:
        var str = fragment.val

        if str == "\\":
            previous_backslash = true
            append_to_seg(current_lexeme, fragment)
        elif str == "\"":
            if status == Status.JoiningString:
                if previous_backslash: # Escaped double quote
                    append_to_seg(current_lexeme, fragment)
                    previous_backslash = false
                else: # Closing double quote
                    status = Status.NotJoining
                    append_to_seg(current_lexeme, fragment)
                    lexemes.add(current_lexeme)
                    current_lexeme = Segment(val: "", col: 0, ln: 0)
            else: # Opening double quote
                status = Status.JoiningString
                append_to_seg(current_lexeme, fragment)
        elif str == "\'":
            if status == Status.JoiningPath: # Closing quote
                status = Status.NotJoining
                append_to_seg(current_lexeme, fragment)
                lexemes.add(current_lexeme)
                current_lexeme = Segment(val: "", col: 0, ln: 0)
            else: # Opening quote
                status = Status.JoiningPath
                append_to_seg(current_lexeme, fragment)
        elif str == "`":
            if status == Status.JoiningRegex:
                if previous_backslash: # Escaped backtick
                    append_to_seg(current_lexeme, fragment)
                    previous_backslash = false
                else: # Closing backtick
                    status = NotJoining
                    append_to_seg(current_lexeme, fragment)
                    lexemes.add(current_lexeme)
                    current_lexeme = Segment(val: "", col: 0, ln: 0)
            else: # Opening backtick
                status = Status.JoiningRegex
                append_to_seg(current_lexeme, fragment)
        else:
            if status == Status.JoiningString or status == Status.JoiningPath or status == Status.JoiningRegex:
                append_to_seg(current_lexeme, fragment)
                previous_backslash = false
            else:
                lexemes.add(Segment(val: fragment.val, col: fragment.col, ln: fragment.ln))

    # Add code to join fragments together for multi-character operators

    return lexemes

