entity fetch_stage is
    port (
      clk : in std_logic;
    ) ;
  end fetch_stage;
  
  architecture fetch_stage_arch of fetch_stage is
  begin
      process(clk)
      begin
          if rising_edge(clk) then
          end if;
      end process;
  end fetch_stage_arch;