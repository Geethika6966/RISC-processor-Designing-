library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is
  port(
      addr, data_write: in std_logic_vector(15 downto 0);
		clk, write_flag: in std_logic;
      data_read: out std_logic_vector(15 downto 0));
end entity;

architecture mem of memory is
  type RAM_array is array (0 to 2**4-1) of std_logic_vector (15 downto 0);
	signal RAM : RAM_array:= (X"3115",X"32C7",X"0050",X"039A",others=>X"0000");
begin
  process(clk, write_flag, data_write, addr, RAM)
    begin
    if rising_edge(clk) then
      if(write_flag = '1') then
        RAM(to_integer(unsigned(addr)))<= data_write;
      end if;
    end if;
      data_read <= RAM(to_integer(unsigned(addr)));
  end process;
end architecture mem;
