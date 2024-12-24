LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity dx_register is
    port (
      clk : in std_logic
    ) ;
  end dx_register;
  
  architecture dx_register_arch of dx_register is
  begin
      process(clk)
      begin
          if rising_edge(clk) then
            
          end if;
      end process;
  end dx_register_arch;
  