LIBRARY ieee; 
USE ieee.std_logic_1164.all; 
USE ieee.numeric_std.all; 

ENTITY hazard_detection_unit IS PORT(
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
END hazard_detection_unit; 

ARCHITECTURE hazard_detection_arch of hazard_detection_unit IS 
BEGIN 
    stall <= '1' WHEN (((IF_ID_Rsrc1 = ID_EX_Rdst) OR (IF_ID_Rsrc2=ID_EX_Rdst)) AND ID_EX_mem_read = '1') ELSE -- load-use case 
             '0';

    hazard <='1' WHEN (((IF_ID_Rsrc1 = ID_EX_Rdst) OR (IF_ID_Rsrc2=ID_EX_Rdst)) AND ID_EX_mem_read = '1') ELSE -- load-use case
             '0';   

    will_branch <= '1' WHEN (ret='1' OR rti='1' OR ID_EX_branch='1' OR EX_MEM_branch='1') ELSE                  --contorl hazard
                  '0';
 
END hazard_detection_arch;