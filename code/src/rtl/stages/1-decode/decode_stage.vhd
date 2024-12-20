entity decode_stage is
  port (
    clk : in std_logic;
  ) ;
end decode_stage;

architecture decode_stage_arch of decode_stage is
begin
    process(clk)
    begin
        if rising_edge(clk) then
        end if;
    end process;
end decode_stage_arch;