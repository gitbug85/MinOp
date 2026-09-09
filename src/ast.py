
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

def make_ast():
    pass
