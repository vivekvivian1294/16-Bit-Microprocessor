--Final Project - 16-BIT MICROPROCESSOR
--INSTRUCTION REGISTER
--Libraries
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity instr_reg is port(
	clk				: in std_logic;
	reset				: in std_logic;
	instr_reg_en	: in std_logic;
	instruction 	: in std_logic_vector(15 downto 0);
	address			: out std_logic_vector(7 downto 0);
	op_code			: out std_logic_vector(7 downto 0)
);
end instr_reg;

architecture rtl of instr_reg is
signal add : std_logic_vector(7 downto 0);
signal op : std_logic_vector(7 downto 0);

begin
	process(clk,reset,instr_reg_en,instruction,add,op)
		begin
			if reset = '0' then
				add <= x"00";
				op <= x"00";
			elsif rising_edge(clk) then
				if instr_reg_en = '1' then
					add <= instruction(7 downto 0);-- to Program Counter
					op <= instruction(15 downto 8);-- to control unit
				end if;
			end if;
	end process;
op_code <= op;
address <= add;
end rtl;