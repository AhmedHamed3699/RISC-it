entity stack_selector_unit is
  port (
    rti : IN STD_LOGIC;
    int: IN STD_LOGIC;
    stack_op : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
    stack_sel : OUT STD_LOGIC_VECTOR (1 DOWNTO 0)
  ) ;
end stack_selector_unit;

architecture stack_selector_unit_arch of stack_selector_unit is
begin
    stack_sel <= "11" WHEN (int = '1') ELSE
              "10" WHEN (rti = '1') ELSE
              stack_op;
end stack_selector_unit_arch;