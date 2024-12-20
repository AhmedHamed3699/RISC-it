LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;

ENTITY exception_unit IS
    PORT (
        clk : IN STD_LOGIC;
        PC : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        SP : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        SP_enable : IN STD_LOGIC;
        mem_excep : IN STD_LOGIC;
        exception : OUT STD_LOGIC;
        exception_type : OUT STD_LOGIC;
    );
END ENTITY exception_unit;

ARCHITECTURE exception_unit_arch OF exception_unit IS
    CONSTANT mem_depth : INTEGER := 4096;
    SIGNAL EPC : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
BEGIN
    PROCESS (clk) IS
    BEGIN
        IF RISING_EDGE(clk) THEN
            IF (mem_excep = '1') THEN
                exception <= '1';
                exception_type <= '1';
                EPC <= PC;
            ELSIF (SP_enable = '1' AND SP >= stack_start) THEN
                exception <= '1';
                exception_type <= '0';
                EPC <= PC;
            ELSE
                exception <= '0';
                exception_type <= '0';
            END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE;