entity memory_stage is
    port (
      clk : in std_logic;
    ) ;
  end memory_stage;
  
  architecture memory_stage_arch of memory_stage is
  begin
      process(clk)
      begin
          if rising_edge(clk) then
          end if;
      end process;
  end memory_stage_arch;