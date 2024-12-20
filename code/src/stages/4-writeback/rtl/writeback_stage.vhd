entity writeback_stage is
    port (
      clk : in std_logic;
    ) ;
  end writeback_stage;
  
  architecture writeback_stage_arch of writeback_stage is
  begin
      process(clk)
      begin
          if rising_edge(clk) then
          end if;
      end process;
  end writeback_stage_arch;