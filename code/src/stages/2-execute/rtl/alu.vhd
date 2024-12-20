LIBRARY ieee; 
USE ieee.std_logic_1164.all; 
USE ieee.numeric_std.all;

ENTITY alu IS PORT (
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
    SIGNAL flag_reg   :STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN 
    PROCESS(flag_restore , flags_reg , a , b , alu_operation)
        VARIABLE res         :STD_LOGIC_VECTOR(15 DOWNTO 0);
        VARIABLE carry_result:STD_LOGIC_VECTOR(17 DOWNTO 0);
        VARIABLE flags       :STD_LOGIC_VECTOR(3 DOWNTO 0):= "0000" ;   --ZF => flags(3)
                                                                        --NF => flags(2)
                                                                        --CF => flags(1 DOWNTO 0)
    BEGIN
		-- Default values for flags
        flags := "0000";
    
        CASE alu_operation IS
            WHEN "000" =>                                                                    -- ADD
                carry_result := STD_LOGIC_VECTOR(UNSIGNED("00" & a) + UNSIGNED("00" & b));
                res := carry_result(15 DOWNTO 0);
                flags(1 DOWNTO 0) := carry_result(17 DOWNTO 16);                             -- update CF
                IF res = x"0000" THEN
                        flags(3) := '1';                                                     -- update ZF
                    ELSE
                        flags(3) := '0';
                    END IF;               
                flags(2) := res(15);                                                         -- update NF

            WHEN "001" =>                                                                    -- SUB
                carry_result := STD_LOGIC_VECTOR(UNSIGNED("00" & a) - UNSIGNED("00" & b));
                res := carry_result(15 DOWNTO 0);
                flags(1 DOWNTO 0) := carry_result(17 DOWNTO 16);                             -- update CF
                IF res = x"0000" THEN
                        flags(3) := '1';                                                     -- update ZF
                    ELSE
                        flags(3) := '0';
                    END IF;                
                flags(2) := res(15);                                                         -- update NF

            WHEN "010" =>                                                                    -- AND
                res := a AND b;
                IF res = x"0000" THEN
                        flags(3) := '1';                                                     -- update ZF
                    ELSE
                        flags(3) := '0';
                    END IF;   
                flags(2) := res(15);                                                         -- update NF

            WHEN "011" =>                                                                    -- MOV X, Rsrc1
                res := a;

            WHEN "100" =>                                                                    -- INC
                carry_result := STD_LOGIC_VECTOR(UNSIGNED("00" & a) + 1);
                res := carry_result(15 DOWNTO 0);
                flags(1 DOWNTO 0) := carry_result(17 DOWNTO 16);                             -- update CF
                IF res = x"0000" THEN
                        flags(3) := '1';                                                     -- update ZF
                    ELSE
                        flags(3) := '0';
                    END IF;                   
                flags(2) := res(15);                                                         -- update NF
                
            WHEN "101" =>                                                                    -- NOT
                res := NOT a;
                IF res = x"0000" THEN
                        flags(3) := '1';                                                    -- update ZF
                    ELSE
                        flags(3) := '0';
                    END IF;                   
                flags(2) := res(15);                                                        -- NF

            WHEN "110" =>                                                                   -- SETC
                flags(1 DOWNTO 0) := "01";

            WHEN "111" =>                                                                   -- MOV X, Rsrc2
                res := b;

            WHEN OTHERS =>
                res := (OTHERS => '0');
                flags := (OTHERS => '0');
        END CASE;

        -- Restore flags if needed
        IF flag_restore = '1' THEN
            flags := flags_reg;
        ELSE 
            flags:=flags;
        END IF;

        res_reg <= res;
        flag_reg <= flags;
    END PROCESS;
    result <= res_reg;
    flag_register <= flag_reg;
END alu_arch;