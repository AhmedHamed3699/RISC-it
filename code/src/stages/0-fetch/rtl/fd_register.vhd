entity fd_register is
  port (
    clk : in std_logic;
  ) ;
end fd_register;

architecture fd_register_arch of fd_register is
begin
    process(clk)
    begin
        if rising_edge(clk) then
        end if;
    end process;
end fd_register_arch;
