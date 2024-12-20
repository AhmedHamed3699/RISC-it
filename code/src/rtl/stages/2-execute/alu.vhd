LIBRARY ieee; 
USE ieee.std_logic_1164.all; 
USE ieee.numeric_std.all;

ENTITY alu IS PORT (
    clk             : IN STD_LOGIC;
    flag_restore    : IN STD_LOGIC;
    flags_reg       : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    a,b             : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
    alu_operation   : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    flag_register   : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);              
    result          : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
);
END alu;

ARCHITECTURE alu_arch of alu IS 
    SIGNAL res_reg    :STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL flag_reg  :STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN 
    PROCESS(clk)
        VARIABLE res         :STD_LOGIC_VECTOR(15 DOWNTO 0);
        VARIABLE carry_result:STD_LOGIC_VECTOR(17 DOWNTO 0);
        VARIABLE flags       :STD_LOGIC_VECTOR(3 DOWNTO 0):= "0000" ;         --ZF => flags(3)
                                                                              --NF => flags(2)
                                                                              --CF => flags(1 DOWNTO 0)
    BEGIN
        IF rising_edge(clk) THEN
            IF alu_operation = "000" THEN 
                carry_result:=STD_LOGIC_VECTOR(UNSIGNED("00" & a) + UNSIGNED("00" & b));    --ADD
                res := carry_result(15 DOWNTO 0);
                flags(1 DOWNTO 0):=carry_result(17 DOWNTO 16);                              --update CF
                IF res = x"0000" THEN                                                       --update ZF
                    flags(3) := '1';
                ELSE
                    flags(3) := '0';
                END IF;
                flags(2):= res(15);                                                         --update NF

            ELSIF alu_operation ="001" THEN
                carry_result:=STD_LOGIC_VECTOR(UNSIGNED("00" & a) - UNSIGNED("00" & b));    --SUB
                res := carry_result(15 DOWNTO 0);
                flags(1 DOWNTO 0):=carry_result(17 DOWNTO 16);                              --update CF
                IF res = x"0000" THEN                                                       --update ZF
                    flags(3) := '1';
                ELSE
                    flags(3) := '0';
                END IF;
                flags(2):= res(15);                                                         --update NF       

            ELSIF alu_operation ="010" THEN
                res:=a AND b;                                                                --AND
                IF res = x"0000" THEN                                                        --update ZF
                    flags(3) := '1';
                ELSE
                    flags(3) := '0';
                END IF;
                flags(2):= res(15);                                                         --update NF

            ELSIF alu_operation ="011" THEN
                res := a;                                                                   --MOV X,Rsrc1

            ELSIF alu_operation ="100" THEN
                carry_result:=STD_LOGIC_VECTOR(UNSIGNED("00" & a) + 1);                     --INC
                res:=carry_result(15 DOWNTO 0);
                flags(1 DOWNTO 0):=carry_result(17 DOWNTO 16);                              --update CF
                IF res = x"0000" THEN                                                       --update ZF
                    flags(3) := '1';
                ELSE
                    flags(3) := '0';
                END IF;
                flags(2):= res(15);                                                         --update NF

            ELSIF alu_operation ="101" THEN
                res:= NOT a;                                                                --NOT
                IF res = x"0000" THEN                                                       --update ZF
                    flags(3) := '1';       
                ELSE
                    flags(3) := '0'; 
                END IF;             
                flags(2):= res(15);                                                         --update NF

            ELSIF alu_operation ="110" THEN
                flags(1 DOWNTO 0):="01";                                                    --SETC

            ELSIF alu_operation ="111" THEN
                res := b;                                                                   --MOV X,Rsrc2
            END IF;

            IF flag_restore='1' THEN                                                        --restore flags from stack  
                flags:=flags_reg;
            ELSE 
                flags:=flags;
            END IF;

        END IF;
        res_reg <= res;
        flag_reg <= flags;
    END PROCESS;
    result <= res_reg;
    flag_register <= flag_reg;
END alu_arch;