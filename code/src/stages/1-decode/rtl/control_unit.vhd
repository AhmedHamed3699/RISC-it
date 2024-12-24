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
        alu_operation : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
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
	signal control_signals : STD_LOGIC_VECTOR(19 DOWNTO 0);
BEGIN
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            CASE opcode IS
            -- one operand instructions
                WHEN "00001" =>
                control_signals <= x"00100"; --hlt
                WHEN "00010" =>
                control_signals <= x"00060"; --setc
                WHEN "00011" =>
                control_signals <= x"80050"; --not rd,rs
                WHEN "00100" =>
                control_signals <= x"80040"; --inc rd,rs
                WHEN "00101" =>
                control_signals <= x"80002"; --in rd
                WHEN "00110" =>
                control_signals <= x"00001"; --out rs
            -- two operand instructions
                WHEN "01000" =>
                control_signals <= x"80000"; --add rd,rs,rt
                WHEN "01001" =>
                control_signals <= x"80010"; --sub rd,rs,rt
                WHEN "01010" =>
                control_signals <= x"80020"; --and rd,rs,rt
                WHEN "01011" =>
                control_signals <= x"80030"; --mov rd,rs
                WHEN "01100" =>
                control_signals <= x"80080"; --iadd rd,rs,imm
            -- memory instructions
                WHEN "10000" =>
                control_signals <= x"4000C"; --push rs
                WHEN "10001" =>
                control_signals <= x"B0008"; --pop rd
                WHEN "10010" =>
                control_signals <= x"40080"; --std rs,offset(rt)
                WHEN "10011" =>
                control_signals <= x"B0080"; --ld rd,offset(rs)
                WHEN "10100" =>
                control_signals <= x"B00F0"; --ldm rd,imm
            -- branch instructions
                WHEN "11000" =>
                control_signals <= x"03800"; --jz rd
                WHEN "11001" =>
                control_signals <= x"02800"; --jn rd
                WHEN "11010" =>
                control_signals <= x"01800"; --jc rd
                WHEN "11011" =>
                control_signals <= x"00800"; --jmp rd
                WHEN "11100" =>
                control_signals <= x"0040C"; --call rs
                WHEN "11101" =>
                control_signals <= x"00208"; --ret
                WHEN "11110" =>
                control_signals <= x"0800C"; --int index
                WHEN "11111" =>
                control_signals <= x"04008"; --rti
                WHEN OTHERS =>
                control_signals <= x"00000"; --nop
            END CASE;
            out_enable <= control_signals(0);
            in_enable <= control_signals(1);
            stack_operation <= control_signals(3 DOWNTO 2);
            alu_operation <= control_signals(6 DOWNTO 4);
            is_immediate <= control_signals(7);
            freeze <= control_signals(8);
            ret <= control_signals(9);
            call <= control_signals(10);
            branch <= control_signals(11);
            jump_type <= control_signals(13 DOWNTO 12);
            rti <= control_signals(14);
            interrupt <= control_signals(15);
            mem_to_reg <= control_signals(16);
            mem_read <= control_signals(17);
            mem_write <= control_signals(18);
            reg_write <= control_signals(19);
        END IF;
    END PROCESS;
END behavioral;