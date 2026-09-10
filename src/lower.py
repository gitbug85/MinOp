import sys
import json
import llvm_ir_gen

class Token:
    def __init__(self, kind: str, value: str):
        self.kind = kind
        self.value = value

def lower(json_string: str):
    print("Received:", json_string)

    data = json.loads(json_string)

    toks = [Token(d["kind"], d["value"]) for d in data]

    # Generate ast
    file = llvm_ir_gen.gen_ast()

    return "TEST"
