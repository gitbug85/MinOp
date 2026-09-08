# Broad

I find both Nim and Rust to have features I like but some downsides.
I will start from very basic syntax and the build the language from there.
The language will at first transpile to Nim then compile to binary but eventually I will switch to immediate LLVM compilation.

Things I like from different programming languages that I want to implement:
- Nim: Small join paths operator
- Python: Small constructors
- Ruby: Small current instance references
- Rust: Borrow checker
- Nim: Indentation-based syntax
- Rust: Explicit mutability

Unique things I want to implement:
- Small operators
- Left Operand Wins: Whatever operand type is on the left is the output of the operation

# Specific
Flexible Type: Type can change bits ie i32 -> i64

|               | **Fixed Type** | **Flexible Type** |
| ------------- | -------------- | ----------------- |
| **Immutable** | `x = 5`        | `flex x = 5`      |
| **Mutable**   | `mut x = 5`    | `mutflex x = 5`   |

&prot: immutable & inflexable reference
&ref: reference

use -> runtime
imp -> everything else

mut hello = "Yello"
mut world = "world!"
hello = "H" + hello[1..]
mut greeting = hello + " " + world
echo greeting

\# Denotes number
| Name | Operator |
|---|---|
| Addition |+|
| Subtraction |-|
| Multiplication |*|
| Division |/|
| Modulo |%|
| Exponentiation |^|
| Equal To |==|
| Not Equal To |!=|
| Greater Than |>|
| Greater Than or Equal To |>=|
| Less Than |<|
| Less Than or Equal To |<=|
| Logical AND |&|
| Logical OR |\||
| Logical NOT |!|
| Bitwise AND |&|
| Bitwise OR |\||
| Bitwise XOR |\|\||
| Bitwise NOT |!|
| Left Shift |<<|
| Right Shift |>>|
| Assignment |=|
| Addition Assignment |+=|
| Subtraction Assignment |-=|
| Multiplication Assignment |*=|
| Division Assignment |/=|
| Modulo Assignment |%=|
| Increment |++|
| Decrement |--|
| Push |<<|
| Pop |>>|
| Range |\[#..#\]|
| Membership |->|
| Index |\[#\]|
| Index Assignment |\[#\] =|
| Dereference |@|
| Address Of |&|

Path -> '~/path'
String -> "string"
Regex -> \`regex\`

Current instance -> $.

\#\#\
Multiline comments\
\#\#

Special types to add:
arr (Rust array)
seq (Nim sequence)

