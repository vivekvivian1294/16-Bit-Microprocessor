--Final Project - 16-BIT MICROPROCESSOR
--CONTROL UNIT
--Libraries
library ieee;
use IEEE.std_logic_1164.all; 
use ieee.numeric_std.all; 

Entity Cntrl_Unit is port(
	clk 				: in std_logic;
	reset 			: in std_logic;
	address_in		: in std_logic_vector(7 downto 0);
	op_code_IR 		: in std_logic_vector(7 downto 0);
	oe_r				: out std_logic := '0';
	address_out		: out std_logic_vector(7 downto 0) := x"00";
	op_code 			: out std_logic_vector(7 downto 0) := x"00";
	en_mif			: out std_logic := '0';
	pc_ena			: out std_logic := '0';
   pc_op_code 	 	: out std_logic_vector(1 downto 0) := "00";
	alu_op_code	 	: out std_logic_vector(7 downto 0) := x"00";
	accu_op_code	: out std_logic_vector(1 downto 0) := "00";
	accu_en			: out std_logic := '0';
	en_ir			 	: out std_logic := '0';
	overflow			: in std_logic
);
end Cntrl_Unit;

Architecture FSM of Cntrl_Unit is
	type state_type is (reset_state,fetch,decode,add,add1,store,load,jump,jneg);
	--Signals
	signal state: state_type;
begin
	demo_process : process(clk,reset,op_code_IR,address_in,overflow)
	begin
		if(reset = '0') then
			state <= reset_state;
		elsif(rising_edge(clk)) then
			case state is
				when reset_state  => state <= fetch;
				when fetch			=> state <= decode;
				when decode 		=> case op_code_IR (7 downto 0) is
												when x"00" => state <= add;
												when x"01" => if overflow = '0' then
																	state <= store;
																  elsif overflow = '1' then
																	state <= jneg;
																  end if;
												when x"02" => state <= load;
												when x"03" => state <= jump;
												when x"04" => state <= jneg;
												when others => state <= fetch;
											end case ;
				when add				=> state	<= add1;
				when add1         => state <= fetch;
				when store   	   => state <= fetch;
				when load  		   => state	<= fetch;
				when jump   		=> state <= fetch;
				when jneg			=> state <= fetch;
				when others 		=> state <= fetch;
			end case;
		end if;
	end process;

output_process : process(state,op_code_IR,address_in)
	begin
--default values for all the output signals
	--oe_r				<= '0';
	--address_out		<= x"00";
	--op_code 			<= "00";
	--en_mif			<= '0';
	--pc_ena			<= '0';
   --pc_op_code 	 	<= x"00";
	--alu_op_code	 	<= x"00";
	--accu_op_code	<= x"00";
	--accu_en			<= '0';
	--en_ir			 	<= '0';
	
		case state is
			when reset_state 	=> pc_ena       <= '0';--reset PC
										oe_r			 <= '0';--disable read operation
										
			when fetch			=> pc_ena 		 <= '1';--enable PC
										en_mif 		 <= '0';--mif performs read and fetches the data
										oe_r 			 <= '1';--read enable for the ram
										en_ir 		 <= '1';--enable IR to split instruction
										pc_op_code   <= "10";--send address to mif
										
			when decode 		=>	pc_op_code   <= "00";--send address to mif
										oe_r 		 	 <= '0';--Disable memory read
			
			when add				=> op_code		 <= op_code_IR;--send op-code to MIF
										address_out  <= address_in;--send address to MIF
										oe_r 			 <= '1';
										accu_en 		 <= '0';--enable accumulator
										accu_op_code <= "00";--signal accumulator to send data to alu
										alu_op_code  <= op_code_IR;--op code to alu to perform add opreration
																				
			when add1			=>	en_mif 		 <= '1';--enable MIF to perform add operation
										accu_en 		 <= '1';--enable accumulator
										accu_op_code <= "01";--take data from the alu and keep it in the accumulator
			
			when store			=>	accu_en 		 <= '1';--enable accumulator
										accu_op_code <= "11";--tell accumulator to send data to RAM
										op_code 		 <= op_code_IR;--send op-code to MIF
										address_out  <= address_in;--send address to MIF
										en_mif 		 <= '1';--enable MIF to perform store operation
				 
			when load			=> op_code 		 <= op_code_IR;--send op-code to MIF
										address_out  <= address_in;--send address to MIF
										en_mif 		 <= '1';--enable MIF to perform load operation
										oe_r 			 <= '1';
										accu_en 		 <= '0';--enable accumulator
										accu_op_code <= "10";--enable the accumulator to accept data
										
			when jump			=> address_out  <= address_in;--send address to PC
										op_code 		 <= op_code_IR;--send op-code to MIF
										pc_op_code 	 <= "11";--jump to address
											
										
			when jneg			=>	address_out <= address_in;
										pc_op_code 	<= "11";--jump to address
										
			when others 		=> null;
	
		end case;
	end process;
end FSM;
