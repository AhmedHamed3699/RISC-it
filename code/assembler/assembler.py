one_operand_opcodes = {}
two_operand_opcodes = {}
memory_opcodes = {}
branch_opcodes = {}
registers = {}

def get_instruction_type(instruction):
    if instruction in one_operand_opcodes:
        return 0
    if instruction in two_operand_opcodes:
        return 1
    if instruction in memory_opcodes:
        return 2
    if instruction in branch_opcodes:
        return 3
    return -1

def get_opcode(instruction,instruction_type):
    if instruction_type == 0:
        return one_operand_opcodes[instruction]
    if instruction_type == 1:
        return two_operand_opcodes[instruction]
    if instruction_type == 2:
        return memory_opcodes[instruction]
    if instruction_type == 3:
        return branch_opcodes[instruction]
    return None

def assemble_one_operand(instruction):
    pass

def assemble_two_operand(instruction):
    pass

def assemble_memory(instruction):
    pass

def assemble_branch(instruction):
    pass

def assemble(instruction):
    instruction_type = get_instruction_type(instruction)
    if instruction_type == 0:
        return assemble_one_operand(instruction)
    elif instruction_type == 1:
        return assemble_two_operand(instruction)
    elif instruction_type == 2:
        return assemble_memory(instruction)
    elif instruction_type == 3:
        return assemble_branch(instruction)
    else:
        return None

def main():
    pass