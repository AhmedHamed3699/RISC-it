LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY tb_data_memory IS
END ENTITY tb_data_memory;

ARCHITECTURE behavior OF tb_data_memory IS
    COMPONENT data_memory
        PORT (
            clk : IN STD_LOGIC;
            we : IN STD_LOGIC;
            re : IN STD_LOGIC;
            address : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            write_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            read_data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL we : STD_LOGIC := '0';
    SIGNAL re : STD_LOGIC := '0';
    SIGNAL address : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL write_data : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL read_data : STD_LOGIC_VECTOR(15 DOWNTO 0);

    CONSTANT clk_period : TIME := 10 ns;

BEGIN
    uut : data_memory
    PORT MAP(
        clk => clk,
        we => we,
        re => re,
        address => address,
        write_data => write_data,
        read_data => read_data
    );

    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period / 2;
        clk <= '1';
        WAIT FOR clk_period / 2;
    END PROCESS;

    stimulus_process : PROCESS
    BEGIN

        -- Write data to address 0x10
        we <= '1'; -- Enable write
        re <= '0'; -- Disable read
        address <= X"0010";
        write_data <= X"ABCD";
        WAIT FOR clk_period;

        -- Write data to address 0x20
        address <= X"0020";
        write_data <= X"1234";
        WAIT FOR clk_period;

        -- Read data from address 0x10 (should return X"ABCD")
        we <= '0'; -- Disable write
        re <= '1'; -- Enable read
        address <= X"0010";
        WAIT FOR clk_period;

        -- Read data from address 0x20 (should return X"1234")
        address <= X"0020";
        WAIT FOR clk_period;

        -- Read data from an invalid address (0xFFFF)
        address <= X"FFFF"; -- Out of memory range
        WAIT FOR clk_period;

        address <= X"0030"; -- should return 0x0000 (unwritten memory space)
        WAIT FOR clk_period;

        we <= '1'; -- Enable write
        address <= X"0111";

        WAIT;
    END PROCESS;

END ARCHITECTURE behavior;