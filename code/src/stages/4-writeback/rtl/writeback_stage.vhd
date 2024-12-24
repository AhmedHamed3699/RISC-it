LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY writeback_stage IS
  PORT (
    mem_to_reg : IN STD_LOGIC;
    mem_data : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
    alu_result : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
    final_result : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
  );
END writeback_stage;

ARCHITECTURE writeback_stage_arch OF writeback_stage IS

  COMPONENT mux2to1_16bit IS
    PORT (
      d0 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      d1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      sel : IN STD_LOGIC;

      y : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
  END COMPONENT;

BEGIN
  wb_mux : mux2to1_16bit PORT MAP(alu_result, mem_data, mem_to_reg, final_result);
END writeback_stage_arch;