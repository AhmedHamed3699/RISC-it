LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity decode_stage is
  port (
    clk           : in std_logic;
    reset         : in std_logic;
    inst          : in std_logic_vector(15 downto 0);
    MEM_WB_rti    : in std_logic;
    ID_EX_rti     : in std_logic;
    ret           : in std_logic;
    write_reg     : in std_logic;
    has_immediate : in std_logic;
    data_to_write : in std_logic_vector(15 downto 0);
    WB_Rdst       : in std_logic_vector(2 downto 0);
    PC_in         : in std_logic_vector(15 downto 0);
    ID_EX_Rdst    : in std_logic_vector(2 downto 0);
    ID_EX_Rsrc1   : in std_logic_vector(2 downto 0);
    ID_EX_Rsrc1_data   : in std_logic_vector(15 downto 0);
    ID_EX_mem_read: in std_logic;
    ID_EX_branch  : in std_logic;
    EX_MEM_branch : in std_logic;
    ID_EX_stackop1: in std_logic;
    pc_out        : out std_logic_vector(15 downto 0);
    Rsrc1, Rsrc2  : out std_logic_vector(15 downto 0);
    Rsrc1_add, Rsrc2_add : out std_logic_vector(2 downto 0);
    Rdst_address  : out std_logic_vector(2 downto 0);
    imm           : out std_logic_vector(15 downto 0);
    inst0         : out std_logic;
    hazard        : out std_logic;
    stall         : out std_logic;
    will_branch   : out std_logic;
    jmp_add       : out std_logic_vector(15 downto 0);
    control_signals: out std_logic_vector(19 downto 0)
  );
end decode_stage;

architecture decode_stage_arch of decode_stage is

  component hazard_detection_unit IS PORT(
    IF_ID_Rsrc1,IF_ID_Rsrc2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    ID_EX_Rdst              : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    ID_EX_mem_read          : IN  STD_LOGIC;
    ret                     : IN  STD_LOGIC;
    rti                     : IN  STD_LOGIC;
    ID_EX_branch            : IN  STD_LOGIC;
    EX_MEM_branch            : IN  STD_LOGIC;
    hazard                  : OUT STD_LOGIC;
    stall                   : OUT STD_LOGIC;
    will_branch             : OUT STD_LOGIC
  );
  end component;

  component control_unit is
    port (
      clk : in std_logic;
      opcode : in std_logic_vector(4 downto 0);
      in_enable, out_enable, reg_write, mem_write, mem_read, mem_to_reg, is_immediate,
      branch, call, ret, interrupt, rti, freeze : out std_logic;
      alu_operation : out std_logic_vector(2 downto 0);
      stack_operation : out std_logic_vector(1 downto 0);
      jump_type : out std_logic_vector(1 downto 0)
    );
  end component;

  component register_file is
    port (
      write_reg : in std_logic;
      clk, reset : in std_logic;
      write_address, read_address_0, read_address_1 : in std_logic_vector(2 downto 0);
      write_data : in std_logic_vector(15 downto 0);
      read_data_0, read_data_1 : out std_logic_vector(15 downto 0)
    );
  end component;

  component mux2to1_16bit is
    port (
      d0, d1 : in std_logic_vector(15 downto 0);
      sel : in std_logic;
      y : out std_logic_vector(15 downto 0)
    );
  end component;

  signal control_unit_out : std_logic_vector(19 downto 0);
  signal JMP_dst_Mux_selector, NOP_mux_selector, signals_mux_selector : std_logic;
  signal NOP : std_logic_vector(15 downto 0) := x"0000";
  signal rsrc1_address,rsrc2_address:std_logic_vector(2 downto 0);
  signal hazard_signal : std_logic;
  signal selected_inst : std_logic_vector(15 downto 0);
  signal dummy : std_logic_vector(15 downto 0);
  signal dumy : std_logic_vector(15 downto 0);

begin
  inst0 <= selected_inst(0);

  Rsrc1_add <= selected_inst(10 downto 8);
  Rsrc2_add <= selected_inst(4 downto 2);
  rsrc1_address<=selected_inst(10 downto 8);
  rsrc2_address<=selected_inst(4 downto 2);

  reg_file: register_file
    port map (
      write_reg => write_reg,
      clk => clk,
      reset => reset,
      write_address => WB_Rdst,
      read_address_0 => selected_inst(10 downto 8),
      read_address_1 => selected_inst(4 downto 2),
      write_data => data_to_write,
      read_data_0 => Rsrc1,
      read_data_1 => Rsrc2
    );

  CU: control_unit
    port map (
      clk => clk,
      opcode => selected_inst(15 downto 11),
      in_enable => control_unit_out(0),
      out_enable => control_unit_out(1),
      reg_write => control_unit_out(2),
      mem_write => control_unit_out(3),
      mem_read => control_unit_out(4),
      mem_to_reg => control_unit_out(5),
      alu_operation => control_unit_out(8 downto 6),
      is_immediate => control_unit_out(9),
      stack_operation => control_unit_out(11 downto 10),
      branch => control_unit_out(12),
      jump_type => control_unit_out(14 downto 13),
      call => control_unit_out(15),
      ret => control_unit_out(16),
      interrupt => control_unit_out(17),
      rti => control_unit_out(18),
      freeze => control_unit_out(19)
    );

  HDU: hazard_detection_unit
    port map (
      IF_ID_Rsrc1 => rsrc1_address,
      IF_ID_Rsrc2 => rsrc2_address,
      ID_EX_Rdst => ID_EX_Rdst,
      ID_EX_mem_read => ID_EX_mem_read,
      ret => ret,
      rti => MEM_WB_rti,
      ID_EX_branch => ID_EX_branch,
      EX_MEM_branch => EX_MEM_branch,
      hazard => hazard_signal,
      stall => stall,
      will_branch => will_branch
    );

  JMP_dst_Mux_selector <= ret or MEM_WB_rti;

  JMP_dst_mux: mux2to1_16bit
    port map (
      d0 => ID_EX_Rsrc1_data,
      d1 => data_to_write,
      sel => JMP_dst_Mux_selector,
      y => jmp_add
    );

  NOP_mux_selector <= ID_EX_rti or has_immediate;

  NOP_inst_mux: mux2to1_16bit
    port map (
      d0 => NOP,
      d1 => inst,
      sel => NOP_mux_selector,
      y => selected_inst
    );

  signals_mux_selector <= hazard_signal or has_immediate;

  selected_signals_mux1: mux2to1_16bit
    port map (
      d0 => control_unit_out(19 downto 4),
      d1 => x"0000",
      sel => signals_mux_selector,
      y => control_signals(19 downto 4)
    );

    dumy <= "000000000000" & control_unit_out(3 downto 0);

  selected_signals_mux2: mux2to1_16bit
    port map (
      d0 => dumy,
      d1 => x"0000",
      sel => signals_mux_selector,
      y => dummy
    );

  control_signals(3 downto 0) <= dummy(3 downto 0);

end decode_stage_arch;
