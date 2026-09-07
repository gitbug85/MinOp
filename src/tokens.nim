import std/strutils
import std/json

type
  Token* = object
    kind*: string
    value*: string

proc isQuotedString(s: string): bool =
  return s.len >= 2 and s.startsWith("\"") and s.endsWith("\"")

proc isNumber(s: string): bool =
  try:
    discard parseInt(s)
    return true
  except ValueError:
    return false

proc tokenize*(json: string): seq[Token] =

  let data = parseJson(json)

  var lexemes: seq[string] = @[]

  for item in data:
    lexemes.add(item["val"].getStr())

  for lexeme in lexemes:
      if lexeme.len == 0:
          continue

      case lexeme
      of "=":
        result.add(Token(kind: "EQUAL", value: lexeme))
      of "+":
        result.add(Token(kind: "PLUS", value: lexeme))
      of "-":
        result.add(Token(kind: "MINUS", value: lexeme))
      of "*":
        result.add(Token(kind: "MULTIPLY", value: lexeme))
      of "/":
        result.add(Token(kind: "DIVIDE", value: lexeme))
      of "%":
        result.add(Token(kind: "MODULO", value: lexeme))
      of "^":
        result.add(Token(kind: "EXPONENT", value: lexeme))
      of "say":
        result.add(Token(kind: "SAY", value: lexeme))
      of "mut":
        result.add(Token(kind: "MUTABLE", value: lexeme))
      of "use":
        result.add(Token(kind: "USE", value: lexeme))
      of "imp":
        result.add(Token(kind: "IMP", value: lexeme))
      of "if":
        result.add(Token(kind: "IF", value: lexeme))
      of "elif":
        result.add(Token(kind: "ELIF", value: lexeme))
      of "else":
        result.add(Token(kind: "ELSE", value: lexeme))
      of ":":
        result.add(Token(kind: "COLON", value: lexeme))
      of "\n":
        result.add(Token(kind: "NEWLINE", value: lexeme))
      of "\t":
        result.add(Token(kind: "TAB", value: lexeme))
      of ",":
        result.add(Token(kind: "COMMA", value: lexeme))
      of "(":
        result.add(Token(kind: "LEFT_PAREN", value: lexeme))
      of ")":
        result.add(Token(kind: "RIGHT_PAREN", value: lexeme))
      else:
        if isNumber(lexeme):
          result.add(Token(kind: "NUMBER", value: lexeme))
        elif isQuotedString(lexeme):
          result.add(Token(kind: "STRING", value: lexeme))
        else:
          if not (lexeme == " "):
            result.add(Token(kind: "IDENT", value: lexeme))

  result.add(Token(kind: "EOF", value: ""))
