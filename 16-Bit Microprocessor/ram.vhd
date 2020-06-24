--Final Project - 16-BIT MICROPROCESSOR
--RAM
--Libraries
library ieee;
USE ieee.std_logic_1164.all; 
USE ieee.numeric_std.all; 
USE ieee.std_logic_unsigned.all;

entity ram is port(
	oe			: in std_logic;
	clk		: in std_logic;
	reset		: in std_logic;
	we			: in std_logic;
	address	: in std_logic_vector(7 downto 0);
	data_in	: in std_logic_vector(15 downto 0);
	data_out	: out std_logic_vector(15 downto 0)
	);
end ram;

architecture rtl of ram is
--create an array
type memory_type is array (0 to 255) of std_logic_vector(15 downto 0);
signal memory : memory_type := ( 
										  0 => "0000001000001000",--load-opcode address(8)-load B
										  1 => "0000000000001001",--add-opcode address(9)-add C
										  2 => "0000000100001111",--store-opcode address(15)-store in A
										  3 => "0000001000001000",--load-opcode address(8)-load B
										  4 => "0000000100001101",--store-opcode address(13)
										  5 => "0000001000001001",--load C
										  6 => "0000001100000110",--jump to address to the same address
										  7 => "0000010000000110",--keep jumping to (4) if negative
										  8 => "0000000000000111",--value B = 7
										  9 => "0000000000000100",--value C = 4
										 15 => "0000001100001111",
										  others => x"0000" 									 
										  );
begin
process(clk,reset,we,address,data_in)
	begin
		if reset = '0' then	
			if rising_edge(clk) then
				if (we = '1') then
					--Write Operation
					memory(conv_integer(address)) <= data_in;
				end if;
			end if;
		end if;
end process;
--Read operation and convert index to an integer 
data_out <= memory(conv_integer(address)) when oe = '1' else (others => 'Z');
end rtl;