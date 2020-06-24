--Final Project - 16-BIT MICROPROCESSOR
--ARITHMETIC LOGIC UNIT
--Libraries
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu is port(
	data_a	: in  std_logic_vector(15 downto 0);
	op_code	: in  std_logic_vector(7 downto 0);
	data_b	: in  std_logic_vector(15 downto 0);
	alu_out	: out std_logic_vector(15 downto 0);
	zero_flag: out std_logic;
	Overflow : out std_logic       
);
end alu;

architecture  rtl of alu is
signal ALU_Result : std_logic_vector (15 downto 0);
signal temp  		: std_logic_vector(16 downto 0);
	begin
		process (op_code,data_a,data_b,ALU_Result,temp)
		--variable ovf : std_logic;
			begin
				case op_code is
					when "00000000" => temp <= std_logic_vector(signed(data_a(15) & data_a) + signed(data_b(15) & data_b));
											ALU_Result <= temp(15 downto 0);
											--ovf := temp(16);
											--Overflow <= ALU_Result(15) xor data_a(15) xor data_b(15) xor ovf;
											Overflow <= temp(16);
												
					when "00000001" => temp <= std_logic_vector(signed(data_a(15) & data_a) - signed(data_b(15) & data_b));
											ALU_Result <= temp(15 downto 0);
											--ovf := temp(16);
											--Overflow <= ALU_Result(15) xor data_a(15) xor data_b(15) xor ovf;
											--temp <= '0' or data_a(15) xor data_b(15);
											Overflow <= temp(16);
												
					when "00000010" => ALU_Result <= data_a and data_b;
					
					when "00000011" => ALU_Result <= data_a or data_b;
					
					when others => ALU_Result <= data_a; 
				end case;
			if (ALU_RESULT = x"0000") then 
				zero_flag <= '1';
			else
				zero_flag <= '0';
			end if;
		end process;	
		alu_out <= ALU_Result;
end rtl;