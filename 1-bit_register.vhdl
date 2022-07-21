library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

entity OneBitRegister is
	port (
		clk, write_flag, data_write : in std_logic;
		data_read                   : out std_logic
	);
end entity;

architecture arch of OneBitRegister is

	signal r : std_logic := '0';

begin
	data_read <= r;

	proc_write : process (write_flag, data_write, clk)
	begin
		if (write_flag = '1') then
			if (rising_edge(clk)) then
				-- Write
				r <= data_write;
			end if;
		end if;
	end process;

end architecture;
