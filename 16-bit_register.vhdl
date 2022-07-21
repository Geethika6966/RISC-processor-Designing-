library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

entity SixteenBitRegister is
	port (
		clk, write_flag : in std_logic;
		data_write      : in std_logic_vector(15 downto 0);
		data_read       : out std_logic_vector(15 downto 0)
	);
end entity;

architecture arch of SixteenBitRegister is

	signal r : std_logic_vector(15 downto 0) := (others => '0');

begin

	-- Read
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
