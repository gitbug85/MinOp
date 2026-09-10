import tokens
import std/strformat
import tables
import std/os

type
  Transpiler = object
    scope: Table[string, bool] # Identifier to mutability
    content: string

proc emit_whitespace(tp: var Transpiler, tokens: var seq[Token]): int =
  var newlines_removed = false
  var count = 0;
  while not newlines_removed:
    var cur = tokens[0]
    if cur.kind == "NEWLINE":
      tp.content.add(cur.value)
      count += 1
      tokens.delete(0)
    elif cur.kind == "TAB":
      tp.content.add("  ")
      tokens.delete(0)
    else:
      newlines_removed = true
  return count

proc expect_value(tp: var Transpiler, tokens: var seq[Token])

proc emit_arguments(tp: var Transpiler, tokens: var seq[Token]) =
  var cur = tokens[0]
  if cur.kind == "LEFT_PAREN":
    tp.content.add(cur.value)
    tokens.delete(0)
  else:
    return

  var parsing = true
  while parsing:
    expect_value(tp, tokens)
    var cur = tokens[0]

    if cur.kind == "RIGHT_PAREN":
      tp.content.add(cur.value)
      tokens.delete(0)
      break
    elif cur.kind != "COMMA":
      quit("Error: Expected comma after value")
    else:
      # Must be comma
      tp.content.add(cur.value)
      tokens.delete(0)

proc expect_value(tp: var Transpiler, tokens: var seq[Token]) =
  var cur = tokens[0]
  if cur.kind == "NUMBER":
    tp.content.add(fmt"{cur.value}")
    tokens.delete(0)
  elif cur.kind == "STRING":
    tp.content.add(&"cstring({cur.value})")
    tokens.delete(0)
  elif cur.kind == "IDENT":
    tp.content.add(cur.value)
    tokens.delete(0)
    emit_arguments(tp, tokens)
  else:
    quit(fmt"Error: Expected value found {cur.kind}")

proc expect_equal(tp: var Transpiler, tokens: var seq[Token]) =
  var cur = tokens[0]
  if cur.kind != "EQUAL":
    quit(fmt"Error: Expected EQUAL found {cur.kind}")
  tp.content.add(fmt"= ")
  tokens.delete(0)

proc expect_assignment(tp: var Transpiler, tokens: var seq[Token], mutable: bool) =
  var cur = tokens[0]
  if cur.kind != "IDENT":
    quit(fmt"Error: Expected IDENT found {cur.kind}")
  if tp.scope.hasKey(cur.value):
    if tp.scope[cur.value] == false:
      quit(fmt"Error: Cannot change immutable variable {cur.value}")
    tp.content.add(&"{cur.value} ")
  else:
    if mutable:
      tp.content.add(&"var {cur.value} ")
      tp.scope[cur.value] = mutable
    else:
      tp.content.add(&"let {cur.value} ")
      tp.scope[cur.value] = mutable

  tokens.delete(0)
  expect_equal(tp, tokens)
  expect_value(tp, tokens)

proc expect_statement(tp: var Transpiler, tokens: var seq[Token]) =
  var cur = tokens[0]
  if cur.kind == "IDENT":
    expect_assignment(tp, tokens, false)
  elif cur.kind == "MUTABLE":
    tokens.delete(0)
    expect_assignment(tp, tokens, true)
  elif cur.kind == "SAY":
    tp.content.add("rs_say(")
    tokens.delete(0)
    expect_value(tp, tokens)
    tp.content.add(")")
  elif cur.kind == "ECHO":
    tp.content.add("rs_echo(")
    tokens.delete(0)
    expect_value(tp, tokens)
    tp.content.add(")")
  elif cur.kind == "IF":
    tp.content.add("if ")
    tokens.delete(0)
    cur = tokens[0]
    expect_value(tp, tokens)
    cur = tokens[0]
    if cur.kind != "COLON":
      quit("Error: Expected colon at end of if statement")
    tp.content.add(":")
    tokens.delete(0)
  elif cur.kind == "USE":
      tokens.delete(0)
      cur = tokens[0]

      var path = findExe("minop")
      var parent = parentDir(path)
      var standard_library = parent / "runtime" / (cur.value & ".a")

      tp.content.add("{.passL: \"" & standard_library & "\".}\n")

      if cur.value == "math":
        tp.content.add("""
proc rs_add(a: int32, b: int32): int32 {.importc.}
proc rs_sub(a: int32, b: int32): int32 {.importc.}
proc rs_mult(a: int32, b: int32): int32 {.importc.}
proc rs_int_div(a: int32, b: int32): int32 {.importc.}
proc rs_str_to_i32(s: cstring): int32 {.importc.}
""")
      elif cur.value == "cli":
        tp.content.add("""
proc rs_arg_count(): csize_t {.importc.}
proc rs_arg(index: csize_t): cstring {.importc.}

proc rs_path_exists(path: cstring): bool {.importc.}
proc rs_path_is_file(path: cstring): bool {.importc.}
proc rs_path_is_dir(path: cstring): bool {.importc.}

proc rs_path_join(a: cstring, b: cstring): cstring {.importc.}
proc rs_path_parent(path: cstring): cstring {.importc.}
proc rs_path_filename(path: cstring): cstring {.importc.}
proc rs_path_extension(path: cstring): cstring {.importc.}
""")
      elif cur.value == "string":
        tp.content.add("""
proc rs_str_len(s: cstring): csize_t {.importc.}
proc rs_str_eq(a: cstring, b: cstring): bool {.importc.}
proc rs_str_dup(s: cstring): cstring {.importc.}
proc rs_str_free(s: cstring) {.importc.}
proc rs_str_concat(a: cstring, b: cstring): cstring {.importc.}
proc rs_i32_to_str(value: int32): cstring {.importc.}
""")
      elif cur.value == "io":
        tp.content.add("""
proc rs_echo(s: cstring) {.cdecl, importc.}
proc rs_say(s: cstring) {.cdecl, importc.}
""")
      tokens.delete(0)
  elif cur.kind == "IMP":
    tokens.delete(0)
    cur = tokens[0]
    tp.content.add(&"import {cur.value}")
    tokens.delete(0)
  else:
    quit(fmt"Error: Expected identifier found {cur.kind}")

proc transpile(tp: var Transpiler, tokens: var seq[Token]): string =
  var found_end_of_file = false
  while not found_end_of_file:
    var newlines = emit_whitespace(tp, tokens)
    let cur = tokens[0]
    if cur.kind == "EOF":
      found_end_of_file = true
      break
    expect_statement(tp, tokens)

  tp.content

# Target is either LLVM IR or Nim
proc lower*(tokens: var seq[Token], target: string): string =
  # Either transpile to Nim or generate LLVM IR (codegen)
  if target == "llvm":
    return ""
  else:
    var transpiler = Transpiler(
      scope: initTable[string, bool](),
      content: ""
    )
    return transpile(transpiler, tokens)
