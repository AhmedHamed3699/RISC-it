zero_operand_opcodes = {
    "NOP": 0x00,
    "HLT": 0x01,
    "SETC": 0x02,
}
one_operand_opcodes = {
    "NOT": 0x03,
    "INC": 0x04,
    "IN": 0x05,
    "OUT": 0x06,
    "PUSH": 0x10,
    "POP": 0x11,
    "JZ": 0x18,
    "JN": 0x19,
    "JC": 0x1A,
    "JMP": 0x1B,
    "CALL": 0x1C,
    "RET": 0x1D,
    "INT": 0x1E,
    "RTI": 0x1F
}
two_operand_opcodes = {
    "ADD": 0x08,
    "SUB": 0x09,
    "AND": 0x0A,
    "MOV": 0x0B,
    "LDM": 0x14,
}
three_operand_opcodes = {
    "IADD": 0x0C,
    "STD": 0x12,
    "LD": 0x13,
}
def get_instruction_type(instruction):
    if instruction in zero_operand_opcodes:
        return 0
    if instruction in one_operand_opcodes:
        return 1
    if instruction in two_operand_opcodes:
        return 2
    return 3

def get_opcode(instruction,instruction_type):
    if instruction_type == 0:
        return zero_operand_opcodes[instruction]
    if instruction_type == 1:
        return one_operand_opcodes[instruction]
    if instruction_type == 2:
        return two_operand_opcodes[instruction]
    return three_operand_opcodes[instruction]

def check_immediate(value):
    pass

def assemble_zero_operand(instruction):
    opcode = get_opcode(instruction,0)
    pass

def assemble_one_operand(instruction):
    opcode = get_opcode(instruction,1)
    pass

def assemble_two_operand(instruction):
    opcode = get_opcode(instruction,2)
    pass

def assemble_three_operand(instruction):
    opcode = get_opcode(instruction,3)
    pass


def assemble(instruction):
    instruction_type = get_instruction_type(instruction)
    if instruction_type == 0:
        return assemble_one_operand(instruction)
    elif instruction_type == 1:
        return assemble_two_operand(instruction)
    elif instruction_type == 2:
        return assemble_two_operand(instruction)
    return assemble_three_operand(instruction)

def read_line(line,index):
    if(line[0] == ";" or line[0] == "\n" or line[0] == "#"): #ignore comments
        return [None,-1]
    if(line[0] == "."): #handle .ORG 
        return [line.split(" ")[0],line.split(" ")[1]] #return the address to jump to
    return [line.split(" ")[0],index] #return the instruction and the index

def main():

    file = open("ISA.txt","r")
    ram, index = ["" for i in range(4096)], 0
    lines = file.readlines()
    # read the file and assemble the instructions
    for line in lines:
        instruction = read_line(line)
        if(instruction[0] == None):
            continue
        if(instruction[0] == ".ORG"):
            index = instruction[1]
            continue
        ram[index] = assemble(instruction[0])
        index += 1
    file.close()
    # write the RAM to a file
    file = open("RAM.txt","w")
    for i in range(4096):
        file.write(ram[i] + "\n")
    file.close()
