--Final Project - 16-BIT MICROPROCESSOR
--MEMORY INTERFACE
--Libraries
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mif is port(
	we				: out std_logic;	
	data_fr_ram : in std_logic_vector(15 downto 0);
	data_fr_acc : in std_logic_vector(15 downto 0);
	addr_fr_cu  : in std_logic_vector(7 downto 0);
	mif_op_code : in std_logic_vector(7 downto 0);
	en      		: in std_logic;
	addr_fr_pc  : in std_logic_vector(7 downto 0);
	addr_to_ram : out std_logic_vector(7 downto 0);
	data_to_ram : out std_logic_vector(15 downto 0);
	data_to_ir  : out std_logic_vector(15 downto 0);
	data_to_acc : out std_logic_vector(15 downto 0);
	data_to_alu : out std_logic_vector(15 downto 0)
);
end mif;

architecture rtl of mif is
signal value_disp : std_logic_vector(15 downto 0) := x"0000";
begin
	process(en,mif_op_code,addr_fr_pc,data_fr_ram,addr_fr_cu,data_fr_acc,value_disp)
	begin
		if en = '0' then
				we <= '0';
				addr_to_ram <= addr_fr_pc;
				data_to_ir <= data_fr_ram;
		elsif en = '1' then	
			if mif_op_code = "00000010" then -- load
				addr_to_ram <= addr_fr_cu;
				data_to_acc <= data_fr_ram;
				
			elsif mif_op_code = "00000000" then --add
				addr_to_ram  <= addr_fr_cu;
				data_to_alu <= data_fr_ram; 
					
			elsif mif_op_code = "00000001" then --store
				addr_to_ram <= addr_fr_cu;
				we <= '1';
				data_to_ram <= data_fr_acc;
				
			elsif mif_op_code = "00000011" then --jump
				addr_to_ram <= addr_fr_pc;
				value_disp <= data_fr_ram;
			end if;
		end if;
end process;
end rtl;		
			