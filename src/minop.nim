import std/parseopt
import tokens
import std/os
import nim_gen
import std/strformat
import osproc
import lexer

var p = initOptParser()
let appDir = getAppDir()

var command = ""
var path = ""

while true:
  p.next()

  case p.kind
  of cmdEnd:
    break

  of cmdShortOption, cmdLongOption:
    echo "Option: ", p.key, " = ", p.val

  of cmdArgument:
    if command == "":
      command = p.key
    elif command == "c" and path == "":
      path = p.key
    else:
      quit("Unexpected argument: " & p.key, 1)

if command == "c":
  if path == "":
    quit("Usage: myprogram c <path>", 1)

  if not fileExists(path):
    quit "File not found!"

  let fileInfo = splitFile(path)
  if not (fileInfo.ext == ".minop"):
    quit "Incorrect file extension!"
  var lexemes: seq[Segment] = lex(path)
  var tokens: seq[Token] = tokenize(lexemes)
  var content = lower(tokens, "nim")
  echo content
  let parent = parentDir(path)
  let (_, stem, _) = splitFile(path)
  let basename = stem & ".nim"
  let full_path = parent / basename
  writeFile(full_path, content)
  let output = execProcess(fmt"nim c {full_path}")
  echo "Output: ", output
  removeFile(full_path)

else:
  quit("Unknown command: " & command, 1)
