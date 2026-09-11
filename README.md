# MinOp

Language I'm making with the goal of simplifying operators.
Have Nim installed. Download the latest release. Put the folder where you want it. Then run ```install.sh```.\
You now should be able to compile .minop files with the command ```minop c ./file.minop```

Example:
```
# Importing standard libraries
use math
use cli
use string
use io

# Import Nim module
imp multiply

# Get arguments
left_operand = rs_str_to_i32(rs_arg(1))
operator = rs_arg(2)
right_operand = rs_str_to_i32(rs_arg(3))

# Calculate and print
if rs_str_eq(operator, "+"):
    say rs_i32_to_str(rs_add(left_operand, right_operand))
if rs_str_eq(operator, "-"):
    say rs_i32_to_str(rs_sub(left_operand, right_operand))
if rs_str_eq(operator, "x"):
    say rs_i32_to_str(nim_mult(left_operand, right_operand))
```
