LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY register_file_tb IS
END register_file_tb;

ARCHITECTURE Behavioral OF register_file_tb IS
    COMPONENT register_file
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
    END COMPONENT;

    SIGNAL write_reg : STD_LOGIC := '0';
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL write_address : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL read_address_0 : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL read_address_1 : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL write_data : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL read_data_0 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL read_data_1 : STD_LOGIC_VECTOR(15 DOWNTO 0);

    CONSTANT clk_period : TIME := 100 ps;
BEGIN
    uut : register_file
    PORT MAP(
        write_reg => write_reg,
        clk => clk,
        reset => reset,
        write_address => write_address,
        read_address_0 => read_address_0,
        read_address_1 => read_address_1,
        write_data => write_data,
        read_data_0 => read_data_0,
        read_data_1 => read_data_1
    );

    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period / 2;
        clk <= '1';
        WAIT FOR clk_period / 2;
    END PROCESS;

    sim : PROCESS
    BEGIN
        reset <= '1';
        write_reg <= '0';
        write_address <= "000";
        read_address_0 <= "000";
        read_address_1 <= "001";
        write_data <= "0000000000000000";
        WAIT FOR 200 ps;

        reset <= '0';
        WAIT FOR clk_period;

        -- Write data to register 0
        write_reg <= '1';
        write_address <= "000";
        write_data <= "1010101010101010";
        WAIT FOR clk_period;

        write_reg <= '0';
        WAIT FOR clk_period;

        -- Read data from register 0
        read_address_0 <= "000";
        WAIT FOR clk_period;

        -- Write data to register 1
        write_reg <= '1';
        write_address <= "001";
        write_data <= "1100110011001100";
        WAIT FOR clk_period;

        write_reg <= '0';
        WAIT FOR clk_period;

        -- Read data from register 1
        read_address_1 <= "001";
        WAIT FOR clk_period;

        WAIT;
    END PROCESS;
END Behavioral;