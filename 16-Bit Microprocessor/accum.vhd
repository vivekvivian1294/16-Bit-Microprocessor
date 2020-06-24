--Final Project - 16-BIT MICROPROCESSOR
--ACCUMULATOR
--Libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity accum is port(
	clk			: in std_logic;
	reset			: in std_logic;
	mif_acc		: in std_logic_vector (15 downto 0); --data from the memory
	accu_en		: in std_logic;
	acc_op_code	: in std_logic_vector(1 downto 0); --op code from the control unit
	alu_acc		: in std_logic_vector (15 downto 0); 
	accu_out_mem: out std_logic_vector (15 downto 0);--data to MIF
	accu_out		: out std_logic_vector (15 downto 0) --data to memory or ALU
);
end accum;

architecture rtl of accum is
signal register_accum: std_logic_vector(15 downto 0) := x"0000";
begin
	process(clk,reset,accu_en,acc_op_code,mif_acc,alu_acc)
	begin
		if reset = '0' then
			register_accum <= x"0000";
		elsif rising_edge(clk) then
			
			if accu_en = '0' then
				if acc_op_code = "00" then -- add operation send data to alu
					accu_out	<= register_accum;
					register_accum <= x"0000";

				elsif acc_op_code = "10" then -- load operation data from memory to accum
					register_accum <= mif_acc;
				end if;
			
			elsif accu_en = '1' then
				if acc_op_code = "01" then --store operation- data from alu to accum
					register_accum <= alu_acc;
				
					elsif acc_op_code <= "11" then
					accu_out_mem <= register_accum;--store the data from alu into the accumulator
				end if;
			end if;
		end if;
	end process;
end rtl;
			