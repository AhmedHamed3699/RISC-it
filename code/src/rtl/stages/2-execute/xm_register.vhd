entity xm_register is
    port (
      clk : in std_logic;
    ) ;
  end xm_register;
  
  architecture xm_register_arch of xm_register is
  begin
      process(clk)
      begin
          if rising_edge(clk) then
          end if;
      end process;
  end xm_register_arch;
  