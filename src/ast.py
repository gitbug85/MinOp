from lower import Token

class Node():
    def __init__(self, name: str):
        self.name = name

class Identifier(Node):
    def __init__(self, name: str, keyword: str):
        super().__init__("REFERENCE")
        self.name = name
        self.keyword = keyword

class Assignment(Node):
    def __init__(self, identifier: Identifier, value: Node):
        super().__init__("ASSIGNMENT")
        self.identifier = identifier
        self.value = value

class File(Node):
    def __init__(self, body: list[Node]):
        super().__init__("FILE")
        self.body = body

class String(Node):
    def __init__(self, value: str):
        super().__init__("STRING")
        self.value = value

class Integer(Node):
    def __init__(self, bits: str, value: str):
        super().__init__("INTEGER")
        self.bits = bits
        self.value = value

class Call(Node):
    def __init__(self, identifier: str, parameters: list[Identifier]):
        super().__init__("CALL")
        self.identifier = identifier
        self.parameters = parameters

class If(Node):
    def __init__(self, condition: Node, body: list[Node]):
        super().__init__("IF")
        self.condition = condition
        self.body = body

class BinaryOperation(Node):
    def __init__(self, operator: str, l_operand: Node, r_operand: Node):
        super().__init__("BINARY_OPERATION")
        self.operator = operator
        self.l_operand = l_operand
        self.r_operand = r_operand

class UnaryOperation(Node):
    def __init__(self, operator: str, operand: Node):
        super().__init__("UNARY_OPERATION")
        self.operator = operator
        self.operand = operand

class Parser:
    def __init__(self):
        self.toks = []
        self.pos = 0

    def gen_ast(self, toks: list[Token]) -> File:
        self.toks = toks
        return self.parse_file()

    def parse_file(self) -> File:
        parsing = True
        while parsing:
            self.parse_statement()
            next = self.next()
            if next.kind == "EOF":
                parsing = False
            elif next.kind == "NEWLINE":
                pos+=2

    def parse_assignment(self) -> Node:
        pass

    def parse_statement(self) -> Node:
        cur = self.current()

        match cur.kind:
            case "MUTABLE":
                pass
            case "FLEX":
                pass
            case "MUTFLEX":
                pass
            case "IDENTIFIER":
                pass
            case _:
                pass

    # Helper functions

    def current(self):
        return self.toks[self.pos]

    def next(self):
        return self.toks[self.pos+1]

    def expect(self, kind: str):
        next = self.toks[self.pos+1]
        if next.kind == kind:
            return next
        return -1
