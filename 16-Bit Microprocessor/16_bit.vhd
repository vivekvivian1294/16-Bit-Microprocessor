-- Copyright (C) 2018  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

-- PROGRAM		"Quartus Prime"
-- VERSION		"Version 18.1.0 Build 625 09/12/2018 SJ Lite Edition"
-- CREATED		"Sat May 02 08:44:23 2020"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY \16_bit\ IS 
	PORT
	(
		clk :  IN  STD_LOGIC;
		reset :  IN  STD_LOGIC
	);
END \16_bit\;

ARCHITECTURE bdf_type OF \16_bit\ IS 

COMPONENT cntrl_unit
	PORT(clk : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 address_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 op_code_IR : IN STD_LOGIC_VECTOR(15 DOWNTO 8);
		 en_mif : OUT STD_LOGIC;
		 en_ir : OUT STD_LOGIC;
		 accu_en : OUT STD_LOGIC;
		 accu_op_code : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 address_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 alu_op_code : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 op_code : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 pc_op_code : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
END COMPONENT;

COMPONENT ram
	PORT(clk : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 we : IN STD_LOGIC;
		 address : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 data_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 data_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT accum
	PORT(clk : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 accu_en : IN STD_LOGIC;
		 acc_op_code : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 alu_acc : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 mif_acc : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 accu_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT alu
	PORT(data_a : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 data_b : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 op_code : IN STD_LOGIC_VECTOR(15 DOWNTO 8);
		 Overflow : OUT STD_LOGIC;
		 alu_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT instr_reg
	PORT(reset : IN STD_LOGIC;
		 instr_reg_en : IN STD_LOGIC;
		 instruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 address : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 op_code : OUT STD_LOGIC_VECTOR(15 DOWNTO 8)
	);
END COMPONENT;

COMPONENT mif
	PORT(reset : IN STD_LOGIC;
		 en : IN STD_LOGIC;
		 addr_fr_cu : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 addr_fr_pc : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 data_fr_acc : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 data_fr_ram : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 mif_op_code : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 we : OUT STD_LOGIC;
		 addr_to_ram : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 data_to_acc : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 data_to_alu : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 data_to_ir : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 data_to_ram : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT p_cnt
	PORT(pc_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 pc_op_code : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 pc_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	acc_alu :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	acc_op :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	accu_en :  STD_LOGIC;
SIGNAL	acu_in :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	addr :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	addr_cu :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	addr_pc :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	addr_ram :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	alu_op :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	data_alu :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	data_ir :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	data_mif :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	data_ram :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	en_ir :  STD_LOGIC;
SIGNAL	en_mif :  STD_LOGIC;
SIGNAL	mif_acc :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	mif_op :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	op_code :  STD_LOGIC_VECTOR(15 DOWNTO 8);
SIGNAL	pc_code :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;


BEGIN 



b2v_inst : cntrl_unit
PORT MAP(clk => clk,
		 reset => reset,
		 address_in => addr,
		 op_code_IR => op_code,
		 en_mif => en_mif,
		 en_ir => en_ir,
		 accu_en => accu_en,
		 accu_op_code => acc_op,
		 address_out => addr_cu,
		 alu_op_code => alu_op(7 DOWNTO 0),
		 op_code => mif_op,
		 pc_op_code => pc_code);


b2v_inst11 : ram
PORT MAP(clk => clk,
		 reset => reset,
		 we => SYNTHESIZED_WIRE_0,
		 address => addr_ram,
		 data_in => data_ram,
		 data_out => data_mif);


b2v_inst2 : accum
PORT MAP(clk => clk,
		 reset => reset,
		 accu_en => accu_en,
		 acc_op_code => acc_op,
		 alu_acc => acu_in,
		 mif_acc => mif_acc,
		 accu_out => acc_alu);


b2v_inst3 : alu
PORT MAP(data_a => acc_alu,
		 data_b => data_alu,
		 op_code => alu_op(15 DOWNTO 8),
		 alu_out => acu_in);


b2v_inst4 : instr_reg
PORT MAP(reset => reset,
		 instr_reg_en => en_ir,
		 instruction => data_ir,
		 address => addr,
		 op_code => op_code);


b2v_inst5 : mif
PORT MAP(reset => reset,
		 en => en_mif,
		 addr_fr_cu => addr_cu,
		 addr_fr_pc => addr_pc,
		 data_fr_acc => acc_alu,
		 data_fr_ram => data_mif,
		 mif_op_code => mif_op,
		 we => SYNTHESIZED_WIRE_0,
		 addr_to_ram => addr_ram,
		 data_to_acc => mif_acc,
		 data_to_alu => data_alu,
		 data_to_ir => data_ir,
		 data_to_ram => data_ram);


b2v_inst6 : p_cnt
PORT MAP(pc_in => addr_cu,
		 pc_op_code => pc_code,
		 pc_out => addr_pc);


END bdf_type;