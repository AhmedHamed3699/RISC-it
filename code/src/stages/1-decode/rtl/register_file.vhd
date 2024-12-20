LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY register_file IS
    PORT (
        write_reg : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        write_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        read_address_0 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        read_address_1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        write_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        read_data_0 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        read_data_1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END register_file;

ARCHITECTURE register_file_arch OF register_file IS
    TYPE register_file_array IS ARRAY (0 TO 7) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL mem : register_file_array;
BEGIN
    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            mem <= (OTHERS => (OTHERS => '0'));
        ELSIF rising_edge(clk) THEN
            IF write_reg = '1' THEN
                mem(to_integer(unsigned(write_address))) <= write_data;
            END IF;
        END IF;
    END PROCESS;
    read_data_0 <= mem(to_integer(unsigned(read_address_0)));
    read_data_1 <= mem(to_integer(unsigned(read_address_1)));
END register_file_arch;