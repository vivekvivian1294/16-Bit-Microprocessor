--Final Project - 16-BIT MICROPROCESSOR
--PROGRAM COUNTER
--Libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity p_cnt is port(
	clk			: in std_logic;
	pc_en			: in std_logic;
	pc_op_code	: in 	std_logic_vector(1 downto 0);
	pc_in			: in 	std_logic_vector(7 downto 0);
	pc_out		: out std_logic_vector(7 downto 0)
);
end p_cnt;

architecture rtl of p_cnt is
	signal pc   : std_logic_vector(7 downto 0) := x"00"; --set it to 0
begin
	process(clk,pc_op_code,pc_en,pc_in)	
		begin
	if pc_en = '0' then
		pc <= x"00";
	elsif rising_edge(clk) then
		if pc_en = '1'then
			if pc_op_code = "10" then
				pc <= pc + 1; --increment PC by 1
			elsif pc_op_code = "11" then
				pc <= pc_in;
			end if;
		end if;
	end if;
end process;
pc_out <= pc;
end rtl;