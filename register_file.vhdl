library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;
library std;
use std.standard.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity RegisterFile is
	port (
		clk, write_flag        : in std_logic;
		addr1, addr2, addr3    : in std_logic_vector(2 downto 0);
		data_write3, PC_in           : in std_logic_vector(15 downto 0);
		data_read1, data_read2, PC_out : out std_logic_vector(15 downto 0);
		reg0, reg1, reg2, reg3,
		reg4, reg5, reg6, reg7 : out std_logic_vector(15 downto 0)

		
	);
end entity;

architecture arch of RegisterFile is

	type RegisterArray is array(7 downto 0) of std_logic_vector(15 downto 0);
	signal registers : RegisterArray :=(PC_in, others=>X"0000"); 
begin
   

	
	proc_write : process (write_flag, data_write3, addr3, clk)
	begin
		if (write_flag = '1') then
			if (falling_edge(clk)) then
				
				registers(conv_integer(addr3)) <= data_write3;
			end if;
		end if;
	end process;
	-- Read
	data_read1 <= registers(conv_integer(addr1));
	data_read2 <= registers(conv_integer(addr2));
   PC_out <= registers(7);
   reg0 <= registers(0);
	reg1 <= registers(1);
	reg2 <= registers(2);
	reg3 <= registers(3);
	reg4 <= registers(4);
	reg5 <= registers(5);
	reg6 <= registers(6);
	reg7 <= registers(7);
	
	

	

end architecture;
