LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;

ENTITY forwarding_unit IS
    PORT (
        src1_addr : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        src2_addr : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        dst_addr : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        prev1_addr : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        prev2_addr : IN STD_LOGIC_VECTOR (2 DOWNTO 0);

        mux1_control : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
        mux2_control : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
    );
END ENTITY forwarding_unit;

ARCHITECTURE forwarding_unit_arch IS
BEGIN
    mux1_control <= "10" WHEN src1_addr = prev1_addr ELSE
        "11" WHEN src1_addr = prev2_addr ELSE
        "00";
    mux2_control <= "10" WHEN src2_addr = prev1_addr ELSE
        "11" WHEN src2_addr = prev2_addr ELSE
        "00";
END ARCHITECTURE;