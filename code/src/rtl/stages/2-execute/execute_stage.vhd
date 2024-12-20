entity execute_stage is
    port (
      clk : in std_logic;
    ) ;
  end execute_stage;
  
  architecture execute_stage_arch of execute_stage is
  begin
      process(clk)
      begin
          if rising_edge(clk) then
          end if;
      end process;
  end execute_stage_arch;