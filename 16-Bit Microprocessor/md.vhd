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
-- CREATED		"Thu May 28 00:48:13 2020"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY md IS 
	PORT
	(
		reset :  IN  STD_LOGIC;
		clk :  IN  STD_LOGIC
	);
END md;

ARCHITECTURE bdf_type OF md IS 

COMPONENT p_cnt
	PORT(clk : IN STD_LOGIC;
		 pc_en : IN STD_LOGIC;
		 pc_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 pc_op_code : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 pc_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT ram
	PORT(oe : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
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
		 accu_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 accu_out_mem : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT mif
	PORT(en : IN STD_LOGIC;
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

COMPONENT instr_reg
	PORT(clk : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 instr_reg_en : IN STD_LOGIC;
		 instruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 address : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 op_code : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT alu
	PORT(data_a : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 data_b : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 op_code : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 zero_flag : OUT STD_LOGIC;
		 Overflow : OUT STD_LOGIC;
		 alu_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT cntrl_unit
	PORT(clk : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 overflow : IN STD_LOGIC;
		 address_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 op_code_IR : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 oe_r : OUT STD_LOGIC;
		 en_mif : OUT STD_LOGIC;
		 pc_ena : OUT STD_LOGIC;
		 accu_en : OUT STD_LOGIC;
		 en_ir : OUT STD_LOGIC;
		 accu_op_code : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 address_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 alu_op_code : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 op_code : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 pc_op_code : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	acc_en :  STD_LOGIC;
SIGNAL	addr :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	en_ir :  STD_LOGIC;
SIGNAL	op_code :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_21 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_6 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_7 :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_8 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_9 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_10 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_12 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_13 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_14 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_15 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_16 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_17 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_18 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_19 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_20 :  STD_LOGIC;


BEGIN 



b2v_inst1 : p_cnt
PORT MAP(clk => clk,
		 pc_en => SYNTHESIZED_WIRE_0,
		 pc_in => SYNTHESIZED_WIRE_21,
		 pc_op_code => SYNTHESIZED_WIRE_2,
		 pc_out => SYNTHESIZED_WIRE_12);


b2v_inst10 : ram
PORT MAP(oe => SYNTHESIZED_WIRE_3,
		 clk => clk,
		 reset => reset,
		 we => SYNTHESIZED_WIRE_4,
		 address => SYNTHESIZED_WIRE_5,
		 data_in => SYNTHESIZED_WIRE_6,
		 data_out => SYNTHESIZED_WIRE_14);


b2v_inst2 : accum
PORT MAP(clk => clk,
		 reset => reset,
		 accu_en => acc_en,
		 acc_op_code => SYNTHESIZED_WIRE_7,
		 alu_acc => SYNTHESIZED_WIRE_8,
		 mif_acc => SYNTHESIZED_WIRE_9,
		 accu_out => SYNTHESIZED_WIRE_18,
		 accu_out_mem => SYNTHESIZED_WIRE_13);


b2v_inst21 : mif
PORT MAP(en => SYNTHESIZED_WIRE_10,
		 addr_fr_cu => SYNTHESIZED_WIRE_21,
		 addr_fr_pc => SYNTHESIZED_WIRE_12,
		 data_fr_acc => SYNTHESIZED_WIRE_13,
		 data_fr_ram => SYNTHESIZED_WIRE_14,
		 mif_op_code => SYNTHESIZED_WIRE_15,
		 we => SYNTHESIZED_WIRE_4,
		 addr_to_ram => SYNTHESIZED_WIRE_5,
		 data_to_acc => SYNTHESIZED_WIRE_9,
		 data_to_alu => SYNTHESIZED_WIRE_17,
		 data_to_ir => SYNTHESIZED_WIRE_16,
		 data_to_ram => SYNTHESIZED_WIRE_6);


b2v_inst4 : instr_reg
PORT MAP(clk => clk,
		 reset => reset,
		 instr_reg_en => en_ir,
		 instruction => SYNTHESIZED_WIRE_16,
		 address => addr,
		 op_code => op_code);


b2v_inst5 : alu
PORT MAP(data_a => SYNTHESIZED_WIRE_17,
		 data_b => SYNTHESIZED_WIRE_18,
		 op_code => SYNTHESIZED_WIRE_19,
		 Overflow => SYNTHESIZED_WIRE_20,
		 alu_out => SYNTHESIZED_WIRE_8);


b2v_inst7 : cntrl_unit
PORT MAP(clk => clk,
		 reset => reset,
		 overflow => SYNTHESIZED_WIRE_20,
		 address_in => addr,
		 op_code_IR => op_code,
		 oe_r => SYNTHESIZED_WIRE_3,
		 en_mif => SYNTHESIZED_WIRE_10,
		 pc_ena => SYNTHESIZED_WIRE_0,
		 accu_en => acc_en,
		 en_ir => en_ir,
		 accu_op_code => SYNTHESIZED_WIRE_7,
		 address_out => SYNTHESIZED_WIRE_21,
		 alu_op_code => SYNTHESIZED_WIRE_19,
		 op_code => SYNTHESIZED_WIRE_15,
		 pc_op_code => SYNTHESIZED_WIRE_2);


END bdf_type;