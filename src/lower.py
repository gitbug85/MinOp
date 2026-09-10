import ast
import llvm_ir_gen
import sys


def lower(json: str):

    print(json)

    # Generate ast
    file = llvm_ir_gen.gen_ast()
    pass


print(lower(sys.argv[1]))