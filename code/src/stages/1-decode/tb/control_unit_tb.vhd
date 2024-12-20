LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY control_unit_tb IS
END control_unit_tb;

ARCHITECTURE behavioral OF control_unit_tb IS

    COMPONENT control_unit
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
    END COMPONENT;

    -- Testbench signals
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL opcode : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL in_enable : STD_LOGIC;
    SIGNAL out_enable : STD_LOGIC;
    SIGNAL reg_write : STD_LOGIC;
    SIGNAL mem_write : STD_LOGIC;
    SIGNAL mem_read : STD_LOGIC;
    SIGNAL mem_to_reg : STD_LOGIC;
    SIGNAL alu_operation : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL is_immediate : STD_LOGIC;
    SIGNAL stack_operation : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL branch : STD_LOGIC;
    SIGNAL jump_type : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL call : STD_LOGIC;
    SIGNAL ret : STD_LOGIC;
    SIGNAL interrupt : STD_LOGIC;
    SIGNAL rti : STD_LOGIC;
    SIGNAL freeze : STD_LOGIC;

    CONSTANT clk_period : TIME := 10 ns;

BEGIN

    uut: control_unit PORT MAP (
        clk => clk,
        opcode => opcode,
        in_enable => in_enable,
        out_enable => out_enable,
        reg_write => reg_write,
        mem_write => mem_write,
        mem_read => mem_read,
        mem_to_reg => mem_to_reg,
        alu_operation => alu_operation,
        is_immediate => is_immediate,
        stack_operation => stack_operation,
        branch => branch,
        jump_type => jump_type,
        call => call,
        ret => ret,
        interrupt => interrupt,
        rti => rti,
        freeze => freeze
    );

    clk_process: PROCESS
    BEGIN
        WHILE TRUE LOOP
            clk <= '0';
            WAIT FOR clk_period / 2;
            clk <= '1';
            WAIT FOR clk_period / 2;
        END LOOP;
    END PROCESS;

    stimulus_process: PROCESS
    BEGIN
        -- Test each opcode and check results
        FOR i IN 0 TO 31 LOOP
            opcode <= STD_LOGIC_VECTOR(TO_UNSIGNED(i, 5));
            WAIT FOR clk_period;
            REPORT "Testing opcode: " & INTEGER'IMAGE(i);
            CASE opcode IS
            WHEN "00001" =>  -- HLT
                ASSERT freeze = '1' REPORT "Failed HLT opcode test" SEVERITY FAILURE;

            WHEN "00010" =>  -- SETC
                ASSERT alu_operation = "110" AND reg_write = '0' REPORT "Failed SETC opcode test" SEVERITY FAILURE;

            WHEN "00011" =>  -- NOT RD, RS
                ASSERT alu_operation = "101" AND reg_write = '1' REPORT "Failed NOT opcode test" SEVERITY FAILURE;

            WHEN "00100" =>  -- INC RD, RS
                ASSERT alu_operation = "100" AND reg_write = '1' REPORT "Failed INC opcode test" SEVERITY FAILURE;

            WHEN "00101" =>  -- IN RD
                ASSERT in_enable = '1' AND reg_write = '1' REPORT "Failed IN opcode test" SEVERITY FAILURE;

            WHEN "00110" =>  -- OUT RS
                ASSERT out_enable = '1' REPORT "Failed OUT opcode test" SEVERITY FAILURE;

            WHEN "01000" =>  -- ADD RD, RS, RT
                ASSERT alu_operation = "000" AND reg_write = '1' REPORT "Failed ADD opcode test" SEVERITY FAILURE;

            WHEN "01001" =>  -- SUB RD, RS, RT
                ASSERT alu_operation = "001" AND reg_write = '1' REPORT "Failed SUB opcode test" SEVERITY FAILURE;

            WHEN "01010" =>  -- AND RD, RS, RT
                ASSERT alu_operation = "010" AND reg_write = '1' REPORT "Failed AND opcode test" SEVERITY FAILURE;

            WHEN "01011" =>  -- MOV RD, RS
                ASSERT alu_operation = "011" AND reg_write = '1' REPORT "Failed MOV opcode test" SEVERITY FAILURE;

            WHEN "01100" =>  -- IADD RD, RS, IMM
                ASSERT alu_operation = "100" AND is_immediate = '1' AND reg_write = '1' REPORT "Failed IADD opcode test" SEVERITY FAILURE;

            WHEN "10000" =>  -- PUSH RS
                ASSERT stack_operation = "01" AND mem_write = '1' REPORT "Failed PUSH opcode test" SEVERITY FAILURE;

            WHEN "10001" =>  -- POP RD
                ASSERT stack_operation = "10" AND mem_read = '1' AND reg_write = '1' REPORT "Failed POP opcode test" SEVERITY FAILURE;

            WHEN "10010" =>  -- STD RS, OFFSET(RT)
                ASSERT mem_write = '1' REPORT "Failed STD opcode test" SEVERITY FAILURE;

            WHEN "10011" =>  -- LD RD, OFFSET(RS)
                ASSERT mem_read = '1' AND mem_to_reg = '1' AND reg_write = '1' REPORT "Failed LD opcode test" SEVERITY FAILURE;

            WHEN "10100" =>  -- LDM RD, IMM
                ASSERT mem_to_reg = '1' AND is_immediate = '1' AND reg_write = '1' REPORT "Failed LDM opcode test" SEVERITY FAILURE;

            WHEN "11000" =>  -- JZ RD
                ASSERT branch = '1' AND jump_type = "11" REPORT "Failed JZ opcode test" SEVERITY FAILURE;

            WHEN "11001" =>  -- JN RD
                ASSERT branch = '1' AND jump_type = "10" REPORT "Failed JN opcode test" SEVERITY FAILURE;

            WHEN "11010" =>  -- JC RD
                ASSERT branch = '1' AND jump_type = "01" REPORT "Failed JC opcode test" SEVERITY FAILURE;

            WHEN "11011" =>  -- JMP RD
                ASSERT branch = '1' AND jump_type = "00" REPORT "Failed JMP opcode test" SEVERITY FAILURE;

            WHEN "11100" =>  -- CALL RS
                ASSERT call = '1' REPORT "Failed CALL opcode test" SEVERITY FAILURE;

            WHEN "11101" =>  -- RET
                ASSERT ret = '1' REPORT "Failed RET opcode test" SEVERITY FAILURE;

            WHEN "11110" =>  -- INT INDEX
                ASSERT interrupt = '1' REPORT "Failed INT opcode test" SEVERITY FAILURE;

            WHEN "11111" =>  -- RTI
                ASSERT rti = '1' REPORT "Failed RTI opcode test" SEVERITY FAILURE;

            WHEN OTHERS =>
                ASSERT reg_write = '0' AND mem_write = '0' AND mem_read = '0' REPORT "Failed default (NOP) opcode test" SEVERITY FAILURE;
            END CASE;

        END LOOP;

        WAIT;
    END PROCESS;

END behavioral;
