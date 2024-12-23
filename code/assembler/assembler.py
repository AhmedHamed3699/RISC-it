class Assembler:
    def __init__(self):
        self.zero_operand_opcodes = {
            "NOP": 0x00,
            "HLT": 0x01,
            "SETC": 0x02,
        }
        self.one_operand_opcodes = {
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
        self.two_operand_opcodes = {
            "ADD": 0x08,
            "SUB": 0x09,
            "AND": 0x0A,
            "MOV": 0x0B,
            "LDM": 0x14,
        }
        self.three_operand_opcodes = {
            "IADD": 0x0C,
            "STD": 0x12,
            "LDD": 0x13,
        }

    def remove_comments_and_spaces(self,line):
        cleaned_line = line.split('#')[0].strip() 
        return cleaned_line
    
    def read_line(self,line,index):
        cleaned_line = self.remove_comments_and_spaces(line)
        if cleaned_line == "":
            return [None,-1]
        if cleaned_line[0] == ".": #handle .ORG
            return [cleaned_line.split(" ")[0],cleaned_line.split(" ")[1]]
        return [cleaned_line.split(" ")[0],index]
    
    def get_instruction_type(self,instruction):
        if instruction in self.zero_operand_opcodes:
            return 0
        if instruction in self.one_operand_opcodes:
            return 1
        if instruction in self.two_operand_opcodes:
            return 2
        return 3

    def get_opcode(self,instruction,instruction_type):
        if instruction_type == 0:
            return self.zero_operand_opcodes[instruction]
        if instruction_type == 1:
            return self.one_operand_opcodes[instruction]
        if instruction_type == 2:
            return self.two_operand_opcodes[instruction]
        return self.three_operand_opcodes[instruction]
    
    def decimal_to_binary(self,value):
        return bin(value)[2:]
    

    def check_immediate(self,value):
        if value[0] == "#":
            return True
        return False

    def assemble_zero_operand(self,instruction):
        opcode = self.get_opcode(instruction,0)
        pass

    def assemble_one_operand(self,instruction):
        opcode = self.get_opcode(instruction,1)
        pass

    def assemble_two_operand(self,instruction):
        opcode = self.get_opcode(instruction,2)
        pass

    def assemble_three_operand(self,instruction):
        opcode = self.get_opcode(instruction,3)
        pass

    def assemble_immediate(self,value):
        value = value[1:]
        return self.decimal_to_binary(int(value))
    
    def hex_to_16bit_binary_string(self,value):
        return format((value), '016b')


    def assemble(self):
        f = open("/media/ahmed/Programming/Study/1st term/Architecture/new/project/RISC-it/code/assembler/0.txt", "r")
        ram, index = [0 for i in range(4096)], 0
        lines = f.readlines()
        for line in lines:
            # [instruction,index] = self.read_line(line,index)
            # if instruction == None:
            #     continue
            # instruction_type = self.get_instruction_type(instruction)
            # if instruction_type == 0:
            #     self.assemble_zero_operand(instruction)
            # if instruction_type == 1:
            #     self.assemble_one_operand(instruction)
            # if instruction_type == 2:
            #     self.assemble_two_operand(instruction)
            # if instruction_type == 3:
            #     self.assemble_three_operand(instruction)
            # ram[index] = hex_to_16bit_binary_string(instruction)
            if line == "inc r1, r2":
                ram[index] = 0x04010
            else:
                ram[index] = 0x01010
            
            ram[index] = self.hex_to_16bit_binary_string(ram[index])
            index += 1
        f.close()
        return ram
    
    def generate_instruction_memory(self,file_path,instructions_list):
        # f = open(file_path, "w")
        # for instruction in instructions_list:
        #     # if binary_instruction == None:
        #     #     continue
        with open(file_path, 'w') as file:
        # Write each element of the array to a new line
            file.writelines('\n'.join((str(instruction) for instruction in instructions_list)))
        file.close()
        return

def main():
    assembler = Assembler()
    instructions_list=assembler.assemble()
    assembler.generate_instruction_memory("instruction_memory.txt",instructions_list)
    
if __name__ == "__main__":
    main()