vsim -gui work.register_file
add wave -position insertpoint sim:/register_file/*

force -freeze sim:/register_file/reset 1 0
force -freeze sim:/register_file/read_address_1 000 0
force -freeze sim:/register_file/read_address_0 000 0
force -freeze sim:/register_file/write_address 000 0
force -freeze sim:/register_file/write_data 00000000 0
force -freeze sim:/register_file/write_reg 0 0
force -freeze sim:/register_file/clk 1 0, 0 {50 ps} 100
run

force -freeze sim:/register_file/clk 1 0, 0 {50 ps} 100
force -freeze sim:/register_file/reset 0 0
force -freeze sim:/register_file/write_data 11111111 0  
force -freeze sim:/register_file/write_address 000 0           
force -freeze sim:/register_file/write_reg 1 0                  
run

force -freeze sim:/register_file/write_address 001 0 
force -freeze sim:/register_file/write_data 00010001 0   
force -freeze sim:/register_file/write_reg 1 0
force -freeze sim:/register_file/clk 1 0, 0 {50 ps} 100
run

force -freeze sim:/register_file/clk 1 0, 0 {50 ps} 100
force -freeze sim:/register_file/write_address 111 0           
force -freeze sim:/register_file/write_data 10010000 0   
force -freeze sim:/register_file/write_reg 1 0                  
run

force -freeze sim:/register_file/clk 1 0, 0 {50 ps} 100
force -freeze sim:/register_file/write_address 011 0           
force -freeze sim:/register_file/write_data 00001000 0   
force -freeze sim:/register_file/write_reg 1 0                  
run

force -freeze sim:/register_file/clk 1 0, 0 {50 ps} 100
force -freeze sim:/register_file/read_address_0 001 0           
force -freeze sim:/register_file/read_address_1 111 0           
force -freeze sim:/register_file/write_address 100 0            
force -freeze sim:/register_file/write_data 00000011 0    
force -freeze sim:/register_file/write_reg 1 0                   
run

force -freeze sim:/register_file/clk 1 0, 0 {50 ps} 100
force -freeze sim:/register_file/write_reg 0 0                   
force -freeze sim:/register_file/read_address_0 010 0           
force -freeze sim:/register_file/read_address_1 011 0           
run

force -freeze sim:/register_file/clk 1 0, 0 {50 ps} 100
force -freeze sim:/register_file.read_address_0 100 0           
force -freeze sim:/register_file.read_address_1 101 0           
run

force -freeze sim:/register_file/clk 1 0, 0 {50 ps} 100
force -freeze sim:/register_file.read_address_0 110 0           
force -freeze sim:/register_file.read_address_1 000 0           
force -freeze sim:/register_file.write_address 000 0             
force -freeze sim:/register_file.write_data 00000001 0    
force -freeze sim:/register_file.write_reg 1 0                   
run
