LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY control_unit IS
    PORT (
        opcode : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        clk : IN STD_LOGIC;

        reg_dst : OUT STD_LOGIC; -- 12
        branch : OUT STD_LOGIC; -- 11
        mem_read : OUT STD_LOGIC; -- 15
        mem_to_reg : OUT STD_LOGIC; -- 1
        mem_write : OUT STD_LOGIC; -- 16

        alu_src : OUT STD_LOGIC;
        reg_write : OUT STD_LOGIC; -- 4
        reset : OUT STD_LOGIC; -- 8
        has_imm : OUT STD_LOGIC; -- 10

        in_enable : OUT STD_LOGIC; -- 0
        out_enable : OUT STD_LOGIC; -- 19
        return_enable : OUT STD_LOGIC; -- 2
        call_enable : OUT STD_LOGIC; -- 5
        flags_restore : OUT STD_LOGIC; -- 17
        flags_save : OUT STD_LOGIC; -- 18

        if_flush : OUT STD_LOGIC; -- 13
        id_flush : OUT STD_LOGIC; -- 14

        pc_src : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); -- 3
        jump_type : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); -- 7
        stack_op : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); -- 6
        alu_op : OUT STD_LOGIC_VECTOR(2 DOWNTO 0); -- 9
    );
END control_unit;
ARCHITECTURE behavioral OF control_unit IS
BEGIN
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            CASE opcode IS
            END CASE;
        END IF;
    END PROCESS;
END behavioral;