LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY control_unit IS
    PORT (
        clk : IN STD_LOGIC;
        opcode : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        in_enable : OUT STD_LOGIC;
        out_enable : OUT STD_LOGIC;
        reg_write : OUT STD_LOGIC;
        mem_write : OUT STD_LOGIC;
        mem_read : OUT STD_LOGIC;
        mem_to_reg : OUT STD_LOGIC;
        alu_operation : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
        is_immediate: OUT STD_LOGIC;
        stack_operation: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        branch : OUT STD_LOGIC;
        jump_type : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        call: OUT STD_LOGIC;
        ret: OUT STD_LOGIC;
        interrupt: OUT STD_LOGIC;
        rti: OUT STD_LOGIC;
        freeze: OUT STD_LOGIC
    );
END control_unit;
ARCHITECTURE behavioral OF control_unit IS
BEGIN
    PROCESS (clk)
    signal control_signals : STD_LOGIC_VECTOR(15 DOWNTO 0);
    BEGIN
        IF rising_edge(clk) THEN
            CASE opcode IS
            -- one operand instructions
                WHEN "00000" =>
                control_signals <= x"00800"; --hlt
                WHEN "00001" =>
                control_signals <= x"00000"; --nop
                WHEN "00010" =>
                control_signals <= x"00000"; --setc
                WHEN "00011" =>
                control_signals <= x"00000"; --not rd,rs
                WHEN "00100" =>
                control_signals <= x"00000"; --inc rd,rs
                WHEN "00101" =>
                control_signals <= x"00000"; --in rd
                WHEN "00110" =>
                control_signals <= x"00000"; --out rs
            -- two operand instructions
                WHEN "01000" =>
                control_signals <= x"00000"; --add rd,rs,rt
                WHEN "01001" =>
                control_signals <= x"00000"; --sub rd,rs,rt
                WHEN "01010" =>
                control_signals <= x"00000"; --and rd,rs,rt
                WHEN "01011" =>
                control_signals <= x"00000"; --mov rd,rs
                WHEN "01100" =>
                control_signals <= x"00000"; --iadd rd,rs,imm
            -- memory instructions
                WHEN "10000" =>
                control_signals <= x"00000"; --push rs
                WHEN "10001" =>
                control_signals <= x"00000"; --pop rd
                WHEN "10010" =>
                control_signals <= x"00000"; --std rs,offset(rt)
                WHEN "10011" =>
                control_signals <= x"00000"; --ld rd,offset(rs)
                WHEN "10100" =>
                control_signals <= x"00000"; --ldm rd,imm
            -- branch instructions
                WHEN "11000" =>
                control_signals <= x"00000"; --jz rd
                WHEN "11001" =>
                control_signals <= x"00000"; --jn rd
                WHEN "11010" =>
                control_signals <= x"00000"; --jc rd
                WHEN "11011" =>
                control_signals <= x"00000"; --jmp rd
                WHEN "11100" =>
                control_signals <= x"00000"; --call rd
                WHEN "11101" =>
                control_signals <= x"00000"; --ret
                WHEN "11110" =>
                control_signals <= x"00000"; --int index
                WHEN "11111" =>
                control_signals <= x"00000"; --rti
                WHEN OTHERS =>
                control_signals <= x"00000"; --nop
            END CASE;
            interrupt <= control_signals(0);
            rti <= control_signals(1);
            reg_write <= control_signals(2);
            mem_write <= control_signals(3);
            mem_read <= control_signals(4);
            mem_to_reg <= control_signals(5);
            jump_type <= control_signals(7 DOWNTO 6);
            branch <= control_signals(8);
            call <= control_signals(9);
            ret <= control_signals(10);
            freeze <= control_signals(11);
            alu_operation <= control_signals(14 DOWNTO 12);
            stack_operation <= control_signals(16 DOWNTO 15);
            is_immediate <= control_signals(17);
            in_enable <= control_signals(18);
            out_enable <= control_signals(19);
        END IF;
    END PROCESS;
END behavioral;