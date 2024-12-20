entity mw_register is
    port (
      clk : in std_logic;
    ) ;
  end mw_register;
  
  architecture mw_register_arch of mw_register is
  begin
      process(clk)
      begin
          if rising_edge(clk) then
          end if;
      end process;
  end mw_register_arch;
  