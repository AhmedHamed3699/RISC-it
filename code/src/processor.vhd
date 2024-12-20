library ieee;
use ieee.std_logic_1164.all;
entity risc is
  port (
    clk : IN STD_LOGIC := '0';
    rst : IN STD_LOGIC;
    in_port : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    out_port : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
end risc;

architecture risc_arch of risc is
begin

end architecture risc_arch;